clear param_study
%% Set High-Level Hyperparameters for Study
param_study.M = 1:16;
param_study.eps = logspace(log10(0.05),log10(3),75);
param_study.M_count = length(param_study.M);
param_study.eps_count = length(param_study.eps);
% Create Framework for Data Storage
param_study.LOOC_error = NaN(param_study.M_count,param_study.eps_count);

%% Define Functions
[COM_remap,COM_remap_deriv] = COM_remap_define(human_param);
ginv = @(g) g(2:7,:);

%% Main Loop
clear dset
clear model
for M_it = 1:param_study.M_count
    M = param_study.M(M_it);
    % Clustering for Membership Functions
    rng(2);
    clust = COM_cluster_pos_only(human_ts_pairs.next,M,COM_remap);

    for eps_it = 1:param_study.eps_count
        eps = param_study.eps(eps_it);

        % Generate SMP Functions
        [SMP_lift.funcs,SMP_lift.eval,SMP_lift.RBF_centers,SMP_lift.count] = ...
            SMP_RBF_3D_COM_generator_var_eps(clust,COM_remap,COM_remap_deriv,eps);

        % Loop Over Trajectories (LOO)
        running_error = 0;
        for traj_it = 1:human_ts_pairs.traj_count
            % Identify Trajectory and LOO Dataset
            traj = human_ts_pairs.traj{traj_it};
            traj_ts_idxs = human_ts_pairs.idxs{traj_it};
            dset.prev = human_ts_pairs.prev;dset.prev(:,traj_ts_idxs) = [];
            dset.next = human_ts_pairs.next;dset.next(:,traj_ts_idxs) = [];
            % Train LOO Model
            model = koopman_LSQ_train_from_data_regularized(...
                SMP_lift.eval,dset,2e0);
            % Simulation
            sim_steps = size(traj,2)-1;
            z_test_sim_history = NaN(SMP_lift.count,sim_steps+1);
            z_test_sim_history(:,1) = SMP_lift.eval(traj(:,1));
            for t = 1:sim_steps
                z_test_sim_history(:,t+1) = model*z_test_sim_history(:,t);
            end
            state_test_sim_history = ginv(z_test_sim_history);
            % Calculate Trajectory Error
            traj_error = state_test_sim_history - traj;
            error_score = mean(vecnorm(traj_error(1:3,:)));
            running_error = running_error + error_score;
        end
        % Report
        param_study.LOOC_error(M_it,eps_it) = ...
            running_error / human_ts_pairs.traj_count;
        disp(['M ',num2str(M_it),'/',num2str(param_study.M_count),', eps ',num2str(eps_it),'/',num2str(param_study.eps_count),' complete.']);
    end
end

%% Save Dataset
save([folder,'/results_for_figures/paper_param_study_results.m'],"param_study");