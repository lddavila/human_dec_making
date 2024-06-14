function create3d_cluster_plot(name_of_dir_with_file,name_of_file,colors,type_of_data,the_title,x,y,z,dir_to_save_figure_to,rat_stats_map,date_created,version_name)
home_dir = cd(name_of_dir_with_file);
abs_fp = pwd;
cd(home_dir);
table_of_data = readtable(strcat(abs_fp,"\",name_of_file));
unique_list_of_clusters = unique(table_of_data.cluster_number);
legend_strings = [];
figure('units','normalized','outerposition',[0 0 1 1])
for i=1:length(unique_list_of_clusters)
    current_color = colors(i,:);
    only_single_cluster_data = table_of_data(table_of_data.cluster_number == unique_list_of_clusters(i),:);
    scatter3(only_single_cluster_data.clusterX,only_single_cluster_data.clusterY,only_single_cluster_data.clusterZ,'o','MarkerEdgeColor',current_color,'MarkerFaceColor',current_color);
    hold on;
    legend_strings = [legend_strings,strcat(type_of_data," Cluster ",string(unique_list_of_clusters(i)))];
end
legend(legend_strings)
title([the_title,...
    strcat("Number Of Unique Subjects:",string(rat_stats_map("Number Of Unique Subjects"))), ...
    strcat("Number of Total Sessions:",string(rat_stats_map("Number of Data Points"))), ...
    strcat("date created:",date_created), ...
    "Created by create3d\_cluster\_plot.m", ...
    version_name])
xlabel(x)
ylabel(y)
zlabel(z)
abs_dir = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figure_to);
set(gcf,'renderer','Painters');
saveas(gcf,strcat(abs_dir,"\",the_title," ",version_name,".fig"),"fig")

end