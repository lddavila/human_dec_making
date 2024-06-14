function [] = create_a_bhaat_dist_tree_comparing_rat_to_human_ver_2(human_data_table,human_stats_map,rat_data_table,rat_stats_map,version_name,dir_to_save_figs_to,the_title)
dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);
rat_clusters = unique(rat_data_table.cluster_number);
human_clusters = unique(human_data_table.cluster_number);


for j=1:length(rat_clusters)
    curr_rat_clust = rat_clusters(j);
    curr_rat_data = rat_data_table(rat_data_table.cluster_number==curr_rat_clust,:);
    curr_rat_xyz = [curr_rat_data.clusterX,curr_rat_data.clusterY,curr_rat_data.clusterZ];
    rat_labels = logical(zeros(height(curr_rat_data),1) + 1);

    array_of_bhaat_distance = zeros(1+length(human_clusters),length(human_clusters)+1);
    for i=1:length(human_clusters)
        curr_hum_clust = human_clusters(i);
        curr_hum_data = human_data_table(human_data_table.cluster_number==curr_hum_clust,:);
        curr_hum_xyz = [curr_hum_data.clusterX,curr_hum_data.clusterY,curr_hum_data.clusterZ];
        hum_labels = logical(zeros(height(curr_hum_data),1));

        array_of_bhaat_distance(i,1+length(human_clusters)) = mean(bhattacharyyaDistance([curr_hum_xyz;curr_rat_xyz],[hum_labels;rat_labels]));
        array_of_bhaat_distance(1+length(human_clusters),i) = mean(bhattacharyyaDistance([curr_hum_xyz;curr_rat_xyz],[hum_labels;rat_labels]));

    end

    cluster_labels = [];

    for i=1:(1 + length(human_clusters))
        if i<=length(human_clusters)
            cluster_labels = [cluster_labels;strcat("Human Cluster ",string(i))];
        else
            cluster_labels = [cluster_labels;strcat("Rat Cluster ", string(curr_rat_clust))];
        end
    end

    figure('units','normalized','outerposition',[0 0 1 1])
    % clc;
    % disp(array_of_bhaat_distance);
    % disp(cluster_labels)
    G = graph(array_of_bhaat_distance,cluster_labels);
    LWidths = 5*G.Edges.Weight/max(G.Edges.Weight);
    cmap = colormap("hsv");
    flip(colormap);
    % plot(G,'XData',array_of_mean_xyz(:,1),'YData',array_of_mean_xyz(:,2),'ZData',array_of_mean_xyz(:,3),'EdgeLabel',G.Edges.Weight,'LineWidth',LWidths);
    p=plot(G,'EdgeLabel',G.Edges.Weight,'LineWidth',LWidths,'Layout','layered','EdgeCData',G.Edges.Weight,'EdgeColor','flat','MarkerSize',20);
    title([strcat(the_title," All Human Clusters vs Rat Cluster ",string(curr_rat_clust)), ...
        strcat("Number Of Human Approach Avoid Subjects: ",string(human_stats_map('approach_avoid Number Of Unique Subjects'))), ...
        strcat("Number of Human Approach Avoid Sessions: ",string(human_stats_map('approach_avoid Number of Data Points'))), ...
        strcat("Number Of Rat Subjects: ",string(rat_stats_map('Number Of Unique Subjects'))), ...
        strcat("Number of Rat Sessions: ",string(rat_stats_map('Number of Data Points'))), ...
        strcat("Date Created:",string(datetime("today",'Format','MM-d-yyyy'))), ...
        "create\_a\_bhaat\_dist\_tree\_comparing\_rat\_to\_human\_ver\_2.m" ...
        ,version_name])
    c = colorbar;
    c.Label.String = "Mean Bhaatycharya distance";

    saveas(gcf,strcat(dir_to_save_figs_to,"\Bhaat distance Tree Graph All Human Clusters vs Rat Cluster",string(curr_rat_clust),version_name),"fig")


end




end