%% Add to Path
folder = pwd;
addpath(genpath(folder));

%% Run Parts
tic
run("scripts\video_production\human_dataset_example_video_maker.m");
toc
tic
run("scripts\video_production\human_dataset_video_maker.m");
toc
tic
run("scripts\video_production\autonomous_video_maker.m");
toc
tic
run("scripts\video_production\feedback_system_video_maker.m");
toc
tic
run("scripts\video_production\feedback_system_progression_video_maker.m");
toc