function [current_axis,array_of_scatter_objects] =create_3d_cluster_plots_provide_centers(table_of_directories, ...
    dir_where_3d_cluster_tables_should_be_stored, ...
    human_or_rat,experiment_or_story,axis_object,centers,colors,number_of_clusters)


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


    options = fcmOptions(NumClusters=number_of_clusters,Verbose=false,ClusterCenters=centers);
    [~,U,~,~] = fcm(max_shift_slope,options);
    maxU=max(U);

    % figure;
    array_of_scatter_objects = cell(1,number_of_clusters);
    for j=1:number_of_clusters
        indexes = find(U(j,:) == maxU);
        hold on;
        current_color = colors{j};
        if strcmpi("rat",human_or_rat)
            current_scatter_object = scatter3(axis_object,max_shift_slope(indexes,1),max_shift_slope(indexes,2),max_shift_slope(indexes,3),'o','MarkerEdgeColor',current_color);
            array_of_scatter_objects{j} = current_scatter_object;
            % current_scatter_object = scatter3(axis_object,max_shift_slope(indexes,1),max_shift_slope(indexes,2),max_shift_slope(indexes,3),'o','MarkerEdgeColor',[0 .75 .75]);
        else
            current_scatter_object = scatter3(axis_object,max_shift_slope(indexes,1),max_shift_slope(indexes,2),max_shift_slope(indexes,3),'x','MarkerEdgeColor',current_color);
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
    % hold off;

end
end