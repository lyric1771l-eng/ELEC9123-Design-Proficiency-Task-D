function [N_sim, T_sim, time_vec, queue_len_vec] = MM1K_DES(lambda, mu, runtime, K)
    % M/M/1/K Discrete Event Simulation (finite capacity system)
    % Inputs:
    %   lambda   - average arrival rate (customers per minute)
    %   mu       - average service rate (customers per minute)
    %   runtime  - total simulation time (in minutes)
    %   K        - system capacity including server
    %
    % Outputs:
    %   N_sim         - simulated average number of customers in system
    %   T_sim         - simulated average time spent per accepted customer
    %   time_vec      - event timestamps
    %   queue_len_vec - queue length trajectory (excluding customer in service)

    t = 0;                             % Simulation clock
    arrival = exprnd(1/lambda);       % First arrival event
    departure = inf;                  % No one in service yet
    system_size = 0;                  % Current number of customers in system
    time_last = 0;                    % Time of last event
    area_under_q = 0;                 % Used to calculate average system size

    queue = [];                       % Queue of waiting customers
    total_system_time = 0;            % Cumulative time in system
    num_served = 0;                   % Number of accepted and served customers
    blocked = 0;                      % Number of rejected customers

    time_vec = [];                    % Timestamp log
    queue_len_vec = [];               % Queue length log (excluding server)

    while t < runtime
        if arrival < departure
            % --- ARRIVAL EVENT ---
            t = arrival;
            area_under_q = area_under_q + system_size * (t - time_last);
            time_last = t;

            if system_size < K
                % Accept customer into system
                queue(end+1) = t;
                system_size = system_size + 1;

                % If idle, begin service immediately
                if system_size == 1
                    departure = t + exprnd(1/mu);
                end
            else
                % System full → reject customer
                blocked = blocked + 1;
            end

            % Schedule next arrival
            arrival = t + exprnd(1/lambda);

        else
            % --- DEPARTURE EVENT ---
            t = departure;
            area_under_q = area_under_q + system_size * (t - time_last);
            time_last = t;

            % Dequeue customer who is leaving
            arrival_time = queue(1);
            queue(1) = [];
            system_size = system_size - 1;

            total_system_time = total_system_time + (t - arrival_time);
            num_served = num_served + 1;

            % Next departure?
            if system_size > 0
                departure = t + exprnd(1/mu);
            else
                departure = inf;
            end
        end

        % Log the system queue state at each event
        time_vec(end+1) = t;
        queue_len_vec(end+1) = max(system_size - 1, 0); % exclude current service
    end

    % Effective arrival rate (accepted customers only)
    lambda_eff = num_served / t;

    % Performance metrics
    N_sim = area_under_q / t;
    T_sim = total_system_time / num_served;
end
