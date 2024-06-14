function [] = human_to_rat_3d_plot_normalized_ver_2(human_data_table,rat_data_table,what_data,colors,dir_to_save_figs_to,rat_stats_map,human_stats_map,version_name)
figure('units','normalized','outerposition',[0 0 1 1])
dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);
data_table = human_data_table;
unique_clusters = unique(data_table.cluster_number);
legend_strings = cell(1,length(unique_clusters)+length(unique(rat_data_table.cluster_number)));
plot_objects = cell(1,length(unique_clusters));

cell_array_of_xyz = cell(1,length(unique(human_data_table.cluster_number))+length(unique(rat_data_table.cluster_number)));

data_table = human_data_table;
data_from_data_table = [data_table.clusterX,data_table.clusterY,data_table.clusterZ];
data_from_data_table = normalize(data_from_data_table,"range",[0,1]);
data_table.clusterX = data_from_data_table(:,1);
data_table.clusterY = data_from_data_table(:,2);
data_table.clusterZ = data_from_data_table(:,3);
human_data_table = data_table;

data_table = rat_data_table;
data_from_data_table = [data_table.clusterX,data_table.clusterY,data_table.clusterZ];
data_from_data_table = normalize(data_from_data_table,"range",[0,1]);
data_table.clusterX = data_from_data_table(:,1);
data_table.clusterY = data_from_data_table(:,2);
data_table.clusterZ = data_from_data_table(:,3);
rat_data_table = data_table;


data_table = human_data_table;
for i=1:length(unique_clusters)
    curr_clust = unique_clusters(i);
    curr_color = colors(1,:);
    data_table_of_current_clust = data_table(data_table.cluster_number==curr_clust,:);
    curr_clust_xyz = [data_table_of_current_clust.clusterX,data_table_of_current_clust.clusterY,data_table_of_current_clust.clusterZ];
    random_sample_array = [];
    for k=1:1100
        random_sample_array = [random_sample_array;datasample(curr_clust_xyz,1)];
    end
    cell_array_of_xyz{i} = random_sample_array;
    scatter3(curr_clust_xyz(:,1),curr_clust_xyz(:,2),curr_clust_xyz(:,3),'MarkerFaceColor',curr_color,'MarkerEdgeColor',curr_color);
    % plot_objects{i} = boundary(curr_clust_xyz(:,1),curr_clust_xyz(:,2),curr_clust_xyz(:,3),1);
    legend_strings{i} = char(strcat("Human Cluster ", string(i)));
    % plot_objects{i} = trisurf(plot_objects{i},curr_clust_xyz(:,1),curr_clust_xyz(:,2),curr_clust_xyz(:,3),'Facecolor',curr_color);
    hold on;
end


data_table = rat_data_table;
unique_clusters = unique(data_table.cluster_number);
for i=1:length(unique_clusters)
    curr_clust = unique_clusters(i);
    curr_color = colors(2,:);
    data_table_of_current_clust = data_table(data_table.cluster_number==curr_clust,:);
    curr_clust_xyz = [data_table_of_current_clust.clusterX,data_table_of_current_clust.clusterY,data_table_of_current_clust.clusterZ];
    scatter3(curr_clust_xyz(:,1),curr_clust_xyz(:,2),curr_clust_xyz(:,3),'MarkerFaceColor',curr_color,'MarkerEdgeColor',curr_color);
    random_sample_array = [];
    for k=1:1100
        random_sample_array = [random_sample_array;datasample(curr_clust_xyz,1)];
    end
    cell_array_of_xyz{i + length(unique(human_data_table.cluster_number))} = random_sample_array;
    % plot_objects{i} = boundary(curr_clust_xyz(:,1),curr_clust_xyz(:,2),curr_clust_xyz(:,3),1);
    legend_strings{i + length(unique(human_data_table.cluster_number))} = char(strcat("Rat Cluster ", string(i)));
    % plot_objects{i} = trisurf(plot_objects{i},curr_clust_xyz(:,1),curr_clust_xyz(:,2),curr_clust_xyz(:,3),'Facecolor',curr_color);
    hold on;
end
legend(legend_strings);
xlabel("log(abs(max))")
ylabel("log(abs(shift))")
zlabel("log(abs(slope))")



title([strcat(what_data), ...
    strcat("Approach\_avoid # of data points:",string(human_stats_map('approach_avoid Number of Data Points'))," Approach Avoid # of subjects",string(human_stats_map('approach_avoid Number Of Unique Subjects'))),...
    strcat("Rat # of data points:",string(rat_stats_map('Number of Data Points')), "Number of Unique Subjects",string(rat_stats_map('Number of Data Points'))),...
    version_name, ...
    strcat("Date Created:", string(datetime("today",'Format','MM-d-yyyy'))), ...
    "created by human\_to\_rat\_3d\_plot\_normalized\_ver\_2"]);



end