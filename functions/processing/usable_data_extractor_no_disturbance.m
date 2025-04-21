function usable_dataset = ...
    usable_data_extractor_no_disturbance(dataset)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% Setup
traj_count = dataset.traj_metadata.traj_count;

sample_freq = 480;%Hz

state_names = {'theta_1','theta_2','theta_3','theta_1_d','theta_2_d',...
    'theta_3_d','theta_1_dd','theta_2_dd','theta_3_dd'};

usable_dataset = dataset;

usable_dataset.traj = {};
usable_dataset = rmfield(usable_dataset,'traj_metadata');

%% Main Looping
for it = 1:traj_count
    clear cropped
    clear recombined

    traj = dataset.traj{it};
    % Eliminate Trajectories with a Disturbance
     if traj.label > 2
         break
     end

    % Define Extent of Data to Be Captured
    start_index = traj.sync_idxs(1);
    end_index = length(traj.skel_mocap.joint_angles.theta_1);
    
    % Create Time Vector
    cropped.time = ((0:(end_index-start_index))/sample_freq).';

    % Crop Data
    crop_indices = start_index:end_index;
    for state_name = state_names
        cropped.(state_name{1}) = ...
            traj.skel_mocap.joint_angles.(state_name{1})(crop_indices);
    end

    % Combine States Vectors into Matrix (and transpose)
    recombined.time = cropped.time.';
    recombined.states = ...
        [cropped.theta_1,cropped.theta_2,cropped.theta_3,...
        cropped.theta_1_d,cropped.theta_2_d,cropped.theta_3_d,...
        cropped.theta_1_dd,cropped.theta_2_dd,cropped.theta_3_dd].';
    recombined.t_count = length(recombined.time);

    % Saving
    usable_dataset.traj{it} = recombined;

    clear cropped;
end

usable_dataset.traj_count = length(usable_dataset.traj);

end