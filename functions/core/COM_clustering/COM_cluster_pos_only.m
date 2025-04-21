function clusters = ...
    COM_cluster_pos_only(sample_set,k_cluster,COM_remap)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% Default k Value
if nargin < 2
    k_cluster = 15;
end

%% Define Effective Points to Cluster based on COM
raw_state_pts = sample_set(1:6,:);

% Calculate COM Variables for sample points
COM_pts = COM_remap(raw_state_pts);

%% Cluster Points
[idx,C] = kmeans(COM_pts.', k_cluster);

clusters.idx = idx.';

%% Assign Original Sample-Set Points to Clusters
clusters.clusters = cell(1,k_cluster);
for c_it = 1:k_cluster
    clusters.clusters{c_it}.indices = find(clusters.idx==c_it);
    clusters.clusters{c_it}.points = sample_set(:,...
        clusters.clusters{c_it}.indices);
    clusters.clusters{c_it}.center = C(c_it,:).';
    clusters.clusters{c_it}.covar = cov(COM_pts(:,clusters.clusters{c_it}.indices).');
    clusters.clusters{c_it}.std = sqrt(trace(clusters.clusters{c_it}.covar));
end

%% Establish Metadata
clusters.cluster_metadata.cluster_count = k_cluster;
clusters.cluster_metadata.centers = NaN(2,k_cluster);
clusters.cluster_metadata.stds = NaN(1,k_cluster);
for c_it = 1:k_cluster
    clusters.cluster_metadata.centers(:,c_it) = ...
        clusters.clusters{c_it}.center;
    clusters.cluster_metadata.stds(c_it) = clusters.clusters{c_it}.std;
end

end