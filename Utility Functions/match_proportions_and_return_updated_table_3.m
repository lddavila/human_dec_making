function [table_with_new_proportions] = match_proportions_and_return_updated_table_3(human_data_table,array_of_propotions_to_match_to,experiment_to_keep)
table_with_new_proportions = [];
% now take a random sampling of the remaining data which matches the proportions of array_of_proportions_to_match_to
unique_clusters = unique(human_data_table.cluster_number);
only_experiment_to_keep = human_data_table(strcmpi(human_data_table.experiment,experiment_to_keep),:);
for i=1:length(unique_clusters)
    curr_clust = unique_clusters(i);
    table_with_only_curr_clust = only_experiment_to_keep(only_experiment_to_keep.cluster_number == curr_clust,:);
    sample = datasample(table_with_only_curr_clust,round(array_of_propotions_to_match_to(i)*height(only_experiment_to_keep)));
    table_with_new_proportions = [table_with_new_proportions;sample];
end
% table_with_new_proportions.experiment = repelem({char(name_of_experiment_to_match_to)},height(table_with_new_proportions),1);
probabilities = get_cluster_counts(table_with_new_proportions,unique_clusters) ./ height(table_with_new_proportions);
% disp(probabilities);
end