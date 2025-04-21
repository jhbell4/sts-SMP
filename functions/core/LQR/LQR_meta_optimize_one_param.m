function new_LQR_param = LQR_meta_optimize_one_param(...
    LQR_param,param_to_optimize,SMP_lift,model,end_equil_state,...
    x_init,steps_to_sim,human_traj_ref,COM_remap,bound)
%LQR_META_OPTIMIZE_ONE_PARAM Summary of this function goes here
%   Detailed explanation goes here

%% Define Initial Condition
init_param = LQR_param(param_to_optimize);
% Define Cost Function
objfun = @(param) LQR_optimize_bias_and_return_match_cost(...
    vec_sub(LQR_param,param_to_optimize,param),...
    SMP_lift,model,end_equil_state,...
    x_init,steps_to_sim,human_traj_ref,COM_remap);
% Optimization Options
options = optimoptions('fmincon',...
    ...%'StepTolerance',1e-12,...
    'Display','none',...
    'MaxFunctionEvaluations',5e4,...
    'SpecifyObjectiveGradient',false);
% Bounds
if nargin < 10
    lb = -4;
    ub = 4;
else
    lb = -bound;
    ub = bound;
end
% Run Optimization
optim_param = ...
    fmincon(objfun,init_param,[],[],[],[],lb,ub,[],options);
% Run Single Simulation Using Optimized Parameter
new_LQR_param = vec_sub(LQR_param,param_to_optimize,optim_param);
% optim_score = LQR_optimize_bias_and_return_match_cost(...
%     new_LQR_param,...
%     SMP_lift,model,end_equil_info,...
%     x_init,steps_to_sim,human_traj_ref,COM_remap)
% Package Optimized Parameter
% global best_score
% best_score
% if optim_score < best_score
%     best_score = optim_score;
% else
%     new_LQR_param = LQR_param;
% end

end

function new_vec = vec_sub(old_vec,place,new)

new_vec = old_vec;
new_vec(place) = new;

end