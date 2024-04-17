function [] = create_spider_plots_with_sig_using_dg(data_table,dir_to_save_figs_to,human_stats_map)
dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);
unique_clusters = unique(data_table.cluster_number);
unique_experiments = unique(data_table.experiment);
all_cluster_counts_by_story = containers.Map('KeyType','char','ValueType','any');
all_cluster_percentages_by_story = containers.Map('KeyType','char','ValueType','any');
disp("Using Dan Gibson chi2test")
for i=1:length(unique_experiments)
    curr_exp = string(unique_experiments(i));
    only_curr_exp = data_table(strcmpi(data_table.experiment,curr_exp),:);
    number_of_data_points_for_current_experiments = size(only_curr_exp,1);
    cluster_counts = get_cluster_counts(only_curr_exp,unique_clusters);
    cluster_1_probabilities = cluster_counts ./ number_of_data_points_for_current_experiments;
    for j=i+1:length(unique_experiments)
        curr_exp_2 = string(unique_experiments(j));
        only_curr_exp_2 = data_table(strcmpi(data_table.experiment,curr_exp_2),:);
        number_of_data_points_for_current_experiments_2=size(only_curr_exp_2,1);
        cluster_counts_2 = get_cluster_counts(only_curr_exp_2,unique_clusters);
        disp(strcat("Experiment 1: ", curr_exp," Experiment 2: ",curr_exp_2));
        disp([cluster_counts;cluster_counts_2])

        [p,~,~,~,~] = dg_chi2test3([cluster_counts;cluster_counts_2]);
        disp(strcat("Significance",string(p)));
        cluster_2_probabilities = cluster_counts_2 ./ number_of_data_points_for_current_experiments_2;

        plot_spider_plots_ontop_of_eachother([cluster_1_probabilities;cluster_2_probabilities], ...
            unique_clusters, ...
            [strcat(curr_exp," Vs ",curr_exp_2, " P Value from dg_chi2test3 ",num2str(p)), ...
            strcat("Number Of ",curr_exp," Sessions:",string(sum(cluster_counts))), ...
            strcat("Number Of ",curr_exp," Subjects:",string(human_stats_map(strcat(curr_exp," Number Of Unique Subjects")))), ...
            strcat("Number of ",curr_exp_2," Sessions:", string(sum(cluster_counts_2))), ...
            strcat("Number of ",curr_exp_2," Subjects:", string(human_stats_map(strcat(curr_exp_2," Number Of Unique Subjects")))), ...
            strcat("Date Created:",string(datetime("today",'Format','MM-d-yyyy'))), ...
            "created by create\_spider\_plots\_with\_sig\_using\_dg"], ...
            [curr_exp,curr_exp_2], ...
            dir_to_save_figs_to);
    end

    
end

end