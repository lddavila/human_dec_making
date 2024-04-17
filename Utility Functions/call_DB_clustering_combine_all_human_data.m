function call_DB_clustering_combine_all_human_data(table_of_dir,directory_where_cluster_table_should_be_saved,epsilon,minpts)
table_of_data = cell2table(cell(0,4),"VariableNames",["A","B","C","D"]);
for i=1:height(table_of_dir)
    table_of_data = [table_of_data;getTable(table_of_dir{i,2})];
end

task = "All_Human_data";
xVsYVsZ = log(abs([table_of_data.A,table_of_data.B,table_of_data.C]));
labels = [table_of_data.D,table_of_data.D];


index= dbscan(xVsYVsZ,clusterDBSCAN.estimateEpsilon(xVsYVsZ,6,15),minpts,'Distance','squaredeuclidean');
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
ylabel("log(abs(Shift))");
xlabel("log(Abs(Max))");
zlabel("log(abs(slope))");
title("DBSCAN using Squared Euclidean Distance Metric")
subtitle(strcat(task," DBCV:",string(validity)," Created by call_DB_clustering_combine_all_human_data"))
hold off;

end