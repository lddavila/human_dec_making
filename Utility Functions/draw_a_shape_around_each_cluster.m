function [] = draw_a_shape_around_each_cluster(data_table,stats_map,human_or_rat,what_data,dir_to_save_figs_to,draw_lines_or_dont,colors)
figure;
unique_clusters = unique(data_table.cluster_number);
legend_strings = cell(1,length(unique_clusters));
plot_objects = cell(1,length(unique_clusters));

data_from_data_table = [data_table.clusterX,data_table.clusterY,data_table.clusterZ];
data_from_data_table = normalize(data_from_data_table,"range",[0,1]);
data_table.clusterX = data_from_data_table(:,1);
data_table.clusterY = data_from_data_table(:,2);
data_table.clusterZ = data_from_data_table(:,3);

for i=1:length(unique_clusters)
    curr_clust = unique_clusters(i);
    curr_color = colors(i,:);
    data_table_of_current_clust = data_table(data_table.cluster_number==curr_clust,:);
    curr_clust_xyz = [data_table_of_current_clust.clusterX,data_table_of_current_clust.clusterY,data_table_of_current_clust.clusterZ];
    % scatter3(curr_clust_xyz(:,1),curr_clust_xyz(:,2),curr_clust_xyz(:,3));
    plot_objects{i} = boundary(curr_clust_xyz(:,1),curr_clust_xyz(:,2),curr_clust_xyz(:,3));
    legend_strings{i} = char(strcat(what_data," Cluster ", string(i)));
    plot_objects{i} = trisurf(plot_objects{i},curr_clust_xyz(:,1),curr_clust_xyz(:,2),curr_clust_xyz(:,3),'Facecolor',curr_color);
    hold on;
end

title([strcat(what_data)]);
legend(legend_strings);
xlabel("log(abs(max))")
ylabel("log(abs(shift))")
zlabel("log(abs(slope))")

end