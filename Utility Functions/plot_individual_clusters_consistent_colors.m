function plot_individual_clusters_consistent_colors(cluster_tables_dir,axis_object,subplot_beginning)
    home_dir =cd(cluster_tables_dir);
    cluster_table_dir_abs = cd(home_dir);

    human_tables = strtrim(string(ls((strcat(cluster_table_dir_abs,"\*human*.xlsx")))));
    rat_tables = strtrim(string(ls((strcat(cluster_table_dir_abs,"\*rat*.xlsx")))));




    cell_array_of_b_dist = cell(1,4);
    rat_centers = [-9.19224 -0.160122 -5.94521; 0.0725258 9.26768 5.38323;-0.0750791 2.44643 4.20085; 7.26215 9.12042 2.84782];
    human_centers = [-7.616854999999999 0.774569569125500 -7.101532000000001;4.16898 11.8951 2.47445;4.06153 3.09722 0.625457;11.3803 12.5503 0.188948];
    for i=1:length(human_tables)
        current_human_table = readtable(strcat(cluster_table_dir_abs,"\",human_tables(i)));
        list_of_human_clusters = unique(current_human_table.cluster_number);
        current_rat_table = readtable(strcat(cluster_table_dir_abs,"\",rat_tables(i)));
        for k=1:length(list_of_human_clusters)
            table_for_only_current_human_clusters = current_human_table(current_human_table.cluster_number==list_of_human_clusters(k),:);
            table_for_only_current_rat_clusters = current_rat_table(current_rat_table.cluster_number==list_of_human_clusters(k),:);

            matrix_of_human_and_rat_data = [[table_for_only_current_human_clusters.clusterX,table_for_only_current_human_clusters.clusterY,table_for_only_current_human_clusters.clusterZ];
                [table_for_only_current_rat_clusters.clusterX,table_for_only_current_rat_clusters.clusterY,table_for_only_current_rat_clusters.clusterZ]];

            logical_classification_labels_for_human = logical(zeros(height(table_for_only_current_human_clusters),1));

            logical_classification_labels_for_rats = logical(ones(height(table_for_only_current_rat_clusters),1));


            cell_array_of_b_dist{k} = bhattacharyyaDistance(matrix_of_human_and_rat_data,[logical_classification_labels_for_human;logical_classification_labels_for_rats]);

            axis_object = subplot(3,4,subplot_beginning);
            

            if k==1
                plot3(axis_object,table_for_only_current_rat_clusters.clusterX,table_for_only_current_rat_clusters.clusterY,table_for_only_current_rat_clusters.clusterZ,'o','MarkerEdgeColor',[0 0 1]);%for rat
                hold on;
                plot3(axis_object,table_for_only_current_human_clusters.clusterX,table_for_only_current_human_clusters.clusterY,table_for_only_current_human_clusters.clusterZ,'x','MarkerEdgeColor',[0,0.1,0.7]);%for human
            elseif k==2
                plot3(axis_object,table_for_only_current_rat_clusters.clusterX,table_for_only_current_rat_clusters.clusterY,table_for_only_current_rat_clusters.clusterZ,'o','MarkerEdgeColor',[1 0 0]);%for rat
                hold on;
                plot3(axis_object,table_for_only_current_human_clusters.clusterX,table_for_only_current_human_clusters.clusterY,table_for_only_current_human_clusters.clusterZ,'x','MarkerEdgeColor',[0.7,0,0]);%for human
            elseif k==3
                plot3(axis_object,table_for_only_current_rat_clusters.clusterX,table_for_only_current_rat_clusters.clusterY,table_for_only_current_rat_clusters.clusterZ,'o','MarkerEdgeColor',[0.7 0 0.7]);%for rat
                hold on;
                plot3(axis_object,table_for_only_current_human_clusters.clusterX,table_for_only_current_human_clusters.clusterY,table_for_only_current_human_clusters.clusterZ,'x','MarkerEdgeColor',[0.5 0 0.5]);%for human
            elseif k==4
                plot3(axis_object,table_for_only_current_rat_clusters.clusterX,table_for_only_current_rat_clusters.clusterY,table_for_only_current_rat_clusters.clusterZ,'o','MarkerEdgeColor',[.7 .7 .7]);%for rat
                hold on;
                plot3(axis_object,table_for_only_current_human_clusters.clusterX,table_for_only_current_human_clusters.clusterY,table_for_only_current_human_clusters.clusterZ,'x','MarkerEdgeColor',[0 0 0]);%for human
            end
            title(strcat("Cluster ",string(k)," For Rat And Human"));
            % subtitle(["bhattacharyya Distance:";strcat("X:",string(b_dist(1)));strcat("Y:",string(b_dist(2)));strcat("Z:",string(b_dist(3)))])
            plot3(rat_centers(k,1),rat_centers(k,2),rat_centers(k,3),"xk",MarkerSize=30,LineWidth=3)
            plot3(human_centers(k,1),human_centers(k,2),human_centers(k,3),"*k",MarkerSize=30,LineWidth=3);
            legend("Rat","Human","","",'Location','best')
            xlabel("Sigmoid Max")
            ylabel("Sigmoid Shift")
            zlabel("Sigmoid Slope")

            
            hold off;
            if k==1
                view([22.222295317200498 -24.755185064999740  31.693874785310364]);
            elseif k==2
                view([0,90]);
            elseif k==3
                view([-24.290341133472225 -2.175878866592740e+02 51.965629743834235]);
            elseif k==4
                view([10.342785966233317   5.324506570489351  77.775965228544266]);
            end

            subplot_beginning=subplot_beginning+1;
            % bar(["log(abs(max))","log(abs(shift))","log(abs(slope))"],b_dist)

            
        end
    end
    for i=1:length(cell_array_of_b_dist)
        subplot(3,4,subplot_beginning)
        subplot_beginning=subplot_beginning+1;
        b_dist=cell_array_of_b_dist{i};
        bar(["Max","Shift","Slope"],b_dist);
        title(strcat("B. Dist. From Hum. Clust. ",string(i), " To Rat Clust. ",string(i)))
    end
end