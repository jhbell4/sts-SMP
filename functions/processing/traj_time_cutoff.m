function new_traj = traj_time_cutoff(traj,cutoff_time)
%TRAJ_TIME_CUTOFF Summary of this function goes here
%   Detailed explanation goes here

cutoff_idx = find(traj.time <= cutoff_time, 1, 'last');

new_traj.time = traj.time(1:cutoff_idx);
new_traj.states = traj.states(:,1:cutoff_idx);
new_traj.t_count = length(new_traj.time);


end

