function [] = create_spider_plots_for_data(data_table,dir_to_save_figs_to)
dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);
unique_clusters = unique(data_table.cluster_number);
unique_experiments = unique(data_table.experiment);
for i=1:length(unique_experiments)
    curr_exp = string(unique_experiments(i));
    only_curr_exp = data_table(strcmpi(data_table.experiment,curr_exp),:);
    number_of_data_points_for_current_experiments = size(only_curr_exp,1);
    cluster_counts = zeros(1,length(unique_clusters));
    for j=1:length(unique_clusters)
        curr_clust = unique_clusters(j);
        only_curr_clust = only_curr_exp(only_curr_exp.cluster_number == curr_clust,:);
        cluster_counts(j) = size(only_curr_clust,1);
    end
    cluster_probabilities = cluster_counts / number_of_data_points_for_current_experiments;
    plot_spider_plots(cluster_probabilities,unique_clusters,curr_exp,dir_to_save_figs_to);
end
end