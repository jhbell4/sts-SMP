% Note: This only works for sim dt = raw dt

human_ts_pairs.prev = [];
human_ts_pairs.next = [];
human_ts_pairs.idxs = {};
human_ts_pairs.traj = {};
idx_base = 0;
for subj_it = 1:human_dataset.subject_count
    subj = human_dataset.subjects{subj_it};
    for traj_it = 1:subj.traj_count
        traj = subj.traj{traj_it};
        human_ts_pairs.prev = [human_ts_pairs.prev, traj.states(1:6,1:end-1)];
        human_ts_pairs.next = [human_ts_pairs.next, traj.states(1:6,2:end)];
        new_ts_count = size(traj.states,2)-1;
        human_ts_pairs.traj = [human_ts_pairs.traj; {traj.states(1:6,:)}];
        human_ts_pairs.idxs = [human_ts_pairs.idxs; {idx_base + (1:new_ts_count)}];
        idx_base = idx_base + new_ts_count;
    end
end
human_ts_pairs.traj_count = size(human_ts_pairs.idxs,1);