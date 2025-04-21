%% Load Parameter Studies
load([folder,'/results_for_figures/paper_param_study_results.mat']);

%% Figure
figure(301);clf;
plot_line_1 = retrieve_eps_error_info(param_study,1);
semilogx(plot_line_1.eps,plot_line_1.error,'-','Color',"#7E2F8E",'LineWidth',study_width);
hold on
plot_line_2 = retrieve_eps_error_info(param_study,2);
semilogx(plot_line_2.eps,plot_line_2.error,'--','Color',"#77AC30",'LineWidth',study_width);
plot_line_4 = retrieve_eps_error_info(param_study,4);
semilogx(plot_line_4.eps,plot_line_4.error,'-.','Color',"#4DBEEE",'LineWidth',study_width);
plot_line_8 = retrieve_eps_error_info(param_study,8);
semilogx(plot_line_4.eps,plot_line_8.error,':','Color',"#A2142F",'LineWidth',study_width);
plot_line_16 = retrieve_eps_error_info(param_study,16);
semilogx(plot_line_16.eps,plot_line_16.error,'-','Color',"#D95319",'LineWidth',study_width/2);

xlabel('Shape Parameter \epsilon (log scale)');
ylabel('Error Metric (rad)');
grid on

leg = legend({'1','2','4','8','16'},'Location','southeast');
title(leg,'M')

%% Define Reconstruction Function
function plot_line = retrieve_eps_error_info(study,M_test)

plot_line.eps = study.eps;
plot_line.error = study.LOOC_error(M_test,:);


end