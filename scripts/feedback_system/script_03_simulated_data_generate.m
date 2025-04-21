%% Load Human Dataset
load([folder,'/human_datasets/human_dataset_N_time_cutoff.mat']);

count_traj = 0;
for subj_it = 1:human_dataset.subject_count
    count_traj = count_traj + human_dataset.subjects{subj_it}.traj_count;
end
% count_traj should be 129, for reference.

%% Set Core Dataset Parameters to Vary
% For reference, factors of 480Hz:
% 1: 2.1ms, 2: 4.2ms, 3: 6.3ms, 4: 8.3ms, 5: 10.4ms, 6: 12.5ms, 8: 16.7ms
% 10: 20.8ms, 12: 25.0ms, 15: 31.2ms, 16: 33.3ms, 20: 41.7ms, 24: 50.0ms
% 30: 62.5ms, 32: 66.7ms, 40: 83.3ms, 48: 100.0ms, 60: 125.0ms, 80: 166.7ms
% 96: 200.0ms, 120: 250.0ms, 160: 333.3ms, 240: 500.0ms, 480: 1000.0ms
timestep_multiple = 1;%10
sim_dt = human_dataset.timing.base_dt*timestep_multiple;

act_time_constant = 0.077;%s

%% Set Simulation "Constants"
% Actuator Stiffness
act_stiffness = 4;%N*m/rad (Oatis 1993)
% Seat Height Offset
seat_height_offset = 0.03;%m

%% Create Actuator Parameters Object
clear actuator_param
actuator_param.time_constant = act_time_constant;
actuator_param.stiffness = act_stiffness;

%% Set Up Random Sampling Coefficients for Data Collection
% Input Torque and Actuator State
input_std = 150;%N*m
gamma_var_std = input_std/act_stiffness;
% Angle and Angular Velocity Variation (relative to human dataset)
theta_var_std = 0.03;%rad
theta_d_var_std = 0.05;%rad/s

%% Specify Data Count
N_sim_per_traj = 5e3;
N_sim = N_sim_per_traj*count_traj;

%% Set Up Simulation Data Structure
clear sim_dataset
sim_dataset.N_sim = N_sim;
sim_dataset.state_aug.prev = NaN(9,N_sim);
sim_dataset.state_aug.next = NaN(9,N_sim);
sim_dataset.input = NaN(3,N_sim);

%% Run Simulations
% Pre-Setup
sim_count_cumulative = 0;
rng('default');
% Runs
for subj_it = 1:human_dataset.subject_count
    subj = human_dataset.subjects{subj_it};
    for traj_it = 1:subj.traj_count
        traj = subj.traj{traj_it};

        % % Calculate Seat Height for Current Trajectory
        seat_height = calculate_seat_height_from_start_angle(...
            traj.states(1:3,1),human_param,seat_height_offset);

        % % Randomly Generate Data from Trajectory
        % Randomly Generate Indices to Sample Trajectory
        human_traj_ind = randi(traj.t_count,1,N_sim_per_traj);
        human_traj_state = traj.states(1:6,human_traj_ind);
        % Randomly Generate Angle Perturbations
        theta_pert = normrnd(0,theta_var_std,3,N_sim_per_traj);
        % Randomly Generate Angular Velocity Perturbations
        theta_d_pert = normrnd(0,theta_d_var_std,3,N_sim_per_traj);
        % Randomly Generate Actuator State Perturbations
        gamma_pert = normrnd(0,gamma_var_std,3,N_sim_per_traj);
        % Randomly Generate Input Perturbations
        input_pert = normrnd(0,input_std,3,N_sim_per_traj);
        % Add Perturbations to form Trajectory Initial Conditions
        theta_ic = human_traj_state(1:3,:) + theta_pert;
        theta_d_ic = human_traj_state(4:6,:) + theta_d_pert;
        gamma_ic = theta_ic + gamma_pert;
        input_ic = input_pert;
        state_aug_ic = [theta_ic;theta_d_ic;gamma_ic];

        % % Generate Dynamics for Current Trajectory's Seat Height
        sim_dyn = dynamic_timestep_evaluator(...
            human_param,actuator_param,seat_height,sim_dt,20);

        % % Run Simulations for Trajectory
        for sim_it = 1:N_sim_per_traj
            % Unpack Initial Condition and Input
            state_aug_prev = state_aug_ic(:,sim_it);
            input = input_ic(:,sim_it);
            % Run Simulation
            state_aug_next = sim_dyn(state_aug_prev,input);
            % Store Simulation Values
            storage_idx = sim_count_cumulative + sim_it;
            sim_dataset.state_aug.prev(:,storage_idx) = state_aug_prev;
            sim_dataset.state_aug.next(:,storage_idx) = state_aug_next;
            sim_dataset.input(:,storage_idx) = input;
        end
        % Iterate Cumuluative Value
        sim_count_cumulative = sim_count_cumulative + N_sim_per_traj;
        % Report Progress
        disp(['Subj ',num2str(subj_it),'/',...
            num2str(human_dataset.subject_count),', Traj ',...
            num2str(traj_it),'/',num2str(subj.traj_count),...
            ' complete at ',char(datetime('now')),'.']);
    end
end

%% Save Dataset
dset_path = [folder,'/sim_datasets/sim_dataset_dt_',num2str(timestep_multiple),...
    '_atc_',num2str(1000*act_time_constant),'.mat'];
save(dset_path,'sim_dataset');