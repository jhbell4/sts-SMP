%% Add to Path
folder = pwd;
addpath(genpath(folder));

%% Run Parts
tic
run("scripts\feedback_system\script_01_data_loading.m");% 3 sec
toc
tic
run("scripts\feedback_system\script_02_define_human_parameters.m"); % 0.03 sec
toc
tic
run("scripts\feedback_system\script_03_simulated_data_generate.m"); % 2270 sec
toc
tic
run("scripts\feedback_system\script_04_koopman_setup_and_training.m"); % 3.5 sec
toc
%%
tic
run("scripts\feedback_system\script_05_LQR_optimization_and_simulation.m"); % 15300 sec
toc