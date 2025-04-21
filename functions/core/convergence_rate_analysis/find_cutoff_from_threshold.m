function cutoff_index = find_cutoff_from_threshold(COM_vec,threshold)

COM_end = COM_vec(:,end);
COM_resid = vecnorm(COM_vec - COM_end);
cutoff_index = find(COM_resid <= threshold, 1);

end
