% Basic Parameters
lambda = 5; 
mu = 12; 
sim_time = 1e5;  % Total simulation time in minutes

% Theoretical 
[N_theory, T_theory] = MM1_analysis(lambda, mu);

% Simulations
[N_sim, T_sim] = MM1_DES(lambda, mu, sim_time);
T_sim = T_sim * 60;
T_theory = T_theory * 60;

% Result
fprintf('Theory N=%.3f, Simulation N=%.3f\n', N_theory, N_sim);
fprintf('Theory T=%.3f, Simulation T=%.3f\n', T_theory, T_sim);


% M/M/1 Theoretical vs Simulations
subplot(1,2,1);
b = bar([N_theory, N_sim], 'FaceColor', 'flat');
b.CData = [0.2 0.4 0.8;   % Blue for Theory
           1.0 0.5 0.2];  % Orange for Simulation
set(gca, 'xticklabel', {'Theory', 'Simulation'});
ylabel('Avg number in system (N)');
title('System Size');

subplot(1,2,2);
b = bar([T_theory, T_sim], 'FaceColor', 'flat');
b.CData = [0.2 0.4 0.8;   % Blue for Theory
           1.0 0.5 0.2];  % Orange for Simulation
set(gca, 'xticklabel', {'Theory', 'Simulation'});
ylabel('Avg time in system (T) [min]');
title('Waiting Time');


% Plot raw queue length trajectory (excluding customer in service)
[N_sim, T_sim, time_vec, queue_len_vec] = MM1_DES(lambda, mu, sim_time);
max_plot_time = 1e4;   % Only show the first 10,000 minutes for clarity
idx = time_vec < max_plot_time;

figure('Name','M/M/1 Queue Length Trajectory');
plot(time_vec(idx), queue_len_vec(idx), 'b-', 'LineWidth', 1);
yline(mean(queue_len_vec), 'k--', 'Average Queue');
xlabel('Time [minutes]');
ylabel('Queue length (excluding server)');
title('Queue Length over Time — M/M/1');
grid on;
legend('Queue length','Mean queue','Location','best');
