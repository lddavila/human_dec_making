function [] = create_cluster_counts_for_data_use_built_in(data_table,dir_to_save_figs_to)
dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);
unique_clusters = unique(data_table.cluster_number);
unique_experiments = unique(data_table.experiment);
all_cluster_counts_by_story = containers.Map('KeyType','char','ValueType','any');
all_cluster_percentages_by_story = containers.Map('KeyType','char','ValueType','any');
for i=1:length(unique_experiments)
    curr_exp = string(unique_experiments(i));
    only_curr_exp = data_table(strcmpi(data_table.experiment,curr_exp),:);
    number_of_data_points_for_current_experiments = size(only_curr_exp,1);
    cluster_counts = zeros(1,length(unique_clusters));
    vector_of_cluster_numbers_for_curr_exp = [];
    for j=1:length(unique_clusters)
        curr_clust = unique_clusters(j);
        only_curr_clust = only_curr_exp(only_curr_exp.cluster_number == curr_clust,:);
        vector_of_cluster_numbers_for_curr_exp = [vector_of_cluster_numbers_for_curr_exp,only_curr_clust.cluster_number.'];
        cluster_counts(j) = size(only_curr_clust,1);
    end

    for j=1:length(unique_experiments)
        curr_exp_2 = string(unique_experiments(j));
        only_curr_exp_2 = data_table(strcmpi(data_table.experiment,curr_exp_2),:);
        number_of_data_points_for_current_experiments_2=size(only_curr_exp_2,1);
        cluster_counts_2 = zeros(1,length(unique_clusters));
        vector_of_cluster_numbers_for_curr_exp_2 = [];
        for k=1:length(unique_clusters)
            curr_clust_2=unique_clusters(k);
            only_curr_clust_2 = only_curr_exp_2(only_curr_exp_2.cluster_number==curr_clust_2,:);
            vector_of_cluster_numbers_for_curr_exp_2 = [vector_of_cluster_numbers_for_curr_exp_2,only_curr_clust_2.cluster_number.'];
            
        end
    end


    % all_cluster_counts_by_story(curr_exp) = cluster_counts; 
    % all_cluster_percentages_by_story(curr_exp) = cluster_counts /number_of_data_points_for_current_experiments;
    
end

end