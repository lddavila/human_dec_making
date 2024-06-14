% threshold = 0;
% version_name = strcat(" session_cost_clustering_",string(threshold),"_threshold");
% human_data_table = return_given_cluster_table("all human data.xlsx",strcat("Cluster Table For  session_cost_clustering_",string(threshold),"_thresholdfigures created on 05-21-2024"));
% colors = distinguishable_colors(20);
% human_stats_map = get_human_data_table_stats(human_data_table);
% create3d_cluster_plot_for_human(human_data_table,colors,strcat("Human Data threshold:",version_name),version_name,"log(abs(max))","log(abs(shift))","log(abs(slope))","3d cluster plots session_cost by threshold",human_stats_map,string(datetime("today",'Format','MM-d-yyyy')),version_name)
%%
threshold = 30;
version_name = strcat(" session_cost_clustering_",string(threshold),"_threshold");
human_data_table = return_given_cluster_table("all human data.xlsx",strcat("Cluster Table For  session_cost_clustering_",string(threshold),"_thresholdfigures created on 05-21-2024"));
colors = distinguishable_colors(20);
human_stats_map = get_human_data_table_stats(human_data_table);
create3d_cluster_plot_for_human(human_data_table,colors,strcat("Human Data threshold:",version_name),version_name,"log(abs(max))","log(abs(shift))","log(abs(slope))","3d cluster plots session_cost by threshold",human_stats_map,string(datetime("today",'Format','MM-d-yyyy')),version_name)
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

