function get_bhattacharyya_distance_plots(directory_of_cluster_tables)
    home_dir = cd(directory_of_cluster_tables);
    abs_cluster_table_dir = pwd;
    cd(home_dir);
    
    list_of_cluster_tables = strtrim(string(ls(strcat(abs_cluster_table_dir,"\*.xlsx"))));

    for i=1:length(list_of_cluster_tables)-1
        first_table = readtable(strcat(abs_cluster_table_dir,"\",list_of_cluster_tables(i)));
        list_of_clusters_from_first_table = unique(first_table.cluster_number);
        for current_cluster_number=1:length(list_of_clusters_from_first_table)
            second_table = readtable(strcat(abs_cluster_table_dir,"\",list_of_cluster_tables(i+1)));
            list_of_second_clusters = unique(second_table.cluster_number);
            rows_from_first_table_of_current_cluster = first_table(first_table.cluster_number==list_of_clusters_from_first_table(current_cluster_number),:);

            array_of_data_from_first_table = [rows_from_first_table_of_current_cluster.clusterX,rows_from_first_table_of_current_cluster.clusterY,rows_from_first_table_of_current_cluster.clusterZ];
            labels_for_data_from_first_table = zeros(size(array_of_data_from_first_table,1),1);

            array_of_b_dist = cell(length(list_of_second_clusters),1);
            for second_table_current_cluster=1:length(list_of_second_clusters)
                rows_from_second_table_of_current_cluster = second_table(second_table.cluster_number == list_of_second_clusters(second_table_current_cluster),:);

                array_of_data_from_second_table = [rows_from_second_table_of_current_cluster.clusterX,rows_from_second_table_of_current_cluster.clusterY,rows_from_second_table_of_current_cluster.clusterZ];

                labels_for_data_from_second_table = ones(size(array_of_data_from_second_table,1),1);

                both_data_combined = [array_of_data_from_first_table;array_of_data_from_second_table];

                labels_combined = logical([labels_for_data_from_first_table;labels_for_data_from_second_table]);

                array_of_b_dist{second_table_current_cluster} = bhattacharyyaDistance(both_data_combined,labels_combined);


            end
            figure;
            bar(cell2mat(array_of_b_dist));
            title(strcat(strrep(strrep(list_of_cluster_tables(i),".xlsx",""),"_","\_")," Cluster: ",string(current_cluster_number)," vs All Other Clusters In ",strrep(strrep(list_of_cluster_tables(i+1),".xlsx",""),"_","\_")));
            subtitle("bhattacharyyaDistance")
            legend("Log(abs(max))","log(abs(shift))","log(abs(slope))")
        end
    end

end