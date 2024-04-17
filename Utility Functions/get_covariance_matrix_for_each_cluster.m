function [map_of_covariance_matrices,map_of_array_of_cluster_proportions] = get_covariance_matrix_for_each_cluster(folder_with_cluster_tables)
    function all_cluster_table_names= get_list_of_data_sets(cluster_table_path_abs)
        all_cluster_table_names = strtrim(string(ls(strcat(cluster_table_path_abs,"\*.xlsx"))));

    end
    function abs_path = get_abs_path(relative_path)
        home_dir = cd(relative_path);
        abs_path = cd(home_dir);
    end
    function [map_of_array_of_covariance_matrices,map_of_array_of_cluster_proportions]= get_covariance_matrices(list_of_clusters,cluster_tables_abs)
        map_of_array_of_covariance_matrices = containers.Map('KeyType','char','ValueType','any');
        map_of_array_of_cluster_proportions = containers.Map('KeyType','char','ValueType','any');
        for i=1:length(list_of_clusters)
            current_feature_info = readtable(strcat(cluster_tables_abs,"\",list_of_clusters(i)));
            unique_clusters = unique(current_feature_info.cluster_number);
            cell_array_of_covariance_matrices = cell(1,length(unique_clusters));
            cell_array_of_cluster_proportions = cell(1,length(unique_clusters));
            for j=1:length(unique_clusters)
                current_cluster = unique_clusters(j);
                table_of_only_current_cluster = current_feature_info(current_feature_info.cluster_number == current_cluster,:);
                xyz_of_current_cluster_as_matrix = table_of_only_current_cluster{:,2:4};
                cell_array_of_covariance_matrices{j} = cov(xyz_of_current_cluster_as_matrix);
                cell_array_of_cluster_proportions{j} = height(table_of_only_current_cluster)/height(current_feature_info);
            end
            map_of_array_of_covariance_matrices(strrep(list_of_clusters(i),".xlsx","")) = cell_array_of_covariance_matrices;
            map_of_array_of_cluster_proportions(strrep(list_of_clusters(i),".xlsx","")) = cell_array_of_cluster_proportions;
        end
    end
    cluster_tables_abs = get_abs_path(folder_with_cluster_tables);
    list_of_clusters = get_list_of_data_sets(cluster_tables_abs);
    [map_of_covariance_matrices,map_of_array_of_cluster_proportions ]= get_covariance_matrices(list_of_clusters,cluster_tables_abs);

end