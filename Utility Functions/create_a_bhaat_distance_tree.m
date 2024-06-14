function [] = create_a_bhaat_distance_tree(data_table,dir_to_save_figs_to,human_stats_map,type_of_data,the_title,version)
    % figure('units','normalized','outerposition',[0 0 1 1])
    dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);
    
    unique_clusters = unique(data_table.cluster_number);
    legend_strings = cell(1,length(unique_clusters));
    for i=1:length(unique_clusters)
        legend_strings{i} = char(strcat(type_of_data," Cluster ",string(unique_clusters(i))));
    end
   
    
    % get the bhaatycharya distance 
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



    %get the mean xyz
    array_of_mean_xyz = [];
    for i=1:length(unique_clusters)
        just_cluster_i_rows = data_table(data_table.cluster_number==unique_clusters(i),:);
        array_of_just_cluster_i_xyz = [just_cluster_i_rows.clusterX,just_cluster_i_rows.clusterY,just_cluster_i_rows.clusterZ];
        array_of_mean_xyz = [array_of_mean_xyz;mean(array_of_just_cluster_i_xyz)];
    end

    figure('units','normalized','outerposition',[0 0 1 1])
    G = graph(cell2mat(cell_array_of_bhaat_dist),legend_strings);
    LWidths = 5*G.Edges.Weight/max(G.Edges.Weight);


    
    cmap = colormap("hsv");
    flip(colormap);
    % plot(G,'XData',array_of_mean_xyz(:,1),'YData',array_of_mean_xyz(:,2),'ZData',array_of_mean_xyz(:,3),'EdgeLabel',G.Edges.Weight,'LineWidth',LWidths);
    p =plot(G,'EdgeLabel',G.Edges.Weight,'LineWidth',LWidths,'Layout','layered','EdgeCData',G.Edges.Weight,'EdgeColor','flat','MarkerSize',20);
    title([the_title, ...
        strcat("Number Of Subjects: ",string(human_stats_map('Number of Unique Subjects in all human data'))), ...
        strcat("Number of Sessions: ",string(human_stats_map('Number of Sessions in all human data'))), ...
        strcat("Date Created:",string(datetime("today",'Format','MM-d-yyyy'))), ...
        "Created by create\_a\_bhaat\_distance\_tree.m" ...
        ,version])
    c = colorbar;
    c.Label.String = "Mean Bhaatycharya distance";
    


    dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);

    set(gcf,'renderer','Painters');
    saveas(gcf,strcat(dir_to_save_figs_to,"\",the_title,"tree plot ",version,".fig"),"fig");

end