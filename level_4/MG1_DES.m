function [N_sim, T_sim, time_vec, queue_len_vec] = MG1_DES(lambda_hr, service_type, arrival_type, sim_time_min)
    % Discrete Event Simulation for M/G/1 Queueing System
    %
    % Inputs:
    %   lambda_hr      - Arrival rate (customers per hour)
    %   service_type   - Service time distribution: 'exponential', 'uniform', or 'deterministic'
    %   arrival_type   - Inter-arrival time distribution: same options as above
    %   sim_time_min   - Total simulation duration (minutes)
    %
    % Outputs:
    %   N_sim          - Average number of customers in the system
    %   T_sim          - Average time a customer spends in the system (minutes)
    %   time_vec       - Time stamps for each event
    %   queue_len_vec  - Queue lengths over time (excluding the customer in service)

    rng(1);  % Set fixed random seed to ensure All random functions will use the same sequence
    lambda_min = lambda_hr / 60;  % Convert arrival rate to per-minute units

    % Initialize system variables
    t = 0;                         % Simulation clock time
    departure = inf;              % Next departure time (∞ initially since system is empty)
    arrival = gen_arrival(arrival_type, lambda_min);  % First customer arrival time
    system_size = 0;              % Number of customers currently in the system
    queue = [];                   % Queue holding customer arrival times
    time_last = 0;                % Time of previous event

    % Accumulators for performance metrics
    area_q = 0;                   % Time-integrated system occupancy (for N)
    total_time = 0;               % Sum of customer system times
    num_served = 0;               % Number of customers served

    % Data vectors for visualization
    time_vec = [];                % Event time stamps
    queue_len_vec = [];           % Queue lengths at each recorded event
    service_vec = [];             % Record of service durations for all served customers

    % Simulation loop: continue until simulation time is reached
    while t < sim_time_min
        if arrival < departure
            % Handle arrival event
            t = arrival;
            area_q = area_q + system_size * (t - time_last);  % Update area under system size curve
            time_last = t;

            queue(end+1) = t;          % Log this customer's arrival time
            system_size = system_size + 1;

            if system_size == 1
                % If system was idle, customer begins service immediately
                st = gen_service(service_type);
                service_vec(end+1) = st;
                departure = t + st;    % Schedule departure time
            end

            arrival = t + gen_arrival(arrival_type, lambda_min);  % Generate next arrival
        else
            % Handle departure event
            t = departure;
            area_q = area_q + system_size * (t - time_last);
            time_last = t;

            arrival_time = queue(1);      % Retrieve arrival time of customer leaving
            queue(1) = [];                % Remove customer from queue
            system_size = system_size - 1;

            total_time = total_time + (t - arrival_time);  % Update total time in system
            num_served = num_served + 1;

            if system_size > 0
                % Next customer enters service
                st = gen_service(service_type);
                service_vec(end+1) = st;
                departure = t + st;
            else
                departure = inf;  % No one in system, reset departure
            end
        end

        % Log data for time series visualization
        time_vec(end+1) = t;
        queue_len_vec(end+1) = max(system_size - 1, 0);  % Queue length (excluding person in service)
    end

    % Compute final performance statistics
    N_sim = area_q / t;                     % Average system occupancy
    T_sim = total_time / num_served;        % Average system time per customer

    % Optional debug printout
    fprintf('Total customers served: %d\n', num_served);
    fprintf('Mean service time: %.2f min\n', mean(service_vec));
    fprintf('Mean system time T_sim: %.2f min\n', T_sim);
end

function at = gen_arrival(type, lambda_min)
    % Generate inter-arrival time based on specified distribution
    %
    % Inputs:
    %   type         - Arrival distribution: 'exponential', 'uniform', or 'deterministic'
    %   lambda_min   - Arrival rate per minute
    %
    % Output:
    %   at           - Time until next arrival (in minutes)

    switch lower(type)
        case 'exponential'
            at = exprnd(1 / lambda_min);          % Exponential inter-arrival time
        case 'uniform'
            base = 1 / lambda_min;
            at = base * (0.5 + rand);             % Randomized uniform with same mean
        case 'deterministic'
            at = 1 / lambda_min;                  % Constant inter-arrival time
        otherwise
            error('❌ Invalid arrival type specified');
    end
end

function st = gen_service(type)
    % Generate service time based on specified distribution
    %
    % Input:
    %   type    - Service time distribution: 'exponential', 'uniform', or 'deterministic'
    %
    % Output:
    %   st      - Service time duration (in minutes)

    switch lower(type)
        case 'exponential'
            st = exprnd(5);                       % Mean service time = 5 min (exponential)
        case 'uniform'
            st = 2.5 + (7.5 - 2.5) * rand;         % Uniform between 2.5 and 7.5 minutes
        case 'deterministic'
            st = 5;                                % Fixed service time of 5 minutes
        otherwise
            error('❌ Invalid service type specified');
    end
end
