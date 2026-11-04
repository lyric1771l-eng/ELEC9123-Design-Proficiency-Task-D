clc; clear;

% Define simulation parameters
lambda_hr = 10;             % Arrival rate: 10 customers per hour
sim_time_min = 1e7;         % Total simulation duration: 100,000 minutes

% Specify service and arrival time distributions
service_type = 'deterministic';   % Service time distribution:'uniform', or 'deterministic'
arrival_type = 'exponential';     % Arrival time distribution: exponential

% Theoretical analysis using Pollaczek–Khinchine formulas (in MG1_analysis)
[N_th, T_th] = MG1_analysis(lambda_hr, service_type);

% Discrete Event Simulation (DES) of the M/G/1 queue
[N_sim, T_sim, time_vec, queue_len_vec] = MG1_DES(lambda_hr, service_type, arrival_type, sim_time_min);

% Display results in command window
fprintf('\n🔹 M/G/1 Results:\n');
fprintf('Average system size (N): Theory = %.3f | Simulation = %.3f\n', N_th, N_sim);
fprintf('Average time in system (T): Theory = %.3f min | Simulation = %.3f min\n', T_th, T_sim);

% Visual comparison: System size (N)
figure('Name','M/G/1 Comparison');
subplot(1,2,1);
bar([N_th, N_sim]); set(gca, 'xticklabel', {'Theory','Simulation'});
ylabel('Average number in system (N)');
title('System Size Comparison'); grid on;

% Visual comparison: Average time in system (T)
subplot(1,2,2);
bar([T_th, T_sim]); set(gca, 'xticklabel', {'Theory','Simulation'});
ylabel('Average time in system (T) [min]');
title('System Time Comparison'); grid on;


% Time evolution of queue length during simulation
plot_queue_evolution(time_vec, queue_len_vec, 'Queue Length Over Time in M/G/1 System');
