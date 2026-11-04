function [N_theory, T_theory] = MM1K_analysis(lambda, mu, K)
    rho = lambda / mu;
    if rho == 1%Each state from 0 to K is equally likely
        %Blocking Ratio=𝑃k
        pk = ones(1, K+1) / (K+1);
    else
        %Geometric distribution truncated at 𝐾 is used
        pk = (1 - rho) * rho.^(0:K) / (1 - rho^(K+1));
    end
    N_theory = sum((0:K) .* pk);%Weighted sum
    lambda_eff = lambda * (1 - pk(end));
    T_theory = N_theory / lambda_eff;
end