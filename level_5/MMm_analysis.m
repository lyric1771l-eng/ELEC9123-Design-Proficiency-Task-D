function [N, T_min, N_Q, p0, rho] = MMm_analysis(lambda_hr, mu_hr, m)
    % M/M/m Theoretical Analysis Based on Textbook Formulas
    %
    % Inputs:
    %   lambda_hr  - Arrival rate (customers per hour)
    %   mu_hr      - Service rate per server (customers per hour)
    %   m          - Number of parallel servers in the system
    %
    % Outputs:
    %   N          - Average number of customers in the system
    %   T_min      - Average time a customer spends in the system (in minutes)
    %   N_Q        - Average number of customers waiting in queue
    %   p0         - Probability that the system is completely idle
    %   rho        - Server utilization (traffic intensity per server)

    % Calculate server utilization (should be less than 1 for stable system)
    rho = lambda_hr / (m * mu_hr);
    if rho >= 1
        error('❌ System is unstable: utilization ρ ≥ 1');
    end

    % Total offered load to system (m * rho = λ / μ)
    a = m * rho;

    % Compute the normalization term (denominator for p0):
    % sum over k = 0 to m-1 of (a^k) / k!
    sum_terms = 0;
    for k = 0:(m-1)
        sum_terms = sum_terms + (a^k) / factorial(k);
    end

    % Tail term: probability weight of m or more customers in system
    tail_term = (a^m / factorial(m)) * (1 / (1 - rho));

    % p0: probability that the system is empty (no customers)
    p0 = 1 / (sum_terms + tail_term);

    % Compute the average number of customers in queue (E[N_Q])
    % This follows the Erlang-C formula
    N_Q = p0 * (a^m / factorial(m)) * (rho / (1 - rho)^2);

    % Total number in system = in queue + in service
    N = N_Q + a;

    % Compute average system time using textbook breakdown:
    %   T = queueing time + service time
    %   T_Q = N_Q / λ, 1/μ = mean service time
    T_Q_hr = N_Q / lambda_hr;
    T_hr = T_Q_hr + 1 / mu_hr;

    % Convert time from hours to minutes
    T_min = T_hr * 60;
end
