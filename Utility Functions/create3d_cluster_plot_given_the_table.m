function create3d_cluster_plot_given_the_table(table_of_data,colors,type_of_data,the_title,x,y,z)
unique_list_of_clusters = unique(table_of_data.cluster_number);
legend_strings = [];
for i=1:length(unique_list_of_clusters)
    current_color = colors(i,:);
    only_single_cluster_data = table_of_data(table_of_data.cluster_number == unique_list_of_clusters(i),:);
    scatter3(only_single_cluster_data.clusterX,only_single_cluster_data.clusterY,only_single_cluster_data.clusterZ,'o','MarkerEdgeColor',current_color);
    hold on;
    legend_strings = [legend_strings,strcat(type_of_data,string(i))];
end
legend(legend_strings)
% title(the_title)
xlabel(x)
ylabel(y)
zlabel(z)
% abs_dir = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figure_to);
set(gcf,'renderer','Painters');
% saveas(gcf,strcat(abs_dir,"\",the_title,".fig"),"fig")

end