%% Add to Path
folder = pwd;
addpath(genpath(folder));

%% Run Parts
tic
run("scripts\feedback_system\script_01_data_loading.m");% 3 sec
toc
tic
run("scripts\feedback_system\script_02_define_human_parameters.m"); % 0.05 s
toc
tic
run("scripts\feedback_system\script_03ALTERNATIVE_convergence_rate_analysis.m"); % 5.7 sec
toc