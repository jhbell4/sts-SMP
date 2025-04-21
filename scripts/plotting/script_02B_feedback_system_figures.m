%% Load Dataset
load([folder,'/results_for_figures/paper_CL_results.mat']);
sim_dt = human_dataset.timing.base_dt;

%% Plotting Standards
true_traj_color = [0,0,0,0.1];
poi_marker_size = 15;
poi_marker_time_size = 10;
poi_marker_color = 'k';
poi_equil_marker_color = 'b';
poi_marker_edge_color = 'w';
poi_line_width = 1;
sim_thickness = 3;

%% Plot Trajectories
figure(203);clf;% Paths Plot with Simulated
figure(204);clf;% Trajectories Plot with Simulated

th_1_data_lim = NaN(1,2);
th_2_data_lim = NaN(1,2);
th_3_data_lim = NaN(1,2);

for subj_it = 1:human_dataset.subject_count
    subj = human_dataset.subjects{subj_it};
    for traj_it = 1:subj.traj_count
            traj = subj.traj{traj_it};
            tvec = traj.time;
            thvecs = traj.states(1:3,:);
            COMvec = COM_remap(thvecs);

            figure(203);
            plot(COMvec(1,:),COMvec(2,:),'-','Color',true_traj_color*0.75);
            hold on

            th_1_data_lim = lim_update(th_1_data_lim,thvecs(1,:));
            th_2_data_lim = lim_update(th_2_data_lim,thvecs(2,:));
            th_3_data_lim = lim_update(th_3_data_lim,thvecs(3,:));

            figure(204);
            subplot(3,1,1);
            plot(tvec,thvecs(1,:),'-','Color',true_traj_color*0.75);
            hold on
            subplot(3,1,2);
            plot(tvec,thvecs(2,:),'-','Color',true_traj_color*0.75);
            hold on
            subplot(3,1,3);
            plot(tvec,thvecs(3,:),'-','Color',true_traj_color*0.75);
            hold on
    end
end

%% Calculate Equilibrium
[V,D] = eig(A_cl_est);
D = diag(D);
V_1 = V(:,D==1);
V_1 = V_1 / V_1(1);
th_inf = V_1(2:4);
COM_inf = COM_remap(th_inf);

%% Draw Simulation Trajectory Over Light Paths
plot_lim_stack = manual_axis_equals(...
    [th_1_data_lim;th_2_data_lim;th_3_data_lim],0.2);

tvec = ((1:size(state_aug_test_sim_history,2))-1)*sim_dt;
COMvec = COM_remap(state_aug_test_sim_history);
thvecs = state_aug_test_sim_history(1:3,:);
figure(203);
axis equal
xlabel('Horizontal COM Pos (m)');
ylabel('Vertical COM Pos (m)');
plot(COM_inf(1),COM_inf(2),'s','Color',equil_color,'MarkerSize',equil_marker_size,'MarkerFaceColor',equil_color);
plot(COMvec(1,:),COMvec(2,:),'r.-','LineWidth',sim_line_width);

figure(204);
subplot(3,1,1);
plot([0,2.5],[1,1]*th_inf(1),':','Color',equil_color,'LineWidth',equil_line_width);
plot(tvec,thvecs(1,:),'r.-','LineWidth',sim_line_width);
ylim(plot_lim_stack(1,:));
xlim([0,2.5]);
ylabel('\theta_1 (rad)');

subplot(3,1,2);
plot([0,2.5],[1,1]*th_inf(2),':','Color',equil_color,'LineWidth',equil_line_width);
plot(tvec,thvecs(2,:),'r.-','LineWidth',sim_line_width);
ylim(plot_lim_stack(2,:));
xlim([0,2.5]);
ylabel('\theta_2 (rad)');

subplot(3,1,3);
plot([0,2.5],[1,1]*th_inf(3),':','Color',equil_color,'LineWidth',equil_line_width);
plot(tvec,thvecs(3,:),'r.-','LineWidth',sim_line_width);
ylim(plot_lim_stack(3,:));
xlim([0,2.5]);
ylabel('\theta_3 (rad)');
xlabel('Time (s)');

%% Eigenvalue Diagrams
zoom_real_max = 1.05;
zoom_real_min = 0.95;
zoom_imag_lim = 0.015;

lambda_A_OL = eig(model.A);
lambda_A_CL_pre_correct = eig(A_cl_pre_correct);
lambda_A_CL = eig(A_cl_est);

th_circle_plot = linspace(0,2*pi,1e6);

pole_threshold = 0.0077;
max_pole_mag = 1 - pole_threshold;

lambda_A_CL_to_be_corrected = lambda_A_CL_pre_correct;
lambda_A_CL_to_be_corrected(abs(lambda_A_CL_to_be_corrected)<=max_pole_mag) = [];
lambda_A_CL_to_be_corrected(abs(lambda_A_CL_to_be_corrected)==1) = [];

lambda_A_CL_have_been_corrected = lambda_A_CL_to_be_corrected./...
    abs(lambda_A_CL_to_be_corrected)*max_pole_mag;

close_real_max = 1.001;
close_real_min = 0.991;
close_imag_lim = 0.0065;

figure(231);clf;
plot(cos(th_circle_plot),sin(th_circle_plot),'k-');
hold on
xline(0,'--');
yline(0,'--');
plot(real(lambda_A_OL),imag(lambda_A_OL),'k.','MarkerSize',eig_marker_size_small);
axis equal
xlabel('Re[\lambda_A]');
ylabel('Im[\lambda_A]');
xlim([zoom_real_min,zoom_real_max]);
ylim([-zoom_imag_lim,zoom_imag_lim]);

figure(232);clf;
plot(cos(th_circle_plot),sin(th_circle_plot),'k-');
hold on
plot(max_pole_mag*cos(th_circle_plot),max_pole_mag*sin(th_circle_plot),'r:');
rectangle('Position',[close_real_min,-close_imag_lim,...
    close_real_max-close_real_min,2*close_imag_lim],'LineStyle','--');
xline(0,'--');
yline(0,'--');
plot(real(lambda_A_CL_pre_correct),imag(lambda_A_CL_pre_correct),'k.','MarkerSize',eig_marker_size_small);
plot(real(lambda_A_CL_to_be_corrected),imag(lambda_A_CL_to_be_corrected),'m.','MarkerSize',eig_marker_size_small);
axis equal
xlabel('Re[\lambda_A]');
ylabel('Im[\lambda_A]');
xlim([zoom_real_min,zoom_real_max]);
ylim([-zoom_imag_lim,zoom_imag_lim]);

figure(233);clf;
plot(cos(th_circle_plot),sin(th_circle_plot),'k-');
hold on
plot(max_pole_mag*cos(th_circle_plot),max_pole_mag*sin(th_circle_plot),'r:');
rectangle('Position',[close_real_min,-close_imag_lim,...
    close_real_max-close_real_min,2*close_imag_lim],'LineStyle','--');
xline(0,'--');
yline(0,'--');
plot(real(lambda_A_CL),imag(lambda_A_CL),'k.','MarkerSize',eig_marker_size_small);
plot(real(lambda_A_CL_have_been_corrected),imag(lambda_A_CL_have_been_corrected),'r.','MarkerSize',eig_marker_size_small);
axis equal
xlabel('Re[\lambda_A]');
ylabel('Im[\lambda_A]');
xlim([zoom_real_min,zoom_real_max]);
ylim([-zoom_imag_lim,zoom_imag_lim]);

figure(234);clf;
plot(cos(th_circle_plot),sin(th_circle_plot),'k-');
hold on
plot(max_pole_mag*cos(th_circle_plot),max_pole_mag*sin(th_circle_plot),'r:');
xline(0,'--');
yline(0,'--');
plot(real(lambda_A_CL_pre_correct),imag(lambda_A_CL_pre_correct),'k.','MarkerSize',eig_marker_size_large);

quiver(real(lambda_A_CL_to_be_corrected),imag(lambda_A_CL_to_be_corrected),...
    real(lambda_A_CL_have_been_corrected-lambda_A_CL_to_be_corrected),...
    imag(lambda_A_CL_have_been_corrected-lambda_A_CL_to_be_corrected),...
    "off",'k-','MaxHeadSize',0.15,'LineWidth',eig_arrow_width);
plot(real(lambda_A_CL_to_be_corrected),imag(lambda_A_CL_to_be_corrected),'m.','MarkerSize',eig_marker_size_large);
plot(real(lambda_A_CL_have_been_corrected),imag(lambda_A_CL_have_been_corrected),'r.','MarkerSize',eig_marker_size_large);
axis equal
xlabel('Re[\lambda_A]');
ylabel('Im[\lambda_A]');
xlim([close_real_min,close_real_max]);
ylim([-close_imag_lim,close_imag_lim]);

