function [] = create_variance_spider_plots_same_cluster_different_story(data_table,dir_to_save_figs_to)
dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);
unique_clusters = unique(data_table.cluster_number);
unique_experiments = unique(data_table.experiment);



for i=1:length(unique_clusters)
    curr_cluster = unique_clusters(i);
    only_current_cluster_data = data_table(data_table.cluster_number == curr_cluster,:);
    array_of_variances = [];
    legend_strings = [];
    for j=1:length(unique_experiments)
        curr_exp = unique_experiments(j);
        legend_strings = [legend_strings,curr_exp];
        only_cur_exp = only_current_cluster_data(strcmpi(only_current_cluster_data.experiment,curr_exp),:);
        only_current_xyz = [only_cur_exp.clusterX,only_cur_exp.clusterY,only_cur_exp.clusterZ];
        array_of_variances = [array_of_variances;var(only_current_xyz)];
    end
    plot_spider_plots_ontop_of_eachother_given_axes_labels(array_of_variances, ...
        ["var(log(abs(max)))","var(log(abs(shift)))","var(log(abs(slope)))"], ...
        strcat("Variance Of Cluster ",string(curr_cluster), " Across All Experiments" ), ...
        legend_strings, ...
        dir_to_save_figs_to);
end

end