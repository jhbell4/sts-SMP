%% Load Dataset
% Load Human Data
load([folder,'\human_datasets\human_dataset_N_time_cutoff.mat']);
% Load Simulation Data
load([folder,'/results_for_figures/paper_auto_results.mat']);
sim_dt = human_dataset.timing.base_dt;

%% Plot Trajectories
figure(101);clf;% Paths Plot
ax101 = axes;
figure(102);clf;% Trajectories Plot
figure(103);clf;% Paths Plot with Simulated
figure(104);clf;% Trajectories Plot with Simulated
figure(121);clf;% Centers of Attraction Plot
ax121 = axes;
figure(141);clf;% POI 1 Illustrated Center of Attraction
ax141 = axes;
figure(142);clf;% POI 2 Illustrated Center of Attraction
ax142 = axes;
figure(143);clf;% POI 3 Illustrated Center of Attraction
ax143 = axes;

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

            figure(101);
            plot(COMvec(1,:),COMvec(2,:),'-','Color',true_traj_color);
            hold on
            figure(103);
            plot(COMvec(1,:),COMvec(2,:),'-','Color',true_traj_color*0.75);
            hold on
            figure(121);
            plot(COMvec(1,:),COMvec(2,:),'-','Color',true_traj_color*0.75);
            hold on
            figure(141);
            plot(COMvec(1,:),COMvec(2,:),'-','Color',true_traj_color*0.75);
            hold on
            figure(142);
            plot(COMvec(1,:),COMvec(2,:),'-','Color',true_traj_color*0.75);
            hold on
            figure(143);
            plot(COMvec(1,:),COMvec(2,:),'-','Color',true_traj_color*0.75);
            hold on

            th_1_data_lim = lim_update(th_1_data_lim,thvecs(1,:));
            th_2_data_lim = lim_update(th_2_data_lim,thvecs(2,:));
            th_3_data_lim = lim_update(th_3_data_lim,thvecs(3,:));

            figure(102);
            subplot(3,1,1);
            plot(tvec,thvecs(1,:),'-','Color',true_traj_color);
            hold on
            subplot(3,1,2);
            plot(tvec,thvecs(2,:),'-','Color',true_traj_color);
            hold on
            subplot(3,1,3);
            plot(tvec,thvecs(3,:),'-','Color',true_traj_color);
            hold on

            figure(104);
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

%% Adjust Trajectories Plots
figure(101);
axis equal
xlabel('Horizontal COM Pos (m)');
ylabel('Vertical COM Pos (m)');

figure(102);
plot_lim_stack = manual_axis_equals(...
    [th_1_data_lim;th_2_data_lim;th_3_data_lim],0.2);
subplot(3,1,1);
ylim(plot_lim_stack(1,:));
ylabel('\theta_1 (rad)');
subplot(3,1,2);
ylim(plot_lim_stack(2,:));
ylabel('\theta_2 (rad)');
subplot(3,1,3);
ylim(plot_lim_stack(3,:));
ylabel('\theta_3 (rad)');
xlabel('Time (s)');

%% Put Points of Interest on Plots
figure(101);
% plot(poi_1.COM(1),poi_1.COM(2),'o','MarkerSize',poi_marker_size,...
%     'MarkerEdgeColor',poi_marker_edge_color,...
%     'MarkerFaceColor',poi_marker_color,...
%     'LineWidth',poi_line_width);
% plot(poi_2.COM(1),poi_2.COM(2),'o','MarkerSize',poi_marker_size,...
%     'MarkerFaceColor',poi_marker_color,...
%     'MarkerEdgeColor',poi_marker_edge_color,...
%     'LineWidth',poi_line_width);
% plot(poi_3.COM(1),poi_3.COM(2),'o','MarkerSize',poi_marker_size,...
%     'MarkerFaceColor',poi_marker_color,...
%     'MarkerEdgeColor',poi_marker_edge_color,...
%     'LineWidth',poi_line_width);
draw_COM_mini(ax101,poi_1.COM);
draw_COM_mini(ax101,poi_2.COM);
draw_COM_mini(ax101,poi_3.COM);

% Decide Times to Correspond to States
poi_1.time = 0.15;%s
poi_2.time = 0.675;%s
poi_3.time = 2.5;%s

figure(102);
subplot(3,1,1);
plot(poi_1.time,poi_1.x(1),'o','MarkerSize',poi_marker_time_size,...
    'MarkerEdgeColor',poi_marker_edge_color,...
    'MarkerFaceColor',poi_marker_color,...
    'LineWidth',poi_line_width);
plot(poi_2.time,poi_2.x(1),'o','MarkerSize',poi_marker_time_size,...
    'MarkerEdgeColor',poi_marker_edge_color,...
    'MarkerFaceColor',poi_marker_color,...
    'LineWidth',poi_line_width);
plot(poi_3.time,poi_3.x(1),'o','MarkerSize',poi_marker_time_size,...
    'MarkerEdgeColor',poi_marker_edge_color,...
    'MarkerFaceColor',poi_marker_color,...
    'LineWidth',poi_line_width);
subplot(3,1,2);
plot(poi_1.time,poi_1.x(2),'o','MarkerSize',poi_marker_time_size,...
    'MarkerEdgeColor',poi_marker_edge_color,...
    'MarkerFaceColor',poi_marker_color,...
    'LineWidth',poi_line_width);
plot(poi_2.time,poi_2.x(2),'o','MarkerSize',poi_marker_time_size,...
    'MarkerEdgeColor',poi_marker_edge_color,...
    'MarkerFaceColor',poi_marker_color,...
    'LineWidth',poi_line_width);
plot(poi_3.time,poi_3.x(2),'o','MarkerSize',poi_marker_time_size,...
    'MarkerEdgeColor',poi_marker_edge_color,...
    'MarkerFaceColor',poi_marker_color,...
    'LineWidth',poi_line_width);
subplot(3,1,3);
plot(poi_1.time,poi_1.x(3),'o','MarkerSize',poi_marker_time_size,...
    'MarkerEdgeColor',poi_marker_edge_color,...
    'MarkerFaceColor',poi_marker_color,...
    'LineWidth',poi_line_width);
plot(poi_2.time,poi_2.x(3),'o','MarkerSize',poi_marker_time_size,...
    'MarkerEdgeColor',poi_marker_edge_color,...
    'MarkerFaceColor',poi_marker_color,...
    'LineWidth',poi_line_width);
plot(poi_3.time,poi_3.x(3),'o','MarkerSize',poi_marker_time_size,...
    'MarkerEdgeColor',poi_marker_edge_color,...
    'MarkerFaceColor',poi_marker_color,...
    'LineWidth',poi_line_width);

%% Calculate Equilibrium
[V,D] = eig(model);
D = diag(D);
V_1 = V(:,D==1);
V_1 = V_1 / V_1(1);
th_inf = V_1(2:4);
COM_inf = COM_remap(th_inf);

%% Draw Simulation Trajectory Over Light Paths
tvec = ((1:size(state_test_sim_history,2))-1)*sim_dt;
COMvec = COM_remap(state_test_sim_history);
thvecs = state_test_sim_history(1:3,:);
figure(103);
axis equal
xlabel('Horizontal COM Pos (m)');
ylabel('Vertical COM Pos (m)');
plot(COM_inf(1),COM_inf(2),'s','Color',equil_color,'MarkerSize',equil_marker_size,'MarkerFaceColor',equil_color);
plot(COMvec(1,:),COMvec(2,:),'r.-','LineWidth',sim_line_width);

figure(104);
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

%% Local Attractors
figure(121);
quiver([poi_1.COM(1),poi_2.COM(1)],[poi_1.COM(2),poi_2.COM(2)],...
    [poi_1.local_sys.taylor.eig_info.COM_equil(1)-poi_1.COM(1),...
    poi_2.local_sys.taylor.eig_info.COM_equil(1)-poi_2.COM(1)],...
    [poi_1.local_sys.taylor.eig_info.COM_equil(2)-poi_1.COM(2),...
    poi_2.local_sys.taylor.eig_info.COM_equil(2)-poi_2.COM(2)],...
    "off",'m-','MaxHeadSize',0.2,'LineWidth',eig_arrow_width*2);
draw_COM_mini(ax121,poi_1.COM);
draw_COM_mini(ax121,poi_2.COM);
draw_COM_mini(ax121,poi_3.COM);
% plot(poi_1.COM(1),poi_1.COM(2),'o','MarkerSize',poi_marker_size,...
%     'MarkerEdgeColor',poi_marker_edge_color,...
%     'MarkerFaceColor',poi_marker_color,...
%     'LineWidth',poi_line_width);
% plot(poi_2.COM(1),poi_2.COM(2),'o','MarkerSize',poi_marker_size,...
%     'MarkerFaceColor',poi_marker_color,...
%     'MarkerEdgeColor',poi_marker_edge_color,...
%     'LineWidth',poi_line_width);
% plot(poi_3.COM(1),poi_3.COM(2),'o','MarkerSize',poi_marker_size,...
%     'MarkerFaceColor',poi_marker_color,...
%     'MarkerEdgeColor',poi_marker_edge_color,...
%     'LineWidth',poi_line_width);

plot(poi_1.local_sys.taylor.eig_info.COM_equil(1),...
    poi_1.local_sys.taylor.eig_info.COM_equil(2),'s','MarkerSize',poi_marker_size,...
    'MarkerFaceColor',poi_equil_marker_color,...
    'MarkerEdgeColor',poi_marker_edge_color,...
    'LineWidth',poi_line_width);
plot(poi_2.local_sys.taylor.eig_info.COM_equil(1),...
    poi_2.local_sys.taylor.eig_info.COM_equil(2),'s','MarkerSize',poi_marker_size,...
    'MarkerFaceColor',poi_equil_marker_color,...
    'MarkerEdgeColor',poi_marker_edge_color,...
    'LineWidth',poi_line_width);
plot(poi_3.local_sys.taylor.eig_info.COM_equil(1),...
    poi_3.local_sys.taylor.eig_info.COM_equil(2),'s','MarkerSize',poi_marker_size,...
    'MarkerFaceColor',poi_equil_marker_color,...
    'MarkerEdgeColor',poi_marker_edge_color,...
    'LineWidth',poi_line_width);

axis equal
xlabel('Horizontal COM Pos (m)');
ylabel('Vertical COM Pos (m)');

%% Eigenvalue Diagrams
out_real_max = 1.05;
out_real_min = -0.05;
out_imag_lim = 0.05;

zoom_real_max = 1.01;
zoom_real_min = 0.96;
zoom_imag_lim = 0.02;
eval_marker_size = 10;

lambda_A = eig(model);

figure(131);clf;
th_circle_plot = linspace(0,2*pi,1e6);
plot(cos(th_circle_plot),sin(th_circle_plot),'k-');
%rectangle('Position',[-1,-1,2,2],'Curvature',1);
rectangle('Position',[zoom_real_min,-zoom_imag_lim,...
    zoom_real_max-zoom_real_min,2*zoom_imag_lim],'LineStyle','--');
hold on
xline(0,'--');
yline(0,'--');
plot(real(lambda_A),imag(lambda_A),'k.','MarkerSize',eig_marker_size_small);
axis equal
xlabel('Re[\lambda_A]');
ylabel('Im[\lambda_A]');
xlim([out_real_min,out_real_max]);
ylim([-out_imag_lim,out_imag_lim]);

figure(133);clf;
plot(cos(th_circle_plot),sin(th_circle_plot),'k-');
%rectangle('Position',[-1,-1,2,2],'Curvature',1);
hold on
xline(0,'--');
yline(0,'--');
plot(real(lambda_A),imag(lambda_A),'k.','MarkerSize',eig_marker_size_large);
axis equal
xlabel('Re[\lambda_A]');
ylabel('Im[\lambda_A]');
xlim([zoom_real_min,zoom_real_max]);
ylim([-zoom_imag_lim,zoom_imag_lim]);

%% Cluster Plots
figure(70);clf;
%plot(all_samp_COM(1,:),all_samp_COM(2,:),'k.');
random_plot_clusters(clust,COM_remap,200);
axis equal;
for clust_it = 1:M
    plot_2d_covariance_matrix(...
        eye(2)*clust.cluster_metadata.stds(clust_it)^2,...
        clust.cluster_metadata.centers(:,clust_it),1,2);
end
xlabel('Horizontal COM Pos (m)');
ylabel('Vertical COM Pos (m)');

%% Generate POI Diagrams
clear plot_param
plot_param.l1 = human_param.L1;
plot_param.l2 = human_param.L2;
plot_param.l3 = 0.78;%m
plot_param.w = 0.16;%m
plot_param.h = 0.092;%m

figure(111);clf;
ax = axes;
frameBuilder_with_head(ax,plot_param,poi_1.x);
draw_COM(ax,poi_1.COM);
ylim([-0.2,1.8]);
axis off

figure(112);clf;
ax = axes;
frameBuilder_with_head(ax,plot_param,poi_2.x);
draw_COM(ax,poi_2.COM);
ylim([-0.2,1.8]);
axis off

figure(113);clf;
ax = axes;
frameBuilder_with_head(ax,plot_param,poi_3.x);
draw_COM(ax,poi_3.COM);
ylim([-0.2,1.8]);
axis off

figure(114);clf;
ax = axes;
frameBuilder_with_head(ax,plot_param,poi_2.x,1,false,false,true);
ylim([-0.2,1.8]);
axis off

%% Generate Detailed Point-of-Attraction Diagrams
poi_detailed_x_lim = [-0.7,0.5];
poi_detailed_y_lim = [-0.2,1.7];

figure(141);
frameBuilder_with_head(ax141,plot_param,poi_1.x);
quiver(poi_1.COM(1),poi_1.COM(2),...
    poi_1.local_sys.taylor.eig_info.COM_equil(1)-poi_1.COM(1),...
    poi_1.local_sys.taylor.eig_info.COM_equil(2)-poi_1.COM(2),...
    "off",'m-','MaxHeadSize',0.5,'LineWidth',eig_arrow_width*2);
draw_COM(ax141,poi_1.COM);
plot(poi_1.local_sys.taylor.eig_info.COM_equil(1),...
    poi_1.local_sys.taylor.eig_info.COM_equil(2),'s','MarkerSize',1.25*poi_marker_size,...
    'MarkerFaceColor',poi_equil_marker_color,...
    'MarkerEdgeColor',poi_marker_edge_color,...
    'LineWidth',poi_line_width);
axis equal
xlim(poi_detailed_x_lim);
ylim(poi_detailed_y_lim);
xlabel('Horizontal Position (m)');
ylabel('Vertical Position (m)');

figure(142);
frameBuilder_with_head(ax142,plot_param,poi_2.x);
quiver(poi_2.COM(1),poi_2.COM(2),...
    poi_2.local_sys.taylor.eig_info.COM_equil(1)-poi_2.COM(1),...
    poi_2.local_sys.taylor.eig_info.COM_equil(2)-poi_2.COM(2),...
    "off",'m-','MaxHeadSize',3,'LineWidth',eig_arrow_width*2);
draw_COM(ax142,poi_2.COM);
plot(poi_2.local_sys.taylor.eig_info.COM_equil(1),...
    poi_2.local_sys.taylor.eig_info.COM_equil(2),'s','MarkerSize',1.25*poi_marker_size,...
    'MarkerFaceColor',poi_equil_marker_color,...
    'MarkerEdgeColor',poi_marker_edge_color,...
    'LineWidth',poi_line_width);
axis equal
xlim(poi_detailed_x_lim);
ylim(poi_detailed_y_lim);
xlabel('Horizontal Position (m)');
ylabel('Vertical Position (m)');

figure(143);
frameBuilder_with_head(ax143,plot_param,poi_3.x);
draw_COM(ax143,poi_3.COM);
plot(poi_3.local_sys.taylor.eig_info.COM_equil(1),...
    poi_3.local_sys.taylor.eig_info.COM_equil(2),'s','MarkerSize',1.25*poi_marker_size,...
    'MarkerFaceColor',poi_equil_marker_color,...
    'MarkerEdgeColor',poi_marker_edge_color,...
    'LineWidth',poi_line_width);
axis equal
xlim(poi_detailed_x_lim);
ylim(poi_detailed_y_lim);
xlabel('Horizontal Position (m)');
ylabel('Vertical Position (m)');