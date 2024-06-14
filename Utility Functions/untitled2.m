function [] = create_a_bhaat_dist_tree_comparing_rat_to_human(human_data_table,human_stats_map,rat_data_table,rat_stats_map,version_name,dir_to_save_figs_to)
dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);
rat_clusters = unique(rat_data_table.cluster_number);
human_clusters = unique(human_data_table.cluster_number);
cell_array_of_bhaat_distance = cell(length(rat_clusters),length(human_clusters));
for i=1:length(human_clusters)
    curr_hum_clust = human_clusters(i);
    curr_hum_data = human_data_table(human_data_table.cluster_number==curr_hum_clust,:);
    curr_hum_xyz = [curr_hum_data.clusterX,curr_hum_data.clusterY,curr_hum_data.clusterZ];
    hum_labels = logical(zeros(height(curr_hum_data),1));
    for j=1:length(rat_clusters)
        curr_rat_clust = rat_clusters(j);
        curr_rat_data = rat_data_table(rat_data_table.cluster_number==curr_rat_clust,:);
        curr_rat_xyz = [curr_rat_data.clusterX,curr_rat_data.clusterY,curr_rat_data.clusterz];
        rat_labels = logical(zeros(height(curr_rat_data),1) + 1);
        cell_array_of_bhaat_distance{i,j} = mean(bhattacharyyaDistance([curr_hum_xyz;curr_rat_xyz],[hum_labels;rat_labels]));

    end
end

figure;
G = graph(cell2mat(cell_array_of_bhaat_distance),legend_strings);
LWidths = 5*G.Edges.Weight/max(G.Edges.Weight);
cmap = colormap("hsv");
flip(colormap);
% plot(G,'XData',array_of_mean_xyz(:,1),'YData',array_of_mean_xyz(:,2),'ZData',array_of_mean_xyz(:,3),'EdgeLabel',G.Edges.Weight,'LineWidth',LWidths);
p=plot(G,'EdgeLabel',G.Edges.Weight,'LineWidth',LWidths,'Layout','layered','EdgeCData',G.Edges.Weight,'EdgeColor','flat','MarkerSize',20);
title([the_title, ...
    strcat("Number Of Human Subjects: ",string(human_stats_map('approach_avoid Number Of Unique Subjects'))), ...
    strcat("Number of Human Sessions: ",string(human_stats_map('approach_avoid Number of Data Points'))), ...
    strcat("Number Of Rat Subjects: ",string(rat_stats_map('Number Of Unique Subjects'))), ...
    strcat("Number of Rat Sessions: ",string(rat_stats_map('Number of Data Points'))), ...
    strcat("Date Created:",string(datetime("today",'Format','MM-d-yyyy'))), ...
    "Created by create\_a\_bhaat\_dist\_tree\_comparing\_rat\_to\_human.m" ...
    ,version_name])
c = colorbar;
c.Label.String = "Mean Bhaatycharya distance";

saveas(gcf,strcat(dir_to_save_figs_to,"\Bhaat distance Tree Graph Rat To Human ",version_name),"fig")
end