function [cost] = LQR_V2_fit_cost_evaluate_equilibrium(...
    LQR_param,SMP_lift,model,free_param,equil_state)
%LQR_ERROR_EVALUATE Feed in vector of LQR parameters and human dataset,
% output error score
%   Detailed explanation goes here

%% Calculate K Matrix
K = LQR_V2_extended_K_calculate_free_equilibrium(...
    LQR_param,SMP_lift,model,free_param);

%% Calculate Closed-Loop System Properties
A_cl_est = model.A - model.B*K;

% Apply Post-Correction
A_cl_est = pole_correct_A_matrix(A_cl_est,0.0077);

[A_cl_evec, A_cl_eval] = eig(A_cl_est);
A_cl_eval_mag = abs(diag(A_cl_eval));
[~,max_eval_loc] = max(A_cl_eval_mag);
max_eval_evec = A_cl_evec(:,max_eval_loc);
max_eval_evec = max_eval_evec / max_eval_evec(1);

%% Calculate Eigenvector Cost (Angles Only)
cost = vecnorm(max_eval_evec(2:4) - equil_state(1:3)).^2;

end