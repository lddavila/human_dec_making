function [cluster_counts] = get_cluster_counts_2(all_data,unique_experiments,unique_clusters,normalize_or_dont)
cluster_counts = containers.Map('KeyType','char','ValueType','any');
for i=1:length(unique_experiments)
    current_experiment = unique_experiments{i};
    curr_exp_data = all_data(strcmpi(all_data.experiment,current_experiment),:);
    curr_clust_counts = zeros(1,length(unique_clusters));
    for j=1:length(unique_clusters)
        curr_clust = unique_clusters(j);
        curr_clust_data = curr_exp_data(curr_exp_data.cluster_number==curr_clust,:);
        curr_clust_counts(j) = height(curr_clust_data);
    end
    if normalize_or_dont
        curr_clust_counts = curr_clust_counts ./ height(curr_exp_data);
    end
    cluster_counts(current_experiment) = curr_clust_counts;

end

end