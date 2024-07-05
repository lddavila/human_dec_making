% threshold = 0;
% version_name = strcat(" session_cost_clustering_",string(threshold),"_threshold");
% human_data_table = return_given_cluster_table("all human data.xlsx",strcat("Cluster Table For  session_cost_clustering_",string(threshold),"_thresholdfigures created on 05-21-2024"));
% colors = distinguishable_colors(20);
% human_stats_map = get_human_data_table_stats(human_data_table);
% create3d_cluster_plot_for_human(human_data_table,colors,strcat("Human Data threshold:",version_name),version_name,"log(abs(max))","log(abs(shift))","log(abs(slope))","3d cluster plots session_cost by threshold",human_stats_map,string(datetime("today",'Format','MM-d-yyyy')),version_name)
%% Supplemental Figure 3D
cd("Utility Functions\");
addpath(pwd);
cd("..");
threshold = 70;
version_name = strcat(" session_cost_clustering_",string(threshold),"_threshold");
human_data_table = return_given_cluster_table("all human data.xlsx",strcat("Cluster Table For  session_cost_clustering_",string(threshold),"_thresholdfigures created on 05-21-2024"));
colors = distinguishable_colors(20);
human_stats_map = get_human_data_table_stats(human_data_table);
create3d_cluster_plot_for_human(human_data_table,colors,strcat("Human Data threshold:",version_name),version_name,"log(abs(max))","log(abs(shift))","log(abs(slope))","3d cluster plots session_cost by threshold",human_stats_map,string(datetime("today",'Format','MM-d-yyyy')),version_name)

name_of_dir_with_newly_thresholded_data = "psych_dir_thresh_70";
table_of_human_dir = get_dirs_with_data(name_of_dir_with_newly_thresholded_data);

centers = [-8.4228 -2.9848e-06 -13.7845;
    -6.252 1.14615 0.136439;
    4.50766 5.22001 0.740335;
    3.57903, -16.7105, 1.37222;
    13.1213 9.77206 -1.31392];
call_FCM_for_all_human_data(table_of_human_dir,centers, strcat("Cluster Table For ",version_name,"figures created on ",string(datetime("today",'Format','MM-d-yyyy'))))


%%
threshold = 50;
version_name = strcat(" session_cost_clustering_",string(threshold),"_threshold");
human_data_table = return_given_cluster_table("all human data.xlsx",strcat("Cluster Table For  session_cost_clustering_",string(threshold),"_thresholdfigures created on 05-21-2024"));
colors = distinguishable_colors(20);
human_stats_map = get_human_data_table_stats(human_data_table);
create3d_cluster_plot_for_human(human_data_table,colors,strcat("Human Data threshold:",version_name),version_name,"log(abs(max))","log(abs(shift))","log(abs(slope))","3d cluster plots session_cost by threshold",human_stats_map,string(datetime("today",'Format','MM-d-yyyy')),version_name)
%% 
threshold = 80;
version_name = strcat(" session_cost_clustering_",string(threshold),"_threshold");
human_data_table = return_given_cluster_table("all human data.xlsx",strcat("Cluster Table For  session_cost_clustering_",string(threshold),"_thresholdfigures created on 05-21-2024"));
colors = distinguishable_colors(20);
human_stats_map = get_human_data_table_stats(human_data_table);
create3d_cluster_plot_for_human(human_data_table,colors,strcat("Human Data threshold:",version_name),version_name,"log(abs(max))","log(abs(shift))","log(abs(slope))","3d cluster plots session_cost by threshold",human_stats_map,string(datetime("today",'Format','MM-d-yyyy')),version_name)
%%
threshold = 100;
version_name = strcat(" session_cost_clustering_",string(threshold),"_threshold");
human_data_table = return_given_cluster_table("all human data.xlsx",strcat("Cluster Table For  session_cost_clustering_",string(threshold),"_thresholdfigures created on 05-21-2024"));
colors = distinguishable_colors(20);
human_stats_map = get_human_data_table_stats(human_data_table);
create3d_cluster_plot_for_human(human_data_table,colors,strcat("Human Data threshold:",version_name),version_name,"log(abs(max))","log(abs(shift))","log(abs(slope))","3d cluster plots session_cost by threshold",human_stats_map,string(datetime("today",'Format','MM-d-yyyy')),version_name)

