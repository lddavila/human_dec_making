%% add the Utility functions to my path
cd("Utility Functions\")
addpath(pwd)
cd("..")
threshold =40;
version_name = strcat(" session_cost_clustering_",string(threshold),"_threshold");
data_dir = "C:\Users\ldd77\OneDrive\Desktop\human_dec_making\session_cost_clustering";
name_of_dir_with_newly_thresholded_data = "psych_dir_thresh_40";

%% copy only the data which meets the threshold
story_types = ["approach_avoid", "social", "probability", "moral"];
make_thresh_psych_folder(clean_approach_data, subject_prefs,threshold,data_dir,story_types);

%% run fcm for human data (session cost clustering) 
table_of_human_dir = get_dirs_with_data(name_of_dir_with_newly_thresholded_data);
centers = [-8.4228 -2.9848e-06 -13.7845;
    -6.252 1.14615 0.136439;
    4.50766 5.22001 0.740335;
    3.57903, -16.7105, 1.37222;
    13.1213 9.77206 -1.31392];
call_FCM_for_all_human_data(table_of_human_dir,centers, strcat("Cluster Table For ",version_name,"figures created on ",string(datetime("today",'Format','MM-d-yyyy'))))

%% put rat and human data into a table to be used
rat_data_table = return_given_cluster_table("rat_reward_choice.xlsx","cluster_tables_for_rat_created_04_16_2024");
human_data_table = return_given_cluster_table("all human data.xlsx",strcat("Cluster Table For ",version_name,"figures created on ",string(datetime("today",'Format','MM-d-yyyy'))));

%% use just to get fcm plot
table_of_human_dir = get_dirs_with_data(name_of_dir_with_newly_thresholded_data);
centers = [-8.4228 -2.9848e-06 -13.7845;
    -6.252 1.14615 0.136439;
    4.50766 5.22001 0.740335;
    3.57903, -16.7105, 1.37222;
    13.1213 9.77206 -1.31392];
call_FCM_for_all_human_data(table_of_human_dir,centers, "doesnt matter")
%% get human data information (ie. # of subjects, # of data points )
human_stats_map = get_human_data_table_stats(human_data_table);
rat_stats_map = get_rat_data_table_stats(rat_data_table);

%% create heat map for Chi squared significance
create_heat_maps_for_chi_squared_significance(human_data_table,"heat map chi squared significance",0,0.052,human_stats_map,version_name)
create_heat_maps_for_chi_squared_significance(human_data_table,"heat map chi squared significance",1,0.052,human_stats_map,version_name)
%% create plots which draw shapes around the clusters
% close all;
colors = distinguishable_colors(30);
draw_a_shape_around_each_cluster(human_data_table,  human_stats_map,"human","human All","cluster shape plots",0,colors);
draw_a_shape_around_each_cluster_split_by_tt(human_data_table,human_stats_map,"human","all","3d shape plots split by task type",0,colors);
draw_a_shape_around_each_cluster(rat_data_table,  rat_stats_map,"rat","Rat","cluster shape plots",0,colors);
%%
% close all
draw_a_shape_around_each_cluster_all_tt_on_single_plot(human_data_table,human_stats_map,"human","","3d shape plot permutations",0,colors);

%%
colors = distinguishable_colors(30);
draw_a_shape_around_cluster_rat_and_human(human_data_table,rat_data_table,"human and rat",colors)

%% create overlain spider plots with dg_significance
create_spider_plots_with_sig_using_dg(human_data_table,"spider plots using dg for significance",human_stats_map,version_name)