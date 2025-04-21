%% Load Convergence Analysis Results
load([folder,'/results_for_figures/paper_convergence_results.mat']);

conv_rate_disc = 0.9923;
conv_rate_cont = -human_dataset.timing.base_freq*log(conv_rate_disc);
conv_time_constant = 1/conv_rate_cont;

traj = human_dataset_terminal.subjects{1}.traj{1};

th_exp_pred = traj.fit.eval(traj.time_terminal);


figure(501);clf;
th_1_data_lim = NaN(1,2);
th_2_data_lim = NaN(1,2);
th_3_data_lim = NaN(1,2);
th_1_data_lim = lim_update(th_1_data_lim,traj.states(1,:));
th_2_data_lim = lim_update(th_2_data_lim,traj.states(2,:));
th_3_data_lim = lim_update(th_3_data_lim,traj.states(3,:));
subplot(3,1,1);
plot(traj.time,traj.states(1,:),'k-','LineWidth',1);
hold on
%plot(traj.time_terminal,traj.states_terminal(1,:),'k-','LineWidth',1);
plot(traj.time_terminal,th_exp_pred(1,:),'b--','LineWidth',2);
xline(min(traj.time_terminal),'k:');

subplot(3,1,2);
plot(traj.time,traj.states(2,:),'k-','LineWidth',1);
hold on
%plot(traj.time_terminal,traj.states_terminal(2,:),'k-','LineWidth',1);
plot(traj.time_terminal,th_exp_pred(2,:),'b--','LineWidth',2);
xline(min(traj.time_terminal),'k:');

subplot(3,1,3);
plot(traj.time,traj.states(3,:),'k-','LineWidth',1);
hold on
%plot(traj.time_terminal,traj.states_terminal(3,:),'k-','LineWidth',1);
plot(traj.time_terminal,th_exp_pred(3,:),'b--','LineWidth',2);
xline(min(traj.time_terminal),'k:');
legend({'Human STS','Expon. Model'},'Location','southeast');

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


figure(502);clf;
th_1_data_lim = NaN(1,2);
th_2_data_lim = NaN(1,2);
th_3_data_lim = NaN(1,2);
th_1_data_lim = lim_update(th_1_data_lim,traj.states_terminal(1,:));
th_2_data_lim = lim_update(th_2_data_lim,traj.states_terminal(2,:));
th_3_data_lim = lim_update(th_3_data_lim,traj.states_terminal(3,:));

subplot(3,1,1);
plot(traj.time_terminal,traj.states_terminal(1,:),'k-','LineWidth',1);
hold on
plot(traj.time_terminal,th_exp_pred(1,:),'b--','LineWidth',2);

subplot(3,1,2);
plot(traj.time_terminal,traj.states_terminal(2,:),'k-','LineWidth',1);
hold on
plot(traj.time_terminal,th_exp_pred(2,:),'b--','LineWidth',2);

subplot(3,1,3);
plot(traj.time_terminal,traj.states_terminal(3,:),'k-','LineWidth',1);
hold on
plot(traj.time_terminal,th_exp_pred(3,:),'b--','LineWidth',2);
legend({'Human STS','Expon. Model'},'Location','southeast');

plot_lim_stack = manual_axis_equals(...
    [th_1_data_lim;th_2_data_lim;th_3_data_lim],0.2);
tlim = [min(traj.time_terminal),max(traj.time_terminal)];
subplot(3,1,1);
ylim(plot_lim_stack(1,:));
xlim(tlim);
ylabel('\theta_1 (rad)');
subplot(3,1,2);
ylim(plot_lim_stack(2,:));
xlim(tlim);
ylabel('\theta_2 (rad)');
subplot(3,1,3);
ylim(plot_lim_stack(3,:));
xlim(tlim);
ylabel('\theta_3 (rad)');
xlabel('Time (s)');


figure(503);clf;
th_1_data_lim = NaN(1,2);
th_2_data_lim = NaN(1,2);
th_3_data_lim = NaN(1,2);
largest_time_terminal_zeroed = 0;
for subj_it = 1:human_dataset_terminal.subject_count
    subj = human_dataset_terminal.subjects{subj_it};
    for traj_it = 1:subj.traj_count
        traj = subj.traj{traj_it};
        subplot(3,1,1);
        plot(traj.time_terminal_zeroed,traj.states_terminal_zeroed(1,:),...
            '-','Color',true_traj_color,'LineWidth',1);
        hold on
        subplot(3,1,2);
        plot(traj.time_terminal_zeroed,traj.states_terminal_zeroed(2,:),...
            '-','Color',true_traj_color,'LineWidth',1);
        hold on
        subplot(3,1,3);
        plot(traj.time_terminal_zeroed,traj.states_terminal_zeroed(3,:),...
            '-','Color',true_traj_color,'LineWidth',1);
        hold on

        th_1_data_lim = lim_update(th_1_data_lim,traj.states_terminal_zeroed(1,:));
        th_2_data_lim = lim_update(th_2_data_lim,traj.states_terminal_zeroed(2,:));
        th_3_data_lim = lim_update(th_3_data_lim,traj.states_terminal_zeroed(3,:));
        if traj.time_terminal_zeroed(end) > largest_time_terminal_zeroed(end)
            largest_time_terminal_zeroed = traj.time_terminal_zeroed;
        end
    end
end

raw_exp_bound = exp(-conv_rate_cont.*largest_time_terminal_zeroed);
th1_exp_bound = -0.25*raw_exp_bound;
th2_exp_bound = 0.65*raw_exp_bound;
th3_exp_bound = -0.8*raw_exp_bound;
subplot(3,1,1);
plot(largest_time_terminal_zeroed,th1_exp_bound,'r-','LineWidth',2);
subplot(3,1,2);
plot(largest_time_terminal_zeroed,th2_exp_bound,'r-','LineWidth',2);
subplot(3,1,3);
plot(largest_time_terminal_zeroed,th3_exp_bound,'r-','LineWidth',2);


plot_lim_stack = manual_axis_equals(...
    [th_1_data_lim;th_2_data_lim;th_3_data_lim],0.2);
tlim = [min(largest_time_terminal_zeroed),max(largest_time_terminal_zeroed)];
subplot(3,1,1);
ylim(plot_lim_stack(1,:));
xlim(tlim);
ylabel("\theta_1 -\theta_{1,end} (rad)");
subplot(3,1,2);
ylim(plot_lim_stack(2,:));
xlim(tlim);
ylabel("\theta_2 -\theta_{2,end} (rad)");
subplot(3,1,3);
ylim(plot_lim_stack(3,:));
xlim(tlim);
ylabel("\theta_3 -\theta_{3,end} (rad)");
xlabel("Time after threshold crossing (s)");



figure(504);clf;
human_time_constants = [];
for subj_it = 1:human_dataset_terminal.subject_count
    subj = human_dataset_terminal.subjects{subj_it};
    for traj_it = 1:subj.traj_count
        traj = subj.traj{traj_it};
        human_time_constants = ...
            [human_time_constants, traj.fit.time_constant];
    end
end
histogram(human_time_constants,50,'FaceColor','b','FaceAlpha',1);
xline(conv_time_constant,'r-','LineWidth',2);
xlim([0,inf]);
xlabel('Estimated Time Constant for Human Trial (s)');
ylabel('Number of Human Trials');