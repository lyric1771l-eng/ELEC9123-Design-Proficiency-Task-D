function [N_theory, T_theory] = MG1_analysis(lambda_hr, service_type)
    % lambda_hr: customers/hour
    % service_type: 'uniform' or 'deterministic'
    mu=12;
    X_mean_min = 5;

    switch service_type
        case 'uniform'
            a = 2.5; b = 7.5;
            X2_min2 = (a^2 + a*b + b^2)/3;
            X2_hr2 = X2_min2 / 3600;
        case 'deterministic'
            X2_min2 = X_mean_min^2;
            X2_hr2 = X2_min2 / 3600;
        otherwise
            error('Invalid service type');
    end

   
    rho = lambda_hr / mu;
    fprintf('利用率 rho = %.3f\n', rho);

    if rho >= 1
        error('System unstable: rho >= 1');
    end

    % Pollaczek–Khinchin formula
    N_theory = rho + (lambda_hr^2 * X2_hr2) / (2 * (1 - rho));
    T_theory = (1/mu + (lambda_hr * X2_hr2) / (2 * (1 - rho)))*60;  
end
