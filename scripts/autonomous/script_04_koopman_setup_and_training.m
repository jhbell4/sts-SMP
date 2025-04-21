%% Define COM Remap Function
[COM_remap,COM_remap_deriv] = COM_remap_define(human_param);

%% Set Membership Function Hyperparameters
M = 4;
eps = 1.8;

%% Clustering
rng(2);
clust = COM_cluster_pos_only(human_ts_pairs.next,M,COM_remap);

%% Generate Membership Functions
[RBF_set,RBF_eval,RBF_centers,RBF_count,...
    RBF_deriv_set] = ...
    RBF_3D_COM_generator_var_eps(clust,COM_remap,COM_remap_deriv,eps);

%% Generate SMP Lifting Function and Inverse
[SMP_lift.funcs,SMP_lift.eval,SMP_lift.RBF_centers,SMP_lift.count] = ...
    SMP_RBF_3D_COM_generator_var_eps(clust,COM_remap,COM_remap_deriv,eps);

ginv = @(z) z(2:7,:);

%% Koopman Model Training
clear model

model = koopman_LSQ_train_from_data_regularized(...
    SMP_lift.eval,human_ts_pairs,2e0);%3e0

%% Calculate Eigenvalues
eig_A_cl = eig(model);
mag_eig_A_cl = abs(eig_A_cl);