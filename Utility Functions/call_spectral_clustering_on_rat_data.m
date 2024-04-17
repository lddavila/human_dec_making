function call_spectral_clustering_on_rat_data(table_of_data,directory_where_cluster_table_should_be_saved,epsilon,given_number_of_clusters,colors)


directory_where_cluster_table_should_be_saved = create_a_file_if_it_doesnt_exist_and_ret_abs_path(directory_where_cluster_table_should_be_saved);


xVsYVsZ = log(abs([table_of_data.A,table_of_data.B,table_of_data.C]));
labels = [table_of_data.D,table_of_data.D];

[index,V,D] = spectralcluster(xVsYVsZ,given_number_of_clusters);
unique_indexes = unique(index);

figure;
for j=1:length(unique_indexes)
    current_color = colors(j,:);
    group_n = xVsYVsZ(index==unique_indexes(j),:);

    scatter_object = scatter3(group_n(:,1),group_n(:,2),group_n(:,3),[],current_color);
    dtRows = [dataTipTextRow("Data Label",strrep(labels(index==unique_indexes(j),1),"_","\_")),...
        dataTipTextRow("Cluster",repelem(unique_indexes(j),size(group_n,1),1))];

    scatter_object.DataTipTemplate.DataTipRows(end+1:end+2) = dtRows;
    three_d_cluster_table = getClusterTable3dWithoutExperiment(xVsYVsZ,labels,index,unique_indexes(j));
    writetable(three_d_cluster_table,strcat(directory_where_cluster_table_should_be_saved,"\rat_spectral_clustering_table.xlsx"),'WriteMode','append')
    hold on;
end

% validity = dbcv(xVsYVsZ,index);
legend(string(unique_indexes));
ylabel("log(abs(Shift))");
xlabel("log(Abs(Max))");
zlabel("log(abs(slope))");
title("spectral clustering")
subtitle("Created by call_spectral_clustering_combine_all_human_data")
% subtitle(strcat(task," DBCV:",string(validity)," Created by call_spectral_clustering_combine_all_human_data"))
hold off;

end