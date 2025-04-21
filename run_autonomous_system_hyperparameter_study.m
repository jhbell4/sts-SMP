%% Add to Path
folder = fileparts(which(mfilename));
addpath(genpath(folder));

%% Run Parts
tic
run("scripts\autonomous\script_01_data_loading.m");% 1.7896 s
toc
tic
run("scripts\autonomous\script_02_define_human_parameters.m"); % 0.0228 s
toc
tic
run("scripts\autonomous\script_03_generate_ts_pairs_from_human_data.m"); % 0.2025 s
toc
tic
run("scripts\autonomous\script_04ALTERNATIVE_hyperparameter_study.m"); % 84178 s
toc