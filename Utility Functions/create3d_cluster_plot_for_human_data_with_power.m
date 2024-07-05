function create3d_cluster_plot_for_human_data_with_power(human_data_table,colors,type_of_data,the_title,dir_to_save_figure_to,human_stats_map,version_name,thresholds,unique_clusters,p_from_chi_squared,power_string)


unique_list_of_clusters = unique(human_data_table.cluster_number);
legend_strings = [];
figure('units','normalized','outerposition',[0 0 1 1])
for i=1:length(unique_list_of_clusters)
    current_color = colors(unique_list_of_clusters(i),:);
    only_single_cluster_data = human_data_table(human_data_table.cluster_number == unique_list_of_clusters(i),:);
    scatter3(only_single_cluster_data.clusterX,only_single_cluster_data.clusterY,only_single_cluster_data.clusterZ,'o','MarkerEdgeColor',current_color,'MarkerFaceColor',current_color);
    hold on;
    legend_strings = [legend_strings,strcat(type_of_data," Cluster ",string(unique_list_of_clusters(i)))];
end
cluster_counts = get_cluster_counts(human_data_table,unique_clusters);
cluster_proportions = cluster_counts ./ size(human_data_table,1);
legend(legend_strings)


strings_to_add_to_title = [];
all_keys = string(keys(human_stats_map).');
for i=1:2:length(keys(human_stats_map).')
    current_key = all_keys(i);
    second_key = all_keys(i+1);
    strings_to_add_to_title = [strings_to_add_to_title,strcat(current_key,":",string(human_stats_map(current_key))," ", second_key, ":",string(human_stats_map(second_key)))];
end
title([the_title,...
    strings_to_add_to_title,...
    thresholds,...
    strcat("Date Created:",string(datetime("today",'Format','MM-d-yyyy'))), ...
    strcat("Cluster Proportions:",strjoin(string(round(cluster_proportions,2)))), ...
    strcat("P Value From Chi Squared:",string(p_from_chi_squared)),...
    "Created By create3d\_cluster\_plot\_for\_human\_data\_with\_power.m", ...
    version_name, ...
    power_string])
xlabel("log(abs(max))")
ylabel("log(abs(shift))")
zlabel("log(abs(slope))")
abs_dir = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figure_to);
set(gcf,'renderer','Painters');
saveas(gcf,strcat(abs_dir,"\",the_title," ",version_name,".fig"),"fig")
saveas(gcf,strcat(abs_dir,"\",the_title," ",version_name,".svg"),"svg")

end