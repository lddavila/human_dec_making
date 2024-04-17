function [] = create_variance_spider_plots_different_clusters_same_story(data_table,dir_to_save_figs_to)
dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);
unique_clusters = unique(data_table.cluster_number);
unique_experiments = unique(data_table.experiment);




for j=1:length(unique_experiments)
    curr_exp = unique_experiments(j);
    legend_strings = [];
    % only_cur_exp = only_current_cluster_data(strcmpi(only_current_cluster_data.experiment,curr_exp),:);
    only_cur_exp = data_table(strcmpi(data_table.experiment,curr_exp),:);
    var_array = [];

    for i=1:length(unique_clusters)
        only_cur_exp_something = only_cur_exp(only_cur_exp.cluster_number == unique_clusters(i),:);
        legend_strings = [legend_strings,strcat("Cluster ",string(unique_clusters(i)))];
        only_current_xyz = [only_cur_exp_something.clusterX,only_cur_exp_something.clusterY,only_cur_exp_something.clusterZ];
        var_array = [var_array;var(only_current_xyz)];
    end

    
    plot_spider_plots_ontop_of_eachother_include_sig(var_array, ...
        ["var(log(abs(max)))","var(log(abs(shift)))","var(log(abs(slope)))"], ...
        strcat("Variance Between All Clusters In Experiment", string(curr_exp)), ...
        legend_strings, ...
        dir_to_save_figs_to,"");

end



end