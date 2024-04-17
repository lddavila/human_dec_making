function centers = get_centers_from_precreated_clusters_by_task_type(directory_of_cluster_tables)
home_dir = cd(directory_of_cluster_tables);
cluster_table_dir_abs = cd(home_dir);

list_of_cluster_tables = strtrim(string(ls(strcat(cluster_table_dir_abs,"\*.xlsx"))));
centers = cell(length(list_of_cluster_tables),1);

for i=1:length(list_of_cluster_tables)
    current_table = readtable(strcat(cluster_table_dir_abs,"\",list_of_cluster_tables(i)));
    unique_cluster = unique(current_table.cluster_number);
    array_to_be_placed_in_centers = [];
    for j=1:length(unique_cluster)
        current_cluster_table = current_table(current_table.cluster_number == unique_cluster(j),:);
        array_of_cluster_xyz = table2array(current_cluster_table(:,2:4));
        mean_of_array = mean(array_of_cluster_xyz);
        array_to_be_placed_in_centers = [array_to_be_placed_in_centers;mean_of_array];
    end
    centers{i} = array_to_be_placed_in_centers;
end




end