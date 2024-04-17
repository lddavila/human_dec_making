function try_different_validation_methods(table_of_dir,directory_where_cluster_table_should_be_saved,epsilon,given_number_of_clusters,colors)
table_of_data = cell2table(cell(0,5),"VariableNames",["A","B","C","D","E"]);
directory_where_cluster_table_should_be_saved = create_a_file_if_it_doesnt_exist_and_ret_abs_path(directory_where_cluster_table_should_be_saved);
for i=1:height(table_of_dir)
    current_table = getTable(table_of_dir{i,2});
    E = repelem(table_of_dir{i,1},height(current_table),1);
    E = table(E);
    current_table = [current_table,E];
    table_of_data = [table_of_data;current_table];
end
different_methods = {'kmeans','linkage','gmdistribution'};
different_criterion = {'CalinskiHarabasz','DaviesBouldin','gap','silhouette'};


task = "All_Human_data";
xVsYVsZ = log(abs([table_of_data.A,table_of_data.B,table_of_data.C]));
labels = [table_of_data.D,table_of_data.D];

rng('default');
for i=1:length(different_methods)
    for j=1:length(different_criterion)
        disp(strcat(different_methods{i},different_criterion{j}))
        eva = evalclusters(xVsYVsZ,different_methods{i},different_criterion{j},'KList',1:10);
        display(eva)
    end
end


end