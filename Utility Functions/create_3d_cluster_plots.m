function [current_axis,array_of_scatter_objects] =create_3d_cluster_plots(table_of_directories,dir_where_3d_cluster_tables_should_be_stored,human_or_rat,experiment_or_story,axis_object)
if ~exist(dir_where_3d_cluster_tables_should_be_stored,"dir")
    mkdir(dir_where_3d_cluster_tables_should_be_stored);
    home_dir=cd(dir_where_3d_cluster_tables_should_be_stored);
    dir_of_3d_cluster_tables_abs = cd(home_dir);
else
    home_dir = cd(dir_where_3d_cluster_tables_should_be_stored);
    dir_of_3d_cluster_tables_abs = cd(home_dir);
end
for i=1:height(table_of_directories)
    current_experiment=table_of_directories{i,1};
    current_data_location = table_of_directories{i,2};
    current_sigmoid_data = getTable(current_data_location);
    max_shift_slope = log(abs([current_sigmoid_data.A,current_sigmoid_data.B,current_sigmoid_data.C]));
    labels = [current_sigmoid_data.D,current_sigmoid_data.D];
    

    if strcmpi("rat",human_or_rat)
        options = fcmOptions(NumClusters=4,Verbose=false,ClusterCenters=[-9.19224 -0.160122 -5.94521; 0.0725258 9.26768 5.38323;-0.0750791 2.44643 4.20085; 7.26215 9.12042 2.84782]);
        [centers,U,~,info] = fcm(max_shift_slope,options);
        number_of_clusters = info.OptimalNumClusters;
        maxU=max(U);
    else
        options = fcmOptions(NumClusters=4,Verbose=false,ClusterCenters=[-7.616854999999999   0.774569569125500  -7.101532000000001;4.16898 11.8951 2.47445;4.06153 3.09722 0.625457;11.3803 12.5503 0.188948]);
        [centers,U,~,info] = fcm(max_shift_slope,options);
        number_of_clusters = info.OptimalNumClusters;
        maxU=max(U);
    end

    % figure;
    array_of_scatter_objects = cell(1,number_of_clusters);
    for j=1:number_of_clusters
        indexes = find(U(j,:) == maxU);
        hold on;
        if strcmpi("rat",human_or_rat)
            current_scatter_object = scatter3(axis_object,max_shift_slope(indexes,1),max_shift_slope(indexes,2),max_shift_slope(indexes,3),'o');
            array_of_scatter_objects{j} = current_scatter_object;
            % current_scatter_object = scatter3(axis_object,max_shift_slope(indexes,1),max_shift_slope(indexes,2),max_shift_slope(indexes,3),'o','MarkerEdgeColor',[0 .75 .75]);
        else
            current_scatter_object = scatter3(axis_object,max_shift_slope(indexes,1),max_shift_slope(indexes,2),max_shift_slope(indexes,3),'x');
            array_of_scatter_objects{j} = current_scatter_object;
            % current_scatter_object = scatter3(axis_object,max_shift_slope(indexes,1),max_shift_slope(indexes,2),max_shift_slope(indexes,3),'x','MarkerEdgeColor','b');
        end

        dtRow = [dataTipTextRow("Label",labels(indexes,1))];
        current_scatter_object.DataTipTemplate.DataTipRows(end+1) = dtRow;


        cluster_table = getClusterTable3d(max_shift_slope,labels,indexes,j);
        writetable(cluster_table,strcat(dir_of_3d_cluster_tables_abs,"\",human_or_rat," ",experiment_or_story," M.xlsx"),"WriteMode","append")
        if strcmpi("rat",human_or_rat)
            current_plot_object = plot3(centers(j,1),centers(j,2),centers(j,3), ...
                "xk",MarkerSize=30,LineWidth=3);
        else
            current_plot_object = plot3(centers(j,1),centers(j,2),centers(j,3), ...
                "*k",MarkerSize=30,LineWidth=3);
        end
        dtRow = [dataTipTextRow("Cluster Number",j)];
        current_plot_object.DataTipTemplate.DataTipRows(end+1)=dtRow;
    end
    



    xlabel("Sigmoid Max")
    ylabel("Sigmoid Shift")
    zlabel("Sigmoid Slope")
    title(strcat(strrep(current_experiment,"_","\_")," ",human_or_rat," ",experiment_or_story));
    subtitle("Created by create\_3d\_cluster\_plots.m")
    view([-11 63])
    current_axis = gca;

end
end