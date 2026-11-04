clc; clear; close all;

% Simulation duration (in minutes)
sim_time_min = 1e5;

% ✈️ Dual-class queueing system parameters
% Business class settings
lambda_b = 20;         % Arrival rate (customers per hour) for Business class
mu_b = 60 / 2.5;       % Service rate per server (customers per hour), assuming avg 2.5 min service
mb = 2;                % Number of service counters for Business class

% Economy class settings
lambda_e = 100;        % Arrival rate (customers per hour) for Economy class
mu_e = 60 / 2.5;       % Service rate per server (customers per hour), same service duration
me = 5;                % Number of service counters for Economy class

% Theoretical performance analysis for Business class
fprintf('\n Business Class Analysis:\n');
[N_b, T_b, NQ_b, p0_b, rho_b] = MMm_analysis(lambda_b, mu_b, mb);
fprintf('Utilization ρ_b = %.3f\n', rho_b);
fprintf('Idle probability p0_b = %.3f\n', p0_b);
fprintf('Avg. queue length NQ_b = %.3f\n', NQ_b);
fprintf('Avg. system size N_b = %.3f\n', N_b);
fprintf('Avg. system time T_b = %.2f min\n', T_b);

% Theoretical performance analysis for Economy class
fprintf('\n Economy Class Analysis:\n');
[N_e, T_e, NQ_e, p0_e, rho_e] = MMm_analysis(lambda_e, mu_e, me);
fprintf('Utilization ρ_e = %.3f\n', rho_e);
fprintf('Idle probability p0_e = %.3f\n', p0_e);
fprintf('Avg. queue length NQ_e = %.3f\n', NQ_e);
fprintf('Avg. system size N_e = %.3f\n', N_e);
fprintf('Avg. system time T_e = %.2f min\n', T_e);

% Visualization: Theoretical comparison between classes
figure('Name','Performance Comparison by Class','Color','w');
bar([N_b, N_e; T_b, T_e]');
set(gca, 'xticklabel', {'Business','Economy'});
legend('System Size N','System Time T (min)');
title('Theoretical Performance Comparison (M/M/m)');
ylabel('Value'); grid on;

% Discrete Event Simulation for Business class
[Nb_sim, Tb_sim, tb_vec, qb_vec] = MMm_DES(lambda_b, mu_b, mb, sim_time_min);
fprintf('\n🎯 Business Class Simulation Results: N_sim = %.2f, T_sim = %.2f min\n', Nb_sim, Tb_sim);

% Discrete Event Simulation for Economy class
[Ne_sim, Te_sim, te_vec, qe_vec] = MMm_DES(lambda_e, mu_e, me, sim_time_min);
fprintf('🎯 Economy Class Simulation Results: N_sim = %.2f, T_sim = %.2f min\n', Ne_sim, Te_sim);

% Visualization: System time comparison (Theory vs Simulation)
figure('Name','System Time: Theory vs Simulation');
bar([T_b, T_e; Tb_sim, Te_sim]');
set(gca, 'xticklabel', {'Business','Economy'});
legend('Theory','Simulation');
ylabel('System Time T (min)');
title('Average time in system (T) [min]'); grid on;

% Visualization: System size comparison (Theory vs Simulation)
figure('Name','System Size: Theory vs Simulation','Color','w');
bar([N_b, N_e; Nb_sim, Ne_sim]');
set(gca, 'xticklabel', {'Business','Economy'});
legend('Theory','Simulation');
ylabel('System Size N');
title('Average number in system (N)'); grid on;

% Time evolution of queue length for both classes
figure('Name','Queue Length Over Time (Dual Class)');
subplot(2,1,1);
plot(tb_vec, qb_vec, 'LineWidth', 1.5);
title('Queue Length - Business Class');
xlabel('Time (min)'); ylabel('Customers in Queue'); grid on;

subplot(2,1,2);
plot(te_vec, qe_vec, 'LineWidth', 1.5);
title('Queue Length - Economy Class');
xlabel('Time (min)'); ylabel('Customers in Queue'); grid on;
