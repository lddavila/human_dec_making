function create_human_to_rat_comparison_ver_3(name_of_rat_file,human_cluster_table,directory_of_rat_file,b_dist_plots_dir,colors,human_stats_map,rat_stats_map,date_created,version_name)
% home_dir = cd(directory_of_human_file);
% % human_cluster_table = readtable(name_of_human_file);
% cd(home_dir)
home_dir = cd(directory_of_rat_file);
rat_table = readtable(name_of_rat_file);
cd(home_dir)

dir_with_b_dist_plots_abs = create_a_file_if_it_doesnt_exist_and_ret_abs_path(b_dist_plots_dir);

rat_clusters = unique(rat_table.cluster_number);
human_clusters = unique(human_cluster_table.cluster_number);

for i=1:length(rat_clusters)
    hs = [];
    legend_strings = [];
    current_rat_color = colors(i,:);
    rat_current_cluster_info = rat_table(rat_table.cluster_number==i,:);
    array_of_current_cluster_data_for_rat = [rat_current_cluster_info.clusterX,rat_current_cluster_info.clusterY,rat_current_cluster_info.clusterZ];

    figure('units','normalized','outerposition',[0 0 1 1])
    % subplot(1,2,1);
    h = scatter3(array_of_current_cluster_data_for_rat(:,1),array_of_current_cluster_data_for_rat(:,2),array_of_current_cluster_data_for_rat(:,3),'o','MarkerEdgeColor',current_rat_color,'MarkerFaceColor',current_rat_color);
    legend_strings = [legend_strings,strcat("Rat Cluster ",string(i))];
    hs = [hs,h];
    hold on;
    text(mean(array_of_current_cluster_data_for_rat(:,1)),...
        mean(array_of_current_cluster_data_for_rat(:,2)),...
        mean(array_of_current_cluster_data_for_rat(:,3))+4,...
        strcat("rat ",string(i)),'FontWeight','bold','Color',current_rat_color);
    % plot3(rat_centers(i,1),rat_centers(i,2),rat_centers(i,3),"xk",MarkerSize=15,LineWidth=3);
    cell_array_of_b_dist = cell(length(human_clusters),1);
    array_of_cluster_labels_for_rat = logical(zeros(size(array_of_current_cluster_data_for_rat,1),1));
    
    to_be_x = cell(1,length(human_clusters));
    for j=1:length(human_clusters)
        current_human_color = colors(7,:);
        human_current_cluster_info = human_cluster_table(human_cluster_table.cluster_number==j,:);
        array_of_current_cluster_data_for_human = [human_current_cluster_info.clusterX,human_current_cluster_info.clusterY,human_current_cluster_info.clusterZ];
        h = scatter3(array_of_current_cluster_data_for_human(:,1),array_of_current_cluster_data_for_human(:,2),array_of_current_cluster_data_for_human(:,3),'o','MarkerEdgeColor',current_human_color,'MarkerFaceColor',current_human_color);
        hs = [hs,h];
        legend_strings = [legend_strings,strcat("Human Cluster ",string(j))];
        % plot3(human_centers(j,1),human_centers(j,2),human_centers(j,3),"*k",MarkerSize=15,LineWidth=3);
        array_of_cluster_labels_for_human =logical(ones(size(array_of_current_cluster_data_for_human,1),1));
        cell_array_of_b_dist{j} = bhattacharyyaDistance([array_of_current_cluster_data_for_rat;array_of_current_cluster_data_for_human],[array_of_cluster_labels_for_rat;array_of_cluster_labels_for_human]);
            text(mean(array_of_current_cluster_data_for_human(:,1)),...
        mean(array_of_current_cluster_data_for_human(:,2)),...
        mean(array_of_current_cluster_data_for_human(:,3))+4,...
        strcat("human ",string(j)),'FontWeight','bold','Color',current_human_color);
        to_be_x{j} = char(string(human_clusters(j)));
    end
    xlabel("log(abs(max))");
    ylabel("log(abs(shift))");
    zlabel("log(abs(slope))");

    X = categorical(to_be_x);
    X = reordercats(X,to_be_x);
    legend(hs,legend_strings,'Location','best')
    view(gca,[-62.7563 ,-250.1988, 184.7120])
    % gca.CameraPosition = [-62.7563 -250.1988 184.7120];
    % gca.CameraViewAngle = 10.5970;
    saveas(gcf,strcat(dir_with_b_dist_plots_abs,"\Rat Cluster ",string(i)," Compared To all other human Clusters ",version_name,".fig"))
    % close(gcf);
    set(gcf,'renderer','Painters');
    title([strcat("Rat Cluster ",string(i)," Compared to Human Clusters"),sprintf("Human Data Approach Avoid: # of subjects:%i # of sessions:%i",human_stats_map("approach_avoid Number Of Unique Subjects"), ...
        human_stats_map("approach_avoid Number of Data Points")), sprintf("Rat Data: # of subjects:%i # of sessions: %i", ...
        rat_stats_map('Number Of Unique Subjects'), rat_stats_map('Number of Data Points')), ...
        strcat("Date Created:",string(datetime("today",'Format','MM-d-yyyy'))), ...
        "Created by create\_human\_to\_rat\_comparsion\_ver\_3.m", ...
        version_name]);
    set(gcf,'renderer','Painters');

    % subplot(1,2,2)
    
    figure('units','normalized','outerposition',[0 0 1 1])
   
    bar(X,mean(cell2mat(cell_array_of_b_dist),2)); %get the mean of each bhaat distance per row
    % legend("log(abs(Max))","log(abs(Shift))","log(abs(Slope))")
    ylabel("Mean of Bhattacharyya Distance To Human Clusters")
    xlabel("Human Cluster Number")
    % ylim([0,60])
    title([strcat("Mean Bhattacharyya Distance From Rat Cluster ", string(i), " To all other human Clusters"),sprintf("Human Data Approach Avoid: # of subjects:%i # of sessions:%i",human_stats_map("approach_avoid Number Of Unique Subjects"), ...
        human_stats_map("approach_avoid Number of Data Points")), sprintf("Rat Data: # of subjects:%i # of sessions: %i", ...
        rat_stats_map('Number Of Unique Subjects'), rat_stats_map('Number of Data Points')), ...
        strcat("Date Created:",string(datetime("today",'Format','MM-d-yyyy'))), ...
        "Created by create\_human\_to\_rat\_comparsion\_ver\_3.m", ...
        version_name])
    saveas(gcf,strcat(dir_with_b_dist_plots_abs,"\Bhattacharyya Distance From Rat Cluster ", string(i), " To all other human Clusters ",version_name,".fig"))
    hold off;
    set(gcf,'renderer','Painters');
    % close(gcf)



end
end