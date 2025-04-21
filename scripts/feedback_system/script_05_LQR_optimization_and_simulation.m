%% Setting Simulation Duration
sim_steps = 2.5*480/timestep_multiple;

%% Calculating Initial and Final States, and Mean Trajectory
traj_counter = 0;
ave_human_traj = zeros(6,human_dataset.subjects{1}.traj{1}.t_count);
for subj_it = 1:human_dataset.subject_count
    subj = human_dataset.subjects{subj_it};
    for traj_it = 1:subj.traj_count
        traj = subj.traj{traj_it};
        if traj.t_count == human_dataset.subjects{1}.traj{1}.t_count
            ave_human_traj = ave_human_traj + traj.states(1:6,:);
            traj_counter = traj_counter + 1;
        end
    end
end
ave_human_traj = ave_human_traj/traj_counter;
ave_start_state = ave_human_traj(:,1);
ave_end_state = ave_human_traj(:,end);

%% Resample Mean Trajectory for Reference
human_traj_ref = ave_human_traj(:,1:timestep_multiple:(human_dataset.subjects{1}.traj{1}.t_count));

%% Set Start and End (Target) States
start_equil_state = ave_start_state;
end_equil_state = ave_end_state;end_equil_state(4:end) = 0;

%% LQR Calculation
LQR_param_default = zeros(9*M+11,1);

init_param = [0;0;0];
global best_LQR_bias
global LQR_bias
LQR_bias = init_param;
best_LQR_bias = init_param;

LQR_param_update_func = @(LQR_param_now,param_to_optimize,bound) ...
    LQR_meta_optimize_one_param(...
    LQR_param_now,param_to_optimize,SMP_lift,model,end_equil_state,...
    start_equil_state,sim_steps,human_traj_ref,COM_remap,bound);

LQR_param = LQR_param_default;
global best_LQR_param
best_LQR_param = LQR_param_default;
global best_score
best_score = 1e10;

load([folder,'\results_for_figures\paper_CL_results_old.mat']);

global optimization_tracker
optimization_tracker = struct();
optimization_tracker.QR_score = [];
optimization_tracker.bias_score = [];
optimization_tracker.sim_traj = {};
optimization_tracker.model = {};

for cycle_it = 1:6
    for param_it = 1:(9*M+11)
        disp(['Cycle ',num2str(cycle_it),', Param ',num2str(param_it),'/',num2str(9*M+11)]);
        LQR_param_update_func(best_LQR_param,param_it,6);%cycle_it);
    end
end

%% Calculate Optimized K Matrix
K_optim = LQR_V2_extended_K_calculate_free_equilibrium(best_LQR_param,...
     SMP_lift,model,best_LQR_bias);

%% Calculate Closed-Loop Lifted Linear System
A_cl_pre_correct = model.A - model.B*K_optim;

% Apply Post-Correction
A_cl_est = pole_correct_A_matrix(A_cl_pre_correct,0.0077);

A_cl_eig = eig(A_cl_est);
A_cl_eig_mag = abs(A_cl_eig);

%% Lifted Linear Simulation
% Setup
ginv_state_aug = @(z) z(2:10,:);

gamma_init_test = trajectory_match_optimize(start_equil_state,SMP_lift,A_cl_est,human_traj_ref);
z_test_sim_history = NaN(SMP_lift.count,sim_steps+1);
z_test_sim_history(:,1) = SMP_lift.eval(start_equil_state,gamma_init_test);
for t = 1:sim_steps
    z_test_sim_history(:,t+1) = A_cl_est*z_test_sim_history(:,t);
end

state_aug_test_sim_history = ginv_state_aug(z_test_sim_history);

control_history = -K_optim*z_test_sim_history;

%% Save Data from Simulation
save([folder,'/results_for_figures/paper_CL_results.mat'],'A_cl_est',"A_cl_pre_correct",...
    "best_LQR_bias",'best_LQR_param',"clust",'COM_remap',...
    'COM_remap_deriv','human_dataset','human_param','K_optim','M','model',...
    'RBF_centers','RBF_count','RBF_deriv_set','RBF_eval','RBF_set',...
    'SMP_lift',"state_aug_test_sim_history",'z_test_sim_history',...
    'optimization_tracker');