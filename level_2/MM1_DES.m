function [N_sim, T_sim, time_vec, queue_len_vec] = MM1_DES(lambda, mu, runtime)
    % M/M/1 Discrete Event Simulation
    % Inputs:
    %   lambda   - average arrival rate (customers per minute)
    %   mu       - average service rate (customers per minute)
    %   runtime  - total simulation time (in minutes)
    %
    % Outputs:
    %   N_sim         - simulated average number of customers in system
    %   T_sim         - simulated average time spent per customer in system
    %   time_vec      - event timestamps (arrival or departure)
    %   queue_len_vec - number of customers in queue over time (excluding server)

    % Initialize simulation clock
    t = 0;

    % Generate time of first arrival (from exponential distribution)
    arrival = exprnd(1/lambda);

    % No customer is being served at start → no departure scheduled
    departure = inf;

    % Number of customers in system (including one being served)
    system_size = 0;

    % To accumulate area under queue-length curve for computing average
    % For time-weighted integration
    time_last = 0;
    area_under_q = 0;

    % Queue stores arrival timestamps of waiting customers
    queue = [];

    % Track performance stats
    num_served = 0;
    total_system_time = 0;

    % Vectors to store queue state over time
    time_vec = [];
    queue_len_vec = [];

    % Simulation loop: advance through discrete events
    while t < runtime
        if arrival < departure
            % --- ARRIVAL EVENT ---
            t = arrival;

            % Update time-weighted queue length accumulator since the last event
            area_under_q = area_under_q + system_size * (t - time_last);
            time_last = t;

            % Customer joins system
            queue(end+1) = t;
            system_size = system_size + 1;

            % If server was idle, schedule departure（idle before this arrive）
            if system_size == 1
                departure = t + exprnd(1/mu);
            end

            % Schedule next arrival
            arrival = t + exprnd(1/lambda);

        else
            % --- DEPARTURE EVENT ---
            t = departure;

            % Update time-weighted queue length
            area_under_q = area_under_q + system_size * (t - time_last);
            time_last = t;

            % Remove the next customer from queue
            arrival_time = queue(1);
            queue(1) = [];
            system_size = system_size - 1;

            % Compute time this customer spent in system
            total_system_time = total_system_time + (t - arrival_time);
            num_served = num_served + 1;

            % Schedule departure of next customer if anyone is waiting
            if system_size > 0
                departure = t + exprnd(1/mu);
            else
                departure = inf; % no one to serve
            end
        end

        % Record the system state for plotting queue length over time
        time_vec(end+1) = t;
        queue_len_vec(end+1) = max(system_size - 1, 0); % exclude the server
    end

    % Compute simulated average system size and average time in system
    N_sim = area_under_q / t;
    T_sim = total_system_time / num_served;
end
