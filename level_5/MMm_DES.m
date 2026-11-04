function [N_sim, T_sim, time_vec, queue_len_vec] = MMm_DES(lambda_hr, mu_hr, m, sim_time_min)
    % Discrete Event Simulation for M/M/m Queueing System with accurate time tracking.
    %
    % Inputs:
    %   lambda_hr     - Arrival rate in customers per hour.
    %   mu_hr         - Service rate per server in customers per hour.
    %   m             - Number of parallel servers.
    %   sim_time_min  - Total simulation duration (in minutes).
    %
    % Outputs:
    %   N_sim         - Average number of customers in the system.
    %   T_sim         - Average time a customer spends in the system (in minutes).
    %   time_vec      - Vector of event timestamps.
    %   queue_len_vec - Vector of queue lengths at each event (excluding those in service).

    rng(1);  % Set random seed for reproducibility

    % Convert rates to per-minute units for consistency
    lambda_min = lambda_hr / 60;  % Arrival rate per minute
    mu_min = mu_hr / 60;          % Service rate per server per minute

    % Initialize system clock and state
    t = 0;                        % Current simulation time
    time_last = 0;                % Time of previous event
    arrival = exprnd(1 / lambda_min);  % Time of next arrival
    departure_times = inf(1, m);        % Scheduled departure times for each server
    server_busy = false(1, m);          % Server availability status
    queue = [];                         % FIFO queue of waiting customers
    arrival_log = [];                   % Log of arrival times (for calculating system time)
    system_size = 0;                    % Total number of customers in the system

    % Accumulators for performance metrics
    area_q = 0;           % Time-integrated number of customers in system (used for N)
    total_time = 0;       % Total time spent by all served customers
    num_served = 0;       % Number of customers who completed service

    % Vectors for plotting dynamics
    time_vec = [];        % Event timestamps
    queue_len_vec = [];   % Queue lengths over time

    % Simulation loop: run until total simulated time is reached
    while t < sim_time_min
        [next_departure, srv_idx] = min(departure_times);  % Find next scheduled departure
        if arrival < next_departure
            % Event: Customer arrives
            t = arrival;
            area_q = area_q + system_size * (t - time_last);  % Update integral for N
            time_last = t;
            system_size = system_size + 1;

            arrival_log(end+1) = t;  % Record customer's arrival time

            free_idx = find(~server_busy, 1);  % Look for available server
            if ~isempty(free_idx)
                st = exprnd(1 / mu_min);       % Generate service time
                departure_times(free_idx) = t + st;%Set the departure time of this customer (current time + service time)
                server_busy(free_idx) = true;%This server is "busy".
            else
                queue(end+1) = t;  % No free server → customer waits in queue
            end
            arrival = t + exprnd(1 / lambda_min);  % Schedule next arrival

        else
            % Event: Customer departs (service completion)
            t = next_departure;
            area_q = area_q + system_size * (t - time_last);
            time_last = t;

            departure_times(srv_idx) = inf;       % Clear departure slot
            server_busy(srv_idx) = false;         % Mark server as available
            system_size = system_size - 1;
            num_served = num_served + 1;

            % Retrieve corresponding arrival time and compute time spent in system
            arrival_time = arrival_log(1);
            arrival_log(1) = [];
            total_time = total_time + (t - arrival_time);

            if ~isempty(queue)
                st = exprnd(1 / mu_min);            % Assign next queued customer to server
                departure_times(srv_idx) = t + st;  %The expected departure time of new customers
                server_busy(srv_idx) = true;
                queue(1) = [];                       % Remove from queue
            end
        end

        % Log event details for visualization
        time_vec(end+1) = t;
        queue_len_vec(end+1) = max(system_size - m, 0);  % Only count those waiting (exclude service)
    end

    % Compute performance metrics
    N_sim = area_q / t;                    % Time-average system occupancy
    T_sim = total_time / num_served;       % Average system time per customer

    % Optional debug output
    fprintf('✔️ Total customers served: %d\n', num_served);
    fprintf('✔️ Average number in system (N_sim): %.3f\n', N_sim);
    fprintf('✔️ Average time in system (T_sim): %.2f minutes\n', T_sim);
end
