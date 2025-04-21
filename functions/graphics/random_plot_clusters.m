function random_plot_clusters(clust,COM_remap,n_plot)
%RANDOM_PLOT_CLUSTERS Summary of this function goes here
%   Detailed explanation goes here

ref_plot_array = {'o','+','square','^',...
    'diamond','.','hexagram','x','pentagram'}; % 9 options

cluster_count = clust.cluster_metadata.cluster_count;

%% Select Plotting Symbols
plot_array = cell(1,cluster_count);
for clust_it = 1:cluster_count
    plot_array{clust_it} = ref_plot_array{mod(clust_it-1,9)+1};
end

%% Randomly Select Points and Plot Them
rng(100);
for clust_it = 1:cluster_count
    rnd_idxs = randi(length(clust.clusters{clust_it}.indices),1,n_plot);
    pts_to_plot = COM_remap(clust.clusters{clust_it}.points(:,rnd_idxs));
    plot(pts_to_plot(1,:),pts_to_plot(2,:),plot_array{clust_it});
    hold on
end

end

