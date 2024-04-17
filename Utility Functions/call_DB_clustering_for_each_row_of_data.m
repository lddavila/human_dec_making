function call_DB_clustering_for_each_row_of_data(table_of_dir,directory_where_cluster_table_should_be_saved,epsilon,minpts)
for i=1:height(table_of_dir)
    task = table_of_dir{i,1};
    table_of_data_for_current_task = getTable(table_of_dir{i,2});
    xVsYVsZ = log(abs([table_of_data_for_current_task.A,table_of_data_for_current_task.B,table_of_data_for_current_task.C]));
    labels = [table_of_data_for_current_task.D,table_of_data_for_current_task.D];
    xAxis = "Log(Abs(Max))";
    yAxis = "log(abs(Shift))";
    zAxis = "log(abs(slope))";
    experiment = table_of_dir{i,1};
    called_by = "call_FCM_for_each_row_of_data";
    index= dbscan(xVsYVsZ,epsilon{i},minpts{i},'Distance','squaredeuclidean');
    unique_indexes = unique(index);

    figure;
    for j=1:length(unique_indexes)
        group_n = xVsYVsZ(index==unique_indexes(j),:);
        if unique_indexes(j) ~=-1
            scatter3(group_n(:,1),group_n(:,2),group_n(:,3));
        else
            scatter3(group_n(:,1),group_n(:,2),group_n(:,3),'*')
        end
        hold on;
    end
    validity = dbcv(xVsYVsZ,index);
    legend(string(unique_indexes));
    ylabel(yAxis);
    xlabel(xAxis);
    zlabel(zAxis);
    title("DBSCAN using Squared Euclidean Distance Metric")
    subtitle(strcat(task," DBCV:",string(validity)))
    hold off;
end

end