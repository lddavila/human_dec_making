function [] = create_boxplot_cluster_permutations(data_table,dir_to_save_figs_to)
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
            figure('units','normalized','outerposition',[0 0 1 1])
            subplot(1,2,1);
            boxplot(only_current_xyz,'Notch','on',"Labels",{'log(abs(max))','log(abs(shift))','log(abs(slope))'})
            title(strcat("Cluster ",string(i)," Of ",curr_exp," Experiment"))

            subplot(1,2,2);
            curr_exp_2 = unique_experiments(k);
            only_curr_exp_2 = only_current_cluster_data(strcmpi(only_current_cluster_data.experiment,curr_exp_2),:);
            only_curr_exp_2_for_cluster_counts = data_table(strcmpi(data_table.experiment,curr_exp_2),:);
            only_curr_xyz_2 = [only_curr_exp_2.clusterX,only_curr_exp_2.clusterY,only_curr_exp_2.clusterZ];
            [p,~,~,~,~] = dg_chi2test3([get_cluster_counts(only_cur_exp_for_cluster_counts,unique_clusters);get_cluster_counts(only_curr_exp_2_for_cluster_counts,unique_clusters)]);

            boxplot(only_curr_xyz_2,'Notch','on',"Labels",{'log(abs(max))','log(abs(shift))','log(abs(slope))'})
            title(strcat("Cluster", string(i), " Of ", curr_exp_2," Experiment"," Sig. from dg\_chi2test3: ",string(p)))
            
 

            saveas(gcf,strcat(dir_to_save_figs_to,"\Cluster ",string(i)," Of ",curr_exp," And ",curr_exp_2,".fig"),"fig");
        end
    end

end

end