%% Add to Path
folder = pwd;
addpath(genpath(folder));

%% Run Parts
tic
run("scripts\plotting\script_01_set_defaults_for_plotting.m"); %0.04 s
toc
tic
run("scripts\plotting\script_02A_autonomous_figures.m"); % 53 s
toc
tic
run("scripts\plotting\script_02B_feedback_system_figures.m"); % 17 s
toc
tic
run("scripts\plotting\script_02C_hyperparameter_study_figures.m"); % 0.5 s
toc
tic
run("scripts\plotting\script_02D_convergence_rate_figure.m"); % 9 s
toc