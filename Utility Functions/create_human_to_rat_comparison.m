function create_human_to_rat_comparison(name_of_rat_file,name_of_human_file,directory_of_human_file,directory_of_rat_file,b_dist_plots_dir)
home_dir = cd(directory_of_human_file);
human_cluster_table = readtable(name_of_human_file);
cd(home_dir)
cd(directory_of_rat_file);
rat_table = readtable(name_of_rat_file);
cd(home_dir)

dir_with_b_dist_plots_abs = create_a_file_if_it_doesnt_exist_and_ret_abs_path(b_dist_plots_dir);

rat_centers = [-9.19223 -0.160124 -5.94521; 0.0725309 9.26771 5.38323; -0.0750793 2.44644 4.20085; 7.26216 9.12042 2.84782 ];

human_centers = [-9.58304 9.75048e-08 -14.0991;
    -6.3448 1.54914 0.437736;
    4.16898 11.8951 2.47445;
    4.06153 3.09722 0.625457;
    11.3803 12.5503 0.188948];

human_colors ={[0,0.1,0.7],[0,0.1,0.7],[0.7,0,0],[0.5 0 0.5],[0 0 0]};
rat_colors = {[0 0 1],[1 0 0],[0.7 0 0.7],[.7 .7 .7]};


rat_clusters = unique(rat_table.cluster_number);
human_clusters = unique(human_cluster_table.cluster_number);

for i=1:length(rat_clusters)
    rat_current_cluster_info = rat_table(rat_table.cluster_number==i,:);
    array_of_current_cluster_data_for_rat = [rat_current_cluster_info.clusterX,rat_current_cluster_info.clusterY,rat_current_cluster_info.clusterZ];

     figure('units','normalized','outerposition',[0 0 1 1])
    subplot(1,2,1);

    scatter3(array_of_current_cluster_data_for_rat(:,1),array_of_current_cluster_data_for_rat(:,2),array_of_current_cluster_data_for_rat(:,3),'o','MarkerEdgeColor',rat_colors{i});
    hold on;
    % plot3(rat_centers(i,1),rat_centers(i,2),rat_centers(i,3),"xk",MarkerSize=15,LineWidth=3);
    cell_array_of_b_dist = cell(length(human_clusters),1);
    array_of_cluster_labels_for_rat = logical(zeros(size(array_of_current_cluster_data_for_rat,1),1));

    for j=1:length(human_clusters)
        human_current_cluster_info = human_cluster_table(human_cluster_table.cluster_number==j,:);
        array_of_current_cluster_data_for_human = [human_current_cluster_info.clusterX,human_current_cluster_info.clusterY,human_current_cluster_info.clusterZ];
        scatter3(array_of_current_cluster_data_for_human(:,1),array_of_current_cluster_data_for_human(:,2),array_of_current_cluster_data_for_human(:,3),'x','MarkerEdgeColor',human_colors{j});
        % plot3(human_centers(j,1),human_centers(j,2),human_centers(j,3),"*k",MarkerSize=15,LineWidth=3);
        array_of_cluster_labels_for_human =logical(ones(size(array_of_current_cluster_data_for_human,1),1));
        cell_array_of_b_dist{j} = bhattacharyyaDistance([array_of_current_cluster_data_for_rat;array_of_current_cluster_data_for_human],[array_of_cluster_labels_for_rat;array_of_cluster_labels_for_human]);
    end

    X = categorical({'1','2','3','4','5'});
    X = reordercats(X,{'1','2','3','4','5'});
    title(strcat("Rat Cluster ",string(i)," Compared to Human Clusters"))
    % subtitle("Created by create\_fifth\_plot.m")
    legend(strcat("Rat Cluster ",string(i)),"","Human Cluster 1","", "Human Cluster 2","","Human Cluster 3","","Human Cluster 4","", "Human Cluster 5","",'Location','best')
    
    % saveas(gcf,strcat(dir_with_b_dist_plots_abs,"\Rat Cluster ",string(i)," Compared To all other human Clusters.fig"))
    % close(gcf);

    subplot(1,2,2)
   
    bar(X,cell2mat(cell_array_of_b_dist));
    legend("log(abs(Max))","log(abs(Shift))","log(abs(Slope))")
    ylabel("Bhattacharyya Distance To Human Clusters")
    xlabel("Human Cluster Number")
    ylim([0,60])
    title(strcat("Bhattacharyya Distance From Rat Cluster ", string(i), " To all other human Clusters"))
    subtitle("Created by create\_fifth\_plot.m")
    saveas(gcf,strcat(dir_with_b_dist_plots_abs,"\Bhattacharyya Distance From Rat Cluster ", string(i), " To all other human Clusters.fig"))
    hold off;
    set(gcf,'renderer','Painters');
    % close(gcf)

end
end