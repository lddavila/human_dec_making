function [] = create_boxplot_cluster_permutations_3(data_table,dir_to_save_figs_to)
dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);
unique_clusters = unique(data_table.cluster_number);
unique_experiments = unique(data_table.experiment);
for i=1:length(unique_clusters)
    curr_cluster = unique_clusters(i);
    only_current_cluster_data = data_table(data_table.cluster_number == curr_cluster,:);
    legend_strings = [];
    category_array_for_x = [];
    category_array_for_y = [];
    category_array_for_z = [];

    all_x_for_all_cluster_i_between_experiment = [];
    all_y_for_all_cluster_i_between_experiment = [];
    all_z_for_all_cluster_i_between_experiment = [];

    axes_strings = ["log(abs(max))","log(abs(shift))","log(abs(slope))"];

    for j=1:length(unique_experiments)
        curr_exp = unique_experiments(j);
        legend_strings = [legend_strings,curr_exp];
        only_cur_exp = only_current_cluster_data(strcmpi(only_current_cluster_data.experiment,curr_exp),:);
        only_cur_exp_for_cluster_counts = data_table(strcmpi(data_table.experiment,curr_exp),:);
        only_current_xyz = [only_cur_exp.clusterX,only_cur_exp.clusterY,only_cur_exp.clusterZ];
        category_array_for_x = [category_array_for_x;repelem(curr_exp,size(only_current_xyz,1),1)];
        category_array_for_y = [category_array_for_y;repelem(curr_exp,size(only_current_xyz,1),1)];
        category_array_for_z = [category_array_for_z;repelem(curr_exp,size(only_current_xyz,1),1)];

        all_x_for_all_cluster_i_between_experiment = [all_x_for_all_cluster_i_between_experiment;only_current_xyz(:,1)];
        all_y_for_all_cluster_i_between_experiment = [all_y_for_all_cluster_i_between_experiment;only_current_xyz(:,2)];
        all_z_for_all_cluster_i_between_experiment = [all_z_for_all_cluster_i_between_experiment;only_current_xyz(:,3)];
    end
    
    secondary_category_array = [repelem(axes_strings(1),length(category_array_for_x),1);repelem(axes_strings(2),length(category_array_for_x),1);repelem(axes_strings(3),length(category_array_for_x),1)];

    first_category_array = [category_array_for_x;category_array_for_y;category_array_for_z]; 

    all_box_plot_data = [all_x_for_all_cluster_i_between_experiment;all_y_for_all_cluster_i_between_experiment;all_z_for_all_cluster_i_between_experiment];

    figure('units','normalized','outerposition',[0 0 1 1])
    boxplot(all_box_plot_data,{secondary_category_array,first_category_array})

    the_title = strcat("Cluster ", string(i)," log(abs(max)), log(abs(shift)), og(abs(slope))");
    title(the_title);

    saveas(gcf,strcat(dir_to_save_figs_to,"\",the_title,".fig"),"fig")


end

end