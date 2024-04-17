function [] = create_overlain_spider_plots_for_data(data_table,dir_to_save_things_to)
dir_to_save_things_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_things_to);
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
    % plot_spider_plots(cluster_probabilities,unique_clusters,curr_exp);
    for j=1:length(unique_experiments)
        curr_exp_2 = string(unique_experiments(j));
        only_curr_exp_2 = data_table(strcmpi(data_table.experiment,curr_exp_2),:);
        number_of_data_points_for_current_experiments_2=size(only_curr_exp_2,1);
        cluster_counts_2 = zeros(1,length(unique_clusters));
        for k=1:length(unique_clusters)
            curr_clust_2 = unique_clusters(k);
            only_curr_clust_2 = only_curr_exp_2(only_curr_exp_2.cluster_number == curr_clust_2,:);
            cluster_counts_2(k) = size(only_curr_clust_2,1);

        end
        cluster_probabilities_2 = cluster_counts_2 / number_of_data_points_for_current_experiments_2;
        plot_spider_plots_ontop_of_eachother([cluster_probabilities;cluster_probabilities_2], ...
            unique_clusters, ...
            strcat(curr_exp, " Vs ", curr_exp_2), ...
            [curr_exp,curr_exp_2], ...
            dir_to_save_things_to);
    end
end
end