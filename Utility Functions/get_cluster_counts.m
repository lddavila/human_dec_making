function [cluster_counts] = get_cluster_counts(only_curr_exp,unique_clusters)
cluster_counts = zeros(1,length(unique_clusters));
for q=1:length(unique_clusters)
    curr_clust_indp = unique_clusters(q);
    only_curr_clust_Data = only_curr_exp(only_curr_exp.cluster_number == curr_clust_indp,:);
    cluster_counts(q) = size(only_curr_clust_Data,1);
end
end