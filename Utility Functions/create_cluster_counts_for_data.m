function [] = create_cluster_counts_for_data(data_table,dir_to_save_figs_to)
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
    for j=1:length(unique_clusters)
        curr_clust = unique_clusters(j);
        only_curr_clust = only_curr_exp(only_curr_exp.cluster_number == curr_clust,:);
        cluster_counts(j) = size(only_curr_clust,1);
    end
    all_cluster_counts_by_story(curr_exp) = cluster_counts; 
    all_cluster_percentages_by_story(curr_exp) = cluster_counts /number_of_data_points_for_current_experiments;
    
end
disp("Counts")
disp(cell2mat(values(all_cluster_counts_by_story).'))
[significance, ~, ~,~,~] = dg_chi2test3(cell2mat(values(all_cluster_counts_by_story).'));
disp(significance)

disp("percentages")
disp(cell2mat(values(all_cluster_percentages_by_story).'))
[significance2,~,~,~,~] = dg_chi2test3(cell2mat(values(all_cluster_percentages_by_story).'));
disp(significance2)
end