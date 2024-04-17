function [] = call_FCM_for_each_row_of_data(table_of_dir,centers,directory_where_cluster_table_should_be_saved)
cluster_table_dir_abs = create_a_file_if_it_doesnt_exist_and_ret_abs_path(directory_where_cluster_table_should_be_saved);
for i=1:height(table_of_dir)
    table_of_data_for_current_task = getTable(table_of_dir{i,2});
    xVsYVsZ = log(abs([table_of_data_for_current_task.A,table_of_data_for_current_task.B,table_of_data_for_current_task.C]));
    labels = [table_of_data_for_current_task.D,table_of_data_for_current_task.D];
    xAxis = "Log(Abs(Max))";
    yAxis = "log(abs(Shift))";
    zAxis = "log(abs(slope))";
    experiment = table_of_dir{i,1};
    called_by = "call_FCM_for_each_row_of_data";
    if isempty(centers)
        run_3d_fcm_analysis(xVsYVsZ,labels,xAxis,yAxis,zAxis,experiment,called_by,[],cluster_table_dir_abs)
    else
        run_3d_fcm_analysis(xVsYVsZ,labels,xAxis,yAxis,zAxis,experiment,called_by,centers{i},cluster_table_dir_abs)
    end
end
end