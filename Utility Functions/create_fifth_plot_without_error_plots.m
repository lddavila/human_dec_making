human_cluster_table = readtable("C:\Users\ldd77\OneDrive\Desktop\Lara Analysis\3d_cluster_tables\human all M.xlsx");
rat_cluster_table = readtable("C:\Users\ldd77\OneDrive\Desktop\Lara Analysis\3d_cluster_tables\rat reward_choice M.xlsx");

dir_with_b_dist_plots = "b_dist_plots";
if ~exist(dir_with_b_dist_plots,"dir")
    mkdir(dir_with_b_dist_plots)
    home_dir = cd(dir_with_b_dist_plots);
    dir_with_b_dist_plots_abs = cd(home_dir);

else
    home_dir = cd(dir_with_b_dist_plots);
    dir_with_b_dist_plots_abs =cd(home_dir);
end


rat_centers = [-9.19224 -0.160122 -5.94521; 
    0.0725258 9.26768 5.38323;
    -0.0750791 2.44643 4.20085; 
    7.26215 9.12042 2.84782];

human_centers = [-9.58304 9.75048e-08 -14.0991;
                -6.3448 1.54914 0.437736;
                 4.16898 11.8951 2.47445;
                  4.06153 3.09722 0.625457;
                11.3803 12.5503 0.188948];

human_colors ={[0,0.1,0.7],[0,0.1,0.7],[0.7,0,0],[0.5 0 0.5],[0 0 0]};
rat_colors = {[0 0 1],[1 0 0],[0.7 0 0.7],[.7 .7 .7]};


rat_clusters = unique(rat_cluster_table.cluster_number);
human_clusters = unique(human_cluster_table.cluster_number);

for i=1:length(rat_clusters)
    figure;
    rat_current_cluster_info = rat_cluster_table(rat_cluster_table.cluster_number==i,:);
    array_of_current_cluster_data_for_rat = [rat_current_cluster_info.clusterX,rat_current_cluster_info.clusterY,rat_current_cluster_info.clusterZ];
    scatter3(array_of_current_cluster_data_for_rat(:,1),array_of_current_cluster_data_for_rat(:,2),array_of_current_cluster_data_for_rat(:,3));
    hold on;
    plot3(rat_centers(i,1),rat_centers(i,2),rat_centers(i,3),"xk",MarkerSize=15,LineWidth=3);
   


    % for j=1:length(human_clusters)
    %     human_current_cluster_info = human_cluster_table(human_cluster_table.cluster_number==j,:);
    %     array_of_current_cluster_data_for_human = [human_current_cluster_info.clusterX,human_current_cluster_info.clusterY,human_current_cluster_info.clusterZ];
    %     scatter3(array_of_current_cluster_data_for_human(:,1),array_of_current_cluster_data_for_human(:,2),array_of_current_cluster_data_for_human(:,3));
    %     plot3(human_centers(j,1),human_centers(j,2),human_centers(j,3),"*k",MarkerSize=15,LineWidth=3);
    %     array_of_cluster_labels_for_human =logical(ones(size(array_of_current_cluster_data_for_human,1),1));
    %     cell_array_of_b_dist{j} = bhattacharyyaDistance([array_of_current_cluster_data_for_rat;array_of_current_cluster_data_for_human],[array_of_cluster_labels_for_rat;array_of_cluster_labels_for_human]);
    % end
    hold off;
end