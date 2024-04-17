function plot_individual_clusters(cluster_tables_dir,axis_object,subplot_beginning)
    home_dir =cd(cluster_tables_dir);
    cluster_table_dir_abs = cd(home_dir);

    human_tables = strtrim(string(ls((strcat(cluster_table_dir_abs,"\*human*.xlsx")))));
    rat_tables = strtrim(string(ls((strcat(cluster_table_dir_abs,"\*rat*.xlsx")))));




    rat_centers = [-9.19224 -0.160122 -5.94521; 0.0725258 9.26768 5.38323;-0.0750791 2.44643 4.20085; 7.26215 9.12042 2.84782];
    human_centers = [-7.616854999999999 0.774569569125500 -7.101532000000001;4.16898 11.8951 2.47445;4.06153 3.09722 0.625457;11.3803 12.5503 0.188948];
    for i=1:length(human_tables)
        current_human_table = readtable(strcat(cluster_table_dir_abs,"\",human_tables(i)));
        list_of_human_clusters = unique(current_human_table.cluster_number);
        current_rat_table = readtable(strcat(cluster_table_dir_abs,"\",rat_tables(i)));
        for k=1:length(list_of_human_clusters)
            table_for_only_current_human_clusters = current_human_table(current_human_table.cluster_number==list_of_human_clusters(k),:);
            table_for_only_current_rat_clusters = current_rat_table(current_rat_table.cluster_number==list_of_human_clusters(k),:);
            axis_object = subplot(2,4,subplot_beginning);
            subplot_beginning=subplot_beginning+1;

            plot3(axis_object,table_for_only_current_rat_clusters.clusterX,table_for_only_current_rat_clusters.clusterY,table_for_only_current_rat_clusters.clusterZ,'o');%for rat
            hold on;
            plot3(axis_object,table_for_only_current_human_clusters.clusterX,table_for_only_current_human_clusters.clusterY,table_for_only_current_human_clusters.clusterZ,'x');%for human

            title(strcat("Cluster ",string(k)," For Rat And Human"));
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
            
            
        end
    end
end