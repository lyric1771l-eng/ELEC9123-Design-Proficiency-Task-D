function [N_theory, T_theory] = MM1_analysis(lambda, mu)
    rho = lambda / mu;
    if rho >= 1
        error('system unstable rho >= 1');
    end
    N_theory = rho / (1 - rho);  % The average system size 
    T_theory = 1 / (mu - lambda); % The average time T 
end
