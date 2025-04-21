%% Setting Simulation Duration
sim_steps = 2.5*480;

%% Calculating Initial and Final States, and Mean Trajectory
traj_counter = 0;
ave_human_traj = zeros(6,human_dataset.subjects{1}.traj{1}.t_count);
for subj_it = 1:human_dataset.subject_count
    subj = human_dataset.subjects{subj_it};
    for traj_it = 1:subj.traj_count
        traj = subj.traj{traj_it};
        if traj.t_count == human_dataset.subjects{1}.traj{1}.t_count
            ave_human_traj = ave_human_traj + traj.states(1:6,:);
            traj_counter = traj_counter + 1;
        end
    end
end
ave_human_traj = ave_human_traj/traj_counter;
ave_start_state = ave_human_traj(:,1);
ave_end_state = ave_human_traj(:,end);

%% Resample Mean Trajectory for Reference
human_traj_ref = ave_human_traj(:,1:1:(human_dataset.subjects{1}.traj{1}.t_count));

%% Lifted Linear Simulation
z_test_sim_history = NaN(SMP_lift.count,sim_steps+1);
z_test_sim_history(:,1) = SMP_lift.eval(ave_start_state);
for t = 1:sim_steps
    z_test_sim_history(:,t+1) = model*z_test_sim_history(:,t);
end

state_test_sim_history = ginv(z_test_sim_history);