function [] = create_bhaat_distance_mean_plots_for_single_data_type(data_table,colors,type_of_data,the_title,dir_to_save_figs_to,number_of_unique_subjects,number_of_sessions,date_created)
    figure('units','normalized','outerposition',[0 0 1 1])
    
    unique_clusters = unique(data_table.cluster_number);
    legend_strings = cell(1,length(unique_clusters));
    for i=1:length(unique_clusters)
        legend_strings{i} = char(strcat(type_of_data,string(unique_clusters(i))));
    end
    create3d_cluster_plot_given_the_table(data_table,colors,type_of_data,strcat(type_of_data," Clusters"),"log(abs(max))","log(abs(shift))","log(abs(slope))")
    
    cell_array_of_bhaat_dist = cell(length(unique_clusters),length(unique_clusters));
    for i=1:length(unique_clusters)
        just_cluster_i_rows = data_table(data_table.cluster_number==unique_clusters(i),:);
        array_of_just_cluster_i_xyz = [just_cluster_i_rows.clusterX,just_cluster_i_rows.clusterY,just_cluster_i_rows.clusterZ];
        labels = logical(ones(size(array_of_just_cluster_i_xyz,1),1));
        for j=1:length(unique_clusters)
            just_cluster_j_rows = data_table(data_table.cluster_number==unique_clusters(j),:);
            array_of_just_cluster_j_xyz = [just_cluster_j_rows.clusterX,just_cluster_j_rows.clusterY,just_cluster_j_rows.clusterZ];
            labels2 = logical(zeros(size(array_of_just_cluster_j_xyz,1),1));
            cell_array_of_bhaat_dist{i,j} = mean(bhattacharyyaDistance([array_of_just_cluster_i_xyz;array_of_just_cluster_j_xyz],[labels;labels2]));
        end
    end


    title([the_title, ...
        strcat("Number Of Subjects: ",string(number_of_unique_subjects)), ...
        strcat("Number of Sessions: ",string(number_of_sessions)), ...
        strcat("Date Created:",date_created), ...
        "Created by create\_bhaat\_distance\_mean\_plots\_for\_single\_data\_type.m"])
    set(gcf,'renderer','Painters');
    saveas(gcf,strcat(dir_to_save_figs_to,"\",the_title," the 3d plot.fig"),"fig");


    x = categorical(legend_strings);
    x = reordercats(x,legend_strings);

    figure('units','normalized','outerposition',[0 0 1 1])

    bar(x,cell2mat(cell_array_of_bhaat_dist));
    ylabel("Mean Bhattycharya distance between rat clusters")

    bar_plot_legend_strings = [];

    for i=1:length(unique_clusters)
        bar_plot_legend_strings= [bar_plot_legend_strings;strcat("mean bhat distance to cluster ",string(unique_clusters(i)))];
    end
    legend(bar_plot_legend_strings);


    title([the_title, ...
        strcat("Number Of Subjects: ",string(number_of_unique_subjects)), ...
        strcat("Number of Sessions: ",string(number_of_sessions)), ...
        strcat("Date Created:",date_created), ...
        "Created by create\_bhaat\_distance\_mean\_plots\_for\_single\_data\_type.m"])

    dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);

    set(gcf,'renderer','Painters');
    saveas(gcf,strcat(dir_to_save_figs_to,"\",the_title,"bar plot.fig"),"fig");

end