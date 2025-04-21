%% Specify Sit-to-Stand Class
sts_class = 'N';

%% Load and Process Data
clear raw_human_dataset;
clear human_dataset;
for subj = 1:11
    raw_human_dataset.subjects{subj} = holmes_dataloader_joint_angles(...
        [folder,'/holmes_2019_STS_trajectories/subject',num2str(subj),...
        '/subject',num2str(subj),'_trajectories_',sts_class,'.mat']);
    human_dataset.subjects{subj} = usable_data_extractor_no_disturbance(...
        raw_human_dataset.subjects{subj});
end

%% Add Metadata
human_dataset.timing.base_freq = 480;
human_dataset.timing.base_dt = 1/human_dataset.timing.base_freq;
human_dataset.subject_count = 11;

%% Save Dataset
save([folder,'/human_datasets/human_dataset_',sts_class,'.mat'],'human_dataset');

%% Create Time-Cutoff Dataset
time_cutoff = 2.5;%s
for subj_it = 1:human_dataset.subject_count
    for traj_it = 1:human_dataset.subjects{subj_it}.traj_count
        human_dataset.subjects{subj_it}.traj{traj_it} = ...
            traj_time_cutoff(human_dataset.subjects{subj_it}.traj{traj_it},...
            time_cutoff);
    end
end

%% Save Time Cutoff Dataset
save([folder,'/human_datasets/human_dataset_',sts_class,'_time_cutoff.mat'],'human_dataset');