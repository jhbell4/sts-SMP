function data_struct = holmes_dataloader_joint_angles(data_filename)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Load Content
load(data_filename,...
    'nominal_sts_type','subject','subject_mass','traj','traj_metadata');

data_struct.nominal_sts_type = nominal_sts_type;
data_struct.subject = subject;
data_struct.subject_mass = subject_mass;
data_struct.traj = traj;
data_struct.traj_metadata = traj_metadata;

%% Basic Preproccessing
data_struct.traj_metadata.traj_count = length(traj);

%% Calculations
% Prep Structure for Length Storage
l1_storage = NaN(1,data_struct.traj_metadata.traj_count);
l2_storage = NaN(1,data_struct.traj_metadata.traj_count);
l3_storage = NaN(1,data_struct.traj_metadata.traj_count);

for it = 1:(data_struct.traj_metadata.traj_count)
    joints = data_struct.traj{it}.skel_mocap.joints;
    
    % Segments
    shin = ((joints.lknee + joints.rknee)...
        - (joints.lankle + joints.rankle))/2;
    thigh = ((joints.lhip + joints.rhip)...
        - (joints.lknee + joints.rknee))/2;
    torso = joints.shoulder - (joints.lhip + joints.rhip)/2;
    
    % Absolute Segment Angles
    shin_angle = atan2(shin(:,2),shin(:,1));
    thigh_angle = atan2(thigh(:,2),thigh(:,1));
    torso_angle = atan2(torso(:,2),torso(:,1));
    
    % Relative Joint Angles
    data_struct.traj{it}.skel_mocap.joint_angles.theta_1 = ...
        shin_angle - pi/2;
    data_struct.traj{it}.skel_mocap.joint_angles.theta_2 = ...
        thigh_angle - shin_angle;
    data_struct.traj{it}.skel_mocap.joint_angles.theta_3 = ...
        torso_angle - thigh_angle;

    % Calculate Joint Velocities and Accelerations
    [data_struct.traj{it}.skel_mocap.joint_angles.theta_1_d,...
        data_struct.traj{it}.skel_mocap.joint_angles.theta_1_dd] =...
        derivativeTaker(...
        data_struct.traj{it}.skel_mocap.joint_angles.theta_1,...
        data_struct.traj{it}.skel_mocap.sampling_freq);
    [data_struct.traj{it}.skel_mocap.joint_angles.theta_2_d,...
        data_struct.traj{it}.skel_mocap.joint_angles.theta_2_dd] =...
        derivativeTaker(...
        data_struct.traj{it}.skel_mocap.joint_angles.theta_2,...
        data_struct.traj{it}.skel_mocap.sampling_freq);
    [data_struct.traj{it}.skel_mocap.joint_angles.theta_3_d,...
        data_struct.traj{it}.skel_mocap.joint_angles.theta_3_dd] =...
        derivativeTaker(...
        data_struct.traj{it}.skel_mocap.joint_angles.theta_3,...
        data_struct.traj{it}.skel_mocap.sampling_freq);

    % Synchronize Relative Joint Angles
    sync_it = data_struct.traj{it}.sync_idxs;
    data_struct.traj{it}.theta_1 = ...
        data_struct.traj{it}.skel_mocap.joint_angles.theta_1(sync_it);
    data_struct.traj{it}.theta_2 = ...
        data_struct.traj{it}.skel_mocap.joint_angles.theta_2(sync_it);
    data_struct.traj{it}.theta_3 = ...
        data_struct.traj{it}.skel_mocap.joint_angles.theta_3(sync_it);

    data_struct.traj{it}.theta_1_d = ...
        data_struct.traj{it}.skel_mocap.joint_angles.theta_1_d(sync_it);
    data_struct.traj{it}.theta_2_d = ...
        data_struct.traj{it}.skel_mocap.joint_angles.theta_2_d(sync_it);
    data_struct.traj{it}.theta_3_d = ...
        data_struct.traj{it}.skel_mocap.joint_angles.theta_3_d(sync_it);

    data_struct.traj{it}.theta_1_dd = ...
        data_struct.traj{it}.skel_mocap.joint_angles.theta_1_dd(sync_it);
    data_struct.traj{it}.theta_2_dd = ...
        data_struct.traj{it}.skel_mocap.joint_angles.theta_2_dd(sync_it);
    data_struct.traj{it}.theta_3_dd = ...
        data_struct.traj{it}.skel_mocap.joint_angles.theta_3_dd(sync_it);    

    % Segment Lengths
    l1_samp = sqrt(shin(:,2).^2 + shin(:,1).^2);
    l2_samp = sqrt(thigh(:,2).^2 + thigh(:,1).^2);
    l3_samp = sqrt(torso(:,2).^2 + torso(:,1).^2);

    l1_storage(it) = mean(l1_samp);
    l2_storage(it) = mean(l2_samp);
    l3_storage(it) = mean(l3_samp);
end

% Calculate Overall Average for Segment Lengths
data_struct.subject_l1 = mean(l1_storage);
data_struct.subject_l2 = mean(l2_storage);
data_struct.subject_l3 = mean(l3_storage);

end