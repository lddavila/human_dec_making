function [] = create_variance_spider_plots_same_cluster_different_story_permu(data_table,dir_to_save_figs_to)
dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);
unique_clusters = unique(data_table.cluster_number);
unique_experiments = unique(data_table.experiment);
for i=1:length(unique_clusters)
    curr_cluster = unique_clusters(i);
    only_current_cluster_data = data_table(data_table.cluster_number == curr_cluster,:);
    legend_strings = [];
    for j=1:length(unique_experiments)
        curr_exp = unique_experiments(j);
        legend_strings = [legend_strings,curr_exp];
        only_cur_exp = only_current_cluster_data(strcmpi(only_current_cluster_data.experiment,curr_exp),:);
        only_cur_exp_for_cluster_counts = data_table(strcmpi(data_table.experiment,curr_exp),:);
        only_current_xyz = [only_cur_exp.clusterX,only_cur_exp.clusterY,only_cur_exp.clusterZ];
        curr_exp_var = var(only_current_xyz);
        for k=j+1:length(unique_experiments)
            curr_exp_2 = unique_experiments(k);
            only_curr_exp_2 = only_current_cluster_data(strcmpi(only_current_cluster_data.experiment,curr_exp_2),:);
            only_curr_exp_2_for_cluster_counts = data_table(strcmpi(data_table.experiment,curr_exp_2),:);
            only_curr_xyz_2 = [only_curr_exp_2.clusterX,only_curr_exp_2.clusterY,only_curr_exp_2.clusterZ];
            curr_exp_var_2 = var(only_curr_xyz_2);
            [p,~,~,~,~] = dg_chi2test3([get_cluster_counts(only_cur_exp_for_cluster_counts,unique_clusters);get_cluster_counts(only_curr_exp_2_for_cluster_counts,unique_clusters)]);
            [h,p] = vartest2(only_current_xyz,only_curr_xyz_2);
            plot_spider_plots_ontop_of_eachother_include_sig([curr_exp_var;curr_exp_var_2], ...
                [strcat("var(log(abs(max)))"), ...
                strcat("var(log(abs(shift)))"), ...
                strcat("var(log(abs(slope)))")], ...
                strcat("Variance Of Cluster ",string(curr_cluster), " Between ",curr_exp," and ",curr_exp_2 ), ...
                [curr_exp,curr_exp_2], ...
                dir_to_save_figs_to,sprintf("max->p:%.3f h:%d shift->p:%.3f h:%d slope->p:%.3f h:%d \n From 2 Sample F Test",p(1),h(1),p(2),h(2),p(3),h(3)));
        end
    end

end

end