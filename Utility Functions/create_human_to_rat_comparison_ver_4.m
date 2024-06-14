function create_human_to_rat_comparison_ver_4(name_of_rat_file,human_cluster_table,directory_of_rat_file,b_dist_plots_dir,colors,human_stats_map,rat_stats_map,date_created,version_name)
% home_dir = cd(directory_of_human_file);
% % human_cluster_table = readtable(name_of_human_file);
% cd(home_dir)
home_dir = cd(directory_of_rat_file);
rat_table = readtable(name_of_rat_file);
cd(home_dir)

dir_with_b_dist_plots_abs = create_a_file_if_it_doesnt_exist_and_ret_abs_path(b_dist_plots_dir);

rat_clusters = unique(rat_table.cluster_number);
human_clusters = unique(human_cluster_table.cluster_number);
cell_array_of_b_dist = cell(length(human_clusters),length(rat_clusters));

% this loop will calculate the bhaat distance between human and rat clusters
for i=1:length(rat_clusters)
    current_rat_color = colors(1,:);
    rat_current_cluster_info = rat_table(rat_table.cluster_number==i,:);
    array_of_current_cluster_data_for_rat = [rat_current_cluster_info.clusterX,rat_current_cluster_info.clusterY,rat_current_cluster_info.clusterZ];

    
    array_of_cluster_labels_for_rat = logical(zeros(size(array_of_current_cluster_data_for_rat,1),1));

    for j=1:length(human_clusters)
        current_human_color = colors(2,:);
        human_current_cluster_info = human_cluster_table(human_cluster_table.cluster_number==j,:);
        array_of_current_cluster_data_for_human = [human_current_cluster_info.clusterX,human_current_cluster_info.clusterY,human_current_cluster_info.clusterZ];
        array_of_cluster_labels_for_human =logical(ones(size(array_of_current_cluster_data_for_human,1),1));
        cell_array_of_b_dist{j,i} = bhattacharyyaDistance([array_of_current_cluster_data_for_rat;array_of_current_cluster_data_for_human],[array_of_cluster_labels_for_rat;array_of_cluster_labels_for_human]);
    end

end

figure('units','normalized','outerposition',[0 0 1 1])
% subplot(1,2,1);

legend_string_for_bar_chart = [];
hs = [];
to_be_x_for_bar_chart = cell(1,length(rat_clusters));
legend_strings_for_3d_plot = [];

for i=1:length(rat_clusters)
    current_rat_color = colors(1,:);
    rat_current_cluster_info = rat_table(rat_table.cluster_number==rat_clusters(i),:);
    array_of_current_cluster_data_for_rat = [rat_current_cluster_info.clusterX,rat_current_cluster_info.clusterY,rat_current_cluster_info.clusterZ];
    h =scatter3(array_of_current_cluster_data_for_rat(:,1),array_of_current_cluster_data_for_rat(:,2),array_of_current_cluster_data_for_rat(:,3),'o','MarkerEdgeColor',current_rat_color,'MarkerFaceColor',current_rat_color);
    hs = [hs,h];
    legend_strings_for_3d_plot = [legend_strings_for_3d_plot,strcat("Rat Cluster ",string(rat_clusters(i)))];
    to_be_x_for_bar_chart{i} =char(strcat("Rat Cluster ",string(rat_clusters(i))));
    hold on;
    text(mean(array_of_current_cluster_data_for_rat(:,1)),...
        mean(array_of_current_cluster_data_for_rat(:,2)),...
        mean(array_of_current_cluster_data_for_rat(:,3))+4,...
        strcat("rat ",string(i)),'FontWeight','bold','Color',current_rat_color);
end




for j=1:length(human_clusters)
    current_human_color = colors(2,:);
    human_current_cluster_info = human_cluster_table(human_cluster_table.cluster_number==human_clusters(j),:);
    array_of_current_cluster_data_for_human = [human_current_cluster_info.clusterX,human_current_cluster_info.clusterY,human_current_cluster_info.clusterZ];
    h = scatter3(array_of_current_cluster_data_for_human(:,1),array_of_current_cluster_data_for_human(:,2),array_of_current_cluster_data_for_human(:,3),'o','MarkerEdgeColor',current_human_color,'MarkerFaceColor',current_human_color);
    hs = [hs,h];
    legend_strings_for_3d_plot = [legend_strings_for_3d_plot,strcat("Human Cluster ",string(human_clusters(j)))];
    legend_string_for_bar_chart = [legend_string_for_bar_chart,strcat("Hu. Cl. ",string(human_clusters(j)))];
    % plot3(human_centers(j,1),human_centers(j,2),human_centers(j,3),"*k",MarkerSize=15,LineWidth=3);
    text(mean(array_of_current_cluster_data_for_human(:,1)),...
        mean(array_of_current_cluster_data_for_human(:,2)),...
        mean(array_of_current_cluster_data_for_human(:,3))+4,...
        strcat("human ",string(j)),'FontWeight','bold','Color',current_human_color);
end
xlabel("log(abs(max))");
ylabel("log(abs(shift))");
zlabel("log(abs(slope))");
legend(hs,legend_strings_for_3d_plot);
% view(gca,[-169.5194 277.1734 36.9544]);
title([sprintf("Human Data Approach Avoid: # of subjects:%i # of sessions:%i",human_stats_map("approach_avoid Number Of Unique Subjects"),human_stats_map("approach_avoid Number of Data Points")), ...
        sprintf("Rat Data: # of subjects:%i # of sessions: %i",rat_stats_map('Number Of Unique Subjects'),rat_stats_map('Number of Data Points')), ...
         strcat("Date Created:",date_created), ...
         "created by create\_human\_to\_rat\_comparison\_ver\_4", ...
         version_name]);
set(gcf,'renderer','Painters');
saveas(gcf,strcat(dir_with_b_dist_plots_abs,"\","Human to rat 3d all clusters together ",version_name),"fig");


% subplot(1,2,2)
figure('units','normalized','outerposition',[0 0 1 1])
array_of_mean_of_bhaat_dist = zeros(size(cell_array_of_b_dist,1),size(cell_array_of_b_dist,2));
for i=1:size(cell_array_of_b_dist,1)
    for j=1:size(cell_array_of_b_dist,2)
        array_of_mean_of_bhaat_dist(i,j)=mean(cell_array_of_b_dist{i,j});

    end
end
x = categorical(to_be_x_for_bar_chart);
x = reordercats(x,to_be_x_for_bar_chart);
bar(x,array_of_mean_of_bhaat_dist.');
legend(legend_string_for_bar_chart)
set(gcf,'renderer','Painters');
saveas(gcf,strcat(dir_with_b_dist_plots_abs,"\","Human to rat 3d all clusters together and bhaat dist bar plot ", version_name),"fig");

title([sprintf("Human Data Approach Avoid: # of subjects:%i # of sessions:%i",human_stats_map("approach_avoid Number Of Unique Subjects"),human_stats_map("approach_avoid Number of Data Points")), ...
        sprintf("Rat Data: # of subjects:%i # of sessions: %i",rat_stats_map('Number Of Unique Subjects'),rat_stats_map('Number of Data Points')), ...
         strcat("Date Created:",date_created), ...
         "created by create\_human\_to\_rat\_comparison\_ver\_4", ...
         version_name]);
end