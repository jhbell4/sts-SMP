%% Load Datasets and Set Meta-Variables
% Human Dataset
load([folder,'/human_datasets/human_dataset_N_time_cutoff.mat']);

timestep_multiple = 1;
sim_dt = human_dataset.timing.base_dt*timestep_multiple;

act_time_constant = 0.077;%s

% Simulated Dataset
dset_path = [folder,'/sim_datasets/sim_dataset_dt_',num2str(timestep_multiple),...
    '_atc_',num2str(1000*act_time_constant),'.mat'];
load(dset_path);

%% Define COM Remap Function
[COM_remap,COM_remap_deriv] = COM_remap_define(human_param);

%% Create Combined Dump of States from all Trajectories
all_states_dump = [];
for subj_it = 1:human_dataset.subject_count
    subj = human_dataset.subjects{subj_it};
    for traj_it = 1:subj.traj_count
        traj = subj.traj{traj_it};
        all_states_dump = [all_states_dump,traj.states];
    end
end

%% Set Membership Function Hyperparameters
M = 2;
eps = 1;

%% Clustering
rng(2);
clust = COM_cluster_pos_only(all_states_dump,M,COM_remap);

%% Generate Membership Functions
[RBF_set,RBF_eval,RBF_centers,RBF_count,...
    RBF_deriv_set] = ...
    RBF_3D_COM_generator_var_eps(clust,COM_remap,COM_remap_deriv,eps);

%% Generate SMP Lifting Function and Inverse
[SMP_lift.funcs,SMP_lift.eval,SMP_lift.RBF_centers,SMP_lift.count] = ...
    SMP_CCK_RBF_3D_COM_generator_var_eps(clust,COM_remap,COM_remap_deriv,eps);

ginv = @(z) z(2:10,:);

%% Koopman Model Training
clear model

model = koopman_CCK_LSQ_train_from_data_regularized(...
    SMP_lift.eval,sim_dataset,1e-2);