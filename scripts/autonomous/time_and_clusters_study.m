%% Load Dataset
% Load Human Data
load([folder,'\human_datasets\human_dataset_N_time_cutoff.mat']);
% Load Simulation Data
load([folder,'/results_for_figures/paper_auto_results.mat']);
sim_dt = human_dataset.timing.base_dt;

%% Plotting Times for Each Cluster
clear clust_times
clust_count = clust.cluster_metadata.cluster_count;
clust_times.count = clust_count;
clust_times.times = cell(1,clust_count);

for subj_it = 1:human_dataset.subject_count
    subj = human_dataset.subjects{subj_it};
    for traj_it = 1:subj.traj_count
        traj = subj.traj{traj_it};
        tvec = traj.time;
        thvecs = traj.states(1:3,:);
        COMvec = COM_remap(thvecs);
        
        dist_log = NaN(clust_count,traj.t_count);
        for cl_it = 1:clust_count
            dist_log(cl_it,:) = ...
                vecnorm(COMvec - clust.cluster_metadata.centers(:,cl_it));
        end
        [~,cl_vec] = min(dist_log,[],1);
        for cl_it = 1:clust_count
            clust_times.times{cl_it} = [clust_times.times{cl_it},...
                tvec(cl_vec==cl_it)];
        end
    end
end

%% Plot Histogram
figure(801);clf;
for cl_it = 1:clust_count
    histogram(clust_times.times{cl_it},'BinWidth',5/480,'EdgeColor','none');
    hold on
end
xlabel('Time (s)');
ylabel('Count');

%% Percentile Thresholds
complete_percentile = 95;
clust_times.finish_times = NaN(1,clust_count);
for cl_it = 1:clust_count
    clust_times.finish_times(cl_it) = ...
        prctile(clust_times.times{cl_it},complete_percentile);
    %xline(clust_times.finish_times(cl_it),'k-');
end

zone_colors = {"#0072BD","#EDB120","#7E2F8E","#D95319"};
finishes_for_plotting = sort(clust_times.finish_times);
for cl_it = 1:(clust_count-1)
    xline(finishes_for_plotting(cl_it),'k--','Color',zone_colors{cl_it},'LineWidth',2);
end

%% Calculate Time Constants from Settling Time
settling_threshold = 0.95;
clust_times.time_constants = ...
    -clust_times.finish_times/log(1-settling_threshold);
clust_times.discrete_rates = exp(-sim_dt./clust_times.time_constants);

%% Eigenvalue Diagrams
rate_thresh_sorted = sort(clust_times.discrete_rates);
rate_thresh_sorted = [0, rate_thresh_sorted(1:end-1), 1];

out_real_max = 1.05;
out_real_min = -0.05;
out_imag_lim = 0.05;

zoom_real_max = 1.01;
zoom_real_min = 0.96;
zoom_imag_lim = 0.02;
eval_marker_size = 10;

lambda_A = eig(model);
lambda_A_mag = abs(lambda_A);
%eig_count = length(lambda_A_mag);

figure(831);clf;
th_circle_plot = linspace(0,2*pi,1e6);
plot(cos(th_circle_plot),sin(th_circle_plot),'k-');
%rectangle('Position',[-1,-1,2,2],'Curvature',1);
rectangle('Position',[zoom_real_min,-zoom_imag_lim,...
    zoom_real_max-zoom_real_min,2*zoom_imag_lim],'LineStyle','--');
hold on
xline(0,'--');
yline(0,'--');
plot(real(lambda_A),imag(lambda_A),'k.','MarkerSize',eig_marker_size_small);
for cl_it = 1:clust_count
    clust_lambda = lambda_A((rate_thresh_sorted(cl_it)< lambda_A_mag) &...
        (lambda_A_mag < rate_thresh_sorted(cl_it+1)));
    plot(real(clust_lambda),imag(clust_lambda),'.',...
        'MarkerSize',eig_marker_size_small,...
        'MarkerFaceColor',zone_colors{cl_it},...
        'MarkerEdgeColor',zone_colors{cl_it});
end
axis equal
xlabel('Re[\lambda_A]');
ylabel('Im[\lambda_A]');
xlim([out_real_min,out_real_max]);
ylim([-out_imag_lim,out_imag_lim]);

figure(833);clf;
plot(cos(th_circle_plot),sin(th_circle_plot),'k-');
%rectangle('Position',[-1,-1,2,2],'Curvature',1);
hold on
xline(0,'--');
yline(0,'--');
plot(real(lambda_A),imag(lambda_A),'k.','MarkerSize',eig_marker_size_large);
for cl_it = 1:clust_count
    clust_lambda = lambda_A((rate_thresh_sorted(cl_it)< lambda_A_mag) &...
        (lambda_A_mag < rate_thresh_sorted(cl_it+1)));
    plot(real(clust_lambda),imag(clust_lambda),'.',...
        'MarkerSize',eig_marker_size_large,...
        'MarkerFaceColor',zone_colors{cl_it},...
        'MarkerEdgeColor',zone_colors{cl_it});
end
axis equal
xlabel('Re[\lambda_A]');
ylabel('Im[\lambda_A]');
xlim([zoom_real_min,zoom_real_max]);
ylim([-zoom_imag_lim,zoom_imag_lim]);