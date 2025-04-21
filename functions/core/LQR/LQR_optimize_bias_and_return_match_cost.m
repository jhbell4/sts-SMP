function cost = LQR_optimize_bias_and_return_match_cost(...
    LQR_param,SMP_lift,model,end_equil_state,...
    x_init,steps_to_sim,human_traj_ref,COM_remap)
%LQR_OPTIMIZE_BIAS Summary of this function goes here
%   Detailed explanation goes here

%% Load Initial Guess from Global Memory
global LQR_bias
global best_LQR_bias

%% Optimize Bias
% Define Cost Function
objfungrad = @(param) LQR_V2_fit_cost_evaluate_equilibrium(...
    LQR_param,SMP_lift,model,param(1:3),end_equil_state);
% Optimization Options
options = optimoptions('fminunc',...
    ...%'StepTolerance',1e-12,...
    'Display','none',...
    'MaxFunctionEvaluations',5e4,...
    'SpecifyObjectiveGradient',false);
% Run Optimization
[LQR_bias,target_cost] = fminunc(objfungrad,best_LQR_bias,options);

%% Calculate Whole-Trajectory Prediction Error
% Calculate Feedback Gain Matrix
K_phys = LQR_V2_extended_K_calculate_free_equilibrium(LQR_param,...
     SMP_lift,model,LQR_bias);

% Calculate Closed-Loop Lifted Linear System
A_cl_est = model.A - model.B*K_phys;

% Apply Post-Correction
A_cl_est = pole_correct_A_matrix(A_cl_est,0.0077);

% Lifted Linear Simulation
gamma_init = trajectory_match_optimize(x_init,SMP_lift,A_cl_est,human_traj_ref);

ginv_x = @(z) z(2:7,:);
x_test_sim_history = NaN(6,steps_to_sim+1);
x_test_sim_history(:,1) = x_init(1:6);

z = SMP_lift.eval(x_test_sim_history(:,1),gamma_init);
for t = 1:steps_to_sim
    z = A_cl_est*z;
    x_test_sim_history(:,t+1) = ginv_x(z);
end

% Calculate Residual
pred_resid = x_test_sim_history - human_traj_ref;
resid_norm = vecnorm(pred_resid);
state_cost = mean(resid_norm);

% Calculate Residual for COM Matching
COM_resid = COM_remap(x_test_sim_history) - COM_remap(human_traj_ref);
COM_resid_norm = vecnorm(COM_resid);
COM_cost = mean(COM_resid_norm);

% Combine costs
COM_focus = 1e1;
cost = COM_focus*COM_cost + state_cost;

%% Judge Cost
global best_score
global best_LQR_param
global optimization_tracker
if cost < best_score
    best_score = cost
    target_cost
    best_LQR_bias = LQR_bias;
    best_LQR_param = LQR_param;

    optimization_tracker.QR_score = [optimization_tracker.QR_score,cost];
    optimization_tracker.bias_score = [optimization_tracker.bias_score,target_cost];
    optimization_tracker.sim_traj = [optimization_tracker.sim_traj,{x_test_sim_history}];
    optimization_tracker.model = [optimization_tracker.model,{A_cl_est}];
end

end

