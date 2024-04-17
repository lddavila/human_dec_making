function create3d_cluster_plot_for_human(human_data_table,colors,type_of_data,the_title,x,y,z,dir_to_save_figure_to,human_stats_map,date_created)


unique_list_of_clusters = unique(human_data_table.cluster_number);
legend_strings = [];
figure('units','normalized','outerposition',[0 0 1 1])
for i=1:length(unique_list_of_clusters)
    current_color = colors(i,:);
    only_single_cluster_data = human_data_table(human_data_table.cluster_number == unique_list_of_clusters(i),:);
    scatter3(only_single_cluster_data.clusterX,only_single_cluster_data.clusterY,only_single_cluster_data.clusterZ,'o','MarkerEdgeColor',current_color);
    hold on;
    legend_strings = [legend_strings,strcat(type_of_data," Cluster ",string(unique_list_of_clusters(i)))];
end
legend(legend_strings)
title([the_title,...
    strcat("Number Of Unique Subjects:",string(human_stats_map("Number of Unique Subjects in all human data"))), ...
    strcat("Number of Sessions:",string(height(human_data_table))), ...
    strcat("Number Of approach avoid Sessions:",string(human_stats_map(strcat("approach_avoid"," Number of Data Points")))," Number of Subjects:",string(human_stats_map('approach_avoid Number Of Unique Subjects'))), ...
    strcat("Number Of moral Sessions:",      string(human_stats_map(strcat("moral"," Number of Data Points")))," Number of Subjects:",string(human_stats_map('moral Number Of Unique Subjects'))), ...
    strcat("Number Of probability Sessions:",      string(human_stats_map(strcat("probability"," Number of Data Points")))," Number of Subjects:",string(human_stats_map('probability Number Of Unique Subjects'))), ...
    strcat("Number Of social Sessions:",      string(human_stats_map(strcat("social"," Number of Data Points")))," Number of Subjects:",string(human_stats_map('social Number Of Unique Subjects'))), ...
    strcat("Date Created:",string(datetime("today",'Format','MM-d-yyyy'))), ...
    "Created By create3d\_cluster\_plot\_for\_human.m"])
xlabel(x)
ylabel(y)
zlabel(z)
abs_dir = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figure_to);
set(gcf,'renderer','Painters');
saveas(gcf,strcat(abs_dir,"\",the_title,".fig"),"fig")

end