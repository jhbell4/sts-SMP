function K = LQR_V2_extended_K_calculate_free_equilibrium(LQR_param,SMP_lift,model,free_param)
%LQR_EXTENDED_K_CALCULATE Summary of this function goes here
%   Detailed explanation goes here

%% Construct the Q and R Matrices
[Q,R] = QR_matrix_construct_V2(LQR_param,SMP_lift);

%% Compute the LQR Solution
K_LQR = dlqr(model.A(2:end,2:end),model.B(2:end,:),Q,R);

%% Add in the bias term
free_param = reshape(free_param,[],1);
K = [free_param, K_LQR];

end

