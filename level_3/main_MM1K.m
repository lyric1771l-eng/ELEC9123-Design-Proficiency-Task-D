clc; clear;

%% ---------------------------
% Basic Parameters
% ---------------------------
lambda = 10;      % arrival rate (customers/hour)
K = 5;           % system capacity
sim_time = 1e5;   % simulation time in minutes

% Case 1: μ = 12 (5 minutes service time)
mu1 = 12;

% Case 2: μ = 10 (6 minutes service time)
mu2 = 10;

%% ---------------------------
% Theoretical 
% ---------------------------
[N1_th, T1_th] = MM1K_analysis(lambda, mu1, K);
[N2_th, T2_th] = MM1K_analysis(lambda, mu2, K);
T1_theory = T1_th * 60;
T2_theory = T2_th * 60;

%% ---------------------------
% Simulations
% ---------------------------
[N1_sim, T1_sim, t1, q1] = MM1K_DES(lambda, mu1, sim_time, K);
[N2_sim, T2_sim, t2, q2] = MM1K_DES(lambda, mu2, sim_time, K);
T1_simulation = T1_sim * 60;
T2_simulation = T2_sim * 60;

%% ---------------------------
% Bar Comparison Plot
% ---------------------------
figure('Name','M/M/1/K Performance Comparison');

subplot(1,2,1);
bar([N1_th N1_sim; N2_th N2_sim]);
set(gca, 'xticklabel', {'Case 1: μ=12','Case 2: μ=10'});
ylabel('Average number in system (N)');
legend('Theory','Simulation');
title('System Size Comparison');
grid on;

subplot(1,2,2);
bar([T1_theory T1_simulation; T2_theory T2_simulation]);
set(gca, 'xticklabel', {'Case 1: μ=12','Case 2: μ=10'});
ylabel('Average time in system (T)');
legend('Theory','Simulation');
title('Waiting Time Comparison');
grid on;

%% ---------------------------
% Queue Length Trajectory
% ---------------------------
figure('Name','Queue Length Trajectories');

subplot(2,1,1);
plot(t1(t1<1e4), q1(t1<1e4), 'b');
yline(K-1,'--k','K-1');
yline(mean(q1),'--r','Avg Queue');
title('Queue Length vs Time – Case 1: μ=12'); ylabel('Queue Length');
grid on;

subplot(2,1,2);
plot(t2(t2<1e4), q2(t2<1e4), 'r');
yline(K-1,'--k','K-1');
yline(mean(q2),'--r','Avg Queue');
xlabel('Time (minutes)'); ylabel('Queue Length');
title('Queue Length vs Time – Case 2: μ=10');
grid on;

% 📘 Display results in command window
fprintf('\n🔹 M/M/1/K Case 1: μ = 12 :\n');
fprintf('Average system size (N): Theory = %.3f | Simulation = %.3f\n', N1_th, N1_sim);
fprintf('Average time in system (T): Theory = %.3f min | Simulation = %.3f min\n', T1_th, T1_sim);
fprintf('\n🔹 M/M/1/K Case 2: μ = 10 :\n');
fprintf('Average system size (N): Theory = %.3f | Simulation = %.3f\n', N2_th, N2_sim);
fprintf('Average time in system (T): Theory = %.3f min | Simulation = %.3f min\n', T2_th, T2_sim);
