%% Add to Path
folder = pwd;%fileparts(which(mfilename));
addpath(genpath(folder));

%% Run Parts
tic
run("scripts\autonomous\script_01_data_loading.m");% 1.7896 s % 2.937 s
toc
tic
run("scripts\autonomous\script_02_define_human_parameters.m"); % 0.0228 s % 0.0310 s
toc
tic
run("scripts\autonomous\script_03_generate_ts_pairs_from_human_data.m"); % 0.2025 s % 0.454 s
toc
tic
run("scripts\autonomous\script_04_koopman_setup_and_training.m"); % 0.545 s
toc
tic
run("scripts\autonomous\script_05_simulation.m"); % 0.0219 s
toc
tic
run("scripts\autonomous\script_06_local_system_analysis.m"); % 0.8556 s
toc