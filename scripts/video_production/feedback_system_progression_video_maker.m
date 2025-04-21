data_rate = 480;
frame_rate = 60;
% Load Simulation Data
load([folder,'\results_for_figures\paper_CL_results_progression.mat']);
% Load Human Data
load([folder,'\human_datasets\human_dataset_N_time_cutoff.mat']);
samp_rate = data_rate/frame_rate;

%% Moments to Capture
moment_list = [23,28,67,75,145];%[1,14,15,23,28,49,52,53,57,67,75,82,101,145];

%% Autogeneration

clear plot_params
plot_params.l1 = 0.3871;
plot_params.l2 = 0.4267;
plot_params.l3 = 0.66;
plot_params.w = 0.16;
plot_params.h = 0.092;

background_opacity = 0.01;

for moment = moment_list
    traj_now = optimization_tracker.sim_traj{moment};

    traj_length = size(traj_now,2);
    samp_count = 1 + floor((traj_length-1)/samp_rate);

    %Select Output Folder
    filedir = [folder,'\video\feedback_system_progression\',num2str(moment),'\'];

    for fr_it = 1:samp_count
        t_step = (fr_it-1)*samp_rate+1;

        figure(50);clf;
        ax = axes;
        for subj_it = 1:human_dataset.subject_count
            subj = human_dataset.subjects{subj_it};
            for traj_it = 1:subj.traj_count
                traj = subj.traj{traj_it};
                if t_step <= traj.t_count
                    frameBuilder_with_head(ax,plot_params,traj.states(:,t_step),...
                        background_opacity,false,true);
                end
            end
        end
        frameBuilder_with_head(ax,plot_params,traj_now(:,t_step));
        draw_COM(ax,COM_remap(traj_now(:,t_step)));
        axis equal
        xlabel('Horizontal Position (m)');
        ylabel('Vertical Position (m)');
        set(gca, 'Color', 'none');
        set(gca,'FontSize',13);
        set(gca,'fontname','times');
        xlim([-0.7,0.5]);ylim([-0.2,1.7]);
        saveas(gcf,[filedir 'frame_' num2str(fr_it) '.png']);
        disp(['Frame ',num2str(fr_it),'/',num2str(samp_count),' complete.'])
    end

end