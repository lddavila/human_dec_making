%% add the Utility functions to my path
cd("Utility Functions\")
addpath(pwd)
cd("..")
threshold = 50;
version_name = strcat(" session_cost_clustering_",string(threshold),"_threshold");
data_dir = "C:\Users\ldd77\OneDrive\Desktop\human_dec_making\session_cost_clustering";
name_of_dir_with_newly_thresholded_data = "psych_dir_thresh_50";

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
human_data_table = return_given_cluster_table("all human data.xlsx",strcat("Cluster Table For ",version_name,"figures created on 05-15-2024"));

%% use just to get fcm plot (Fig 1I)
table_of_human_dir = get_dirs_with_data(name_of_dir_with_newly_thresholded_data);
centers = [-8.4228 -2.9848e-06 -13.7845;
    -6.252 1.14615 0.136439;
    4.50766 5.22001 0.740335;
    3.57903, -16.7105, 1.37222;
    13.1213 9.77206 -1.31392];
call_FCM_for_all_human_data(table_of_human_dir,centers, "doesnt matter")
%% Fig 1I
colors = distinguishable_colors(10);
create3d_cluster_plot("cluster_tables_for_rat_created_04_16_2024","rat_reward_choice",colors,"rat","Rat 3d Clustering","log(abs(max))","log(abs(shift))","log(abs(slope))","3d_cluster_plots",rat_stats_map,string(datetime("today",'Format','MM-d-yyyy')),version_name)
create3d_cluster_plot_for_human(human_data_table,colors,"human","human 3d Clustering","log(abs(max))","log(abs(shift))","log(abs(slope))","3d_cluster_plots",human_stats_map,string(datetime("today",'Format','MM-d-yyyy')),version_name)


%% get human data information (ie. # of subjects, # of data points )
human_stats_map = get_human_data_table_stats(human_data_table);
rat_stats_map = get_rat_data_table_stats(rat_data_table);

%% Compare human Tasks to each other (FIGS LIKE FIG 1K, SF3B,SF3C,SF3D,SF3E,SF3F)
compare_human_data_to_human_data_using_dg_for_sig(human_data_table,strcat("3d cluster plots human_to_human_comparison created on ",string(datetime("today",'Format','MM-d-yyyy'))),human_stats_map)
%% create overlain spider plots with dg_significance (FIGS LIKE FIG 1L, SF3J,SF3K,SF3L,SF3m,SF3N)
create_spider_plots_with_sig_using_dg(human_data_table,"spider plots using dg for significance",human_stats_map,version_name)
%% create heat map for Chi squared significance (FIG 1M)
create_heat_maps_for_chi_squared_significance(human_data_table,"heat map chi squared significance",0,0.052,human_stats_map,version_name)
% create_heat_maps_for_chi_squared_significance(human_data_table,"heat map chi squared significance",1,0.052,human_stats_map,version_name)
%% get average xyz plots for different human experiments (Fig 1N)
% clc;
% close all;
C = ['r','g','b','c'];
get_average_xyz_per_human_experiment_using_spectral_table(human_data_table,C,"average xyz plot all data",human_stats_map,version_name)
%% recreate average xyz, using a subset of data instead of all data, but keeping proportions the same (Fig 1O)
% clc;
figure;
C = ['r','g','b','c'];
proportions_to_match = get_cluster_counts_2(human_data_table,unique(human_data_table.experiment),unique(human_data_table.cluster_number),1);
% disp([keys(proportions_to_match).',values(proportions_to_match).'])
run_average_sigmoids_n_times(human_data_table,cell2mat(values(proportions_to_match).'),1000,1,1,C,"Average XYZ plot recreated from proportional subsets","Average Sigmoid Experiment 2",human_stats_map,version_name)

%% recreate average xyz plots using explicitly wrong proportions (FIG 1P)
% clc;
C = ['r','g','b','c'];
proportions_to_match = get_cluster_counts_2(human_data_table,unique(human_data_table.experiment),unique(human_data_table.cluster_number),1);
% disp([keys(proportions_to_match).',values(proportions_to_match).'])
recreate_average_xyz_using_different_proportions(human_data_table,cell2mat(values(proportions_to_match).'),1000,1,1,C,"Average XYZ plot recreated from incorrect proportional subsets","Average Sigmoid Experiment 2",human_stats_map,version_name)
close all;

%% fig 3F
colors = distinguishable_colors(10);
create3d_cluster_plot("cluster_tables_for_rat_created_04_16_2024","rat_reward_choice",colors,"rat","Rat 3d Clustering","log(abs(max))","log(abs(shift))","log(abs(slope))","3d_cluster_plots",rat_stats_map,string(datetime("today",'Format','MM-d-yyyy')),version_name)

%% Fig 3G
only_aa_data = select_single_experiment_from_data_set_2(human_data_table,"approach_avoid");
create_human_to_rat_comparison_ver_4("rat_reward_choice.xlsx",only_aa_data,"cluster_tables_for_rat_created_04_16_2024",strcat("b_dist_plots_updated_4 Created On",string(datetime("today",'Format','MM-d-yyyy'))),colors,human_stats_map,rat_stats_map, string(datetime("today",'Format','MM-d-yyyy')),version_name);
%% Fig 1J, SF1A
% create an average sigmoid for per experiment set and average sigmoid per cluster of experiment
mkdir("average_sigmoids_version_2")
mkdir("average_sigmoids_3_version_2")
david_runme2;

%% SF3G, SF3H, SF3I
[map_of_bhaat_distance_permutations,map_of_mean_significance_permutations,map_of_variance_significance_permutations] = derive_bhaat_distance_permutations(human_data_table);
clc;
[bhaat_dist_x_matrix,x_y_ticks] = create_heat_map_from_map_of_permutations(human_data_table,map_of_bhaat_distance_permutations,strcat("heat maps bhaat distance created on ",string(datetime("today",'Format','MM-d-yyyy'))),1,0,"All Clusters Bhaat Distance Permutations",NaN,human_stats_map,version_name);
[bhaat_dist_y_matrix,x_y_ticks] = create_heat_map_from_map_of_permutations(human_data_table,map_of_bhaat_distance_permutations,strcat("heat maps bhaat distance created on",string(datetime("today",'Format','MM-d-yyyy'))),2,0,"All Clusters Bhaat Distance Permutations",NaN,human_stats_map,version_name);
[bhaat_dist_z_matrix,x_y_ticks] = create_heat_map_from_map_of_permutations(human_data_table,map_of_bhaat_distance_permutations,strcat("heat maps bhaat distance created on",string(datetime("today",'Format','MM-d-yyyy'))),3,0,"All Clusters Bhaat Distance Permutations",NaN,human_stats_map,version_name);
[bhaat_dist_mean_matrix,x_y_ticks] = create_heat_map_from_map_of_permutations(human_data_table,map_of_bhaat_distance_permutations,"heat maps bhaat distance",NaN,0,"All Clusters Bhaat Distance Permutations",NaN,human_stats_map,version_name);
clc;
close all;
mask_given_data_and_create_heat_map([],bhaat_dist_x_matrix,strcat("heat map bhaat distance alexanders updates created on",string(datetime("today",'Format','MM-d-yyyy'))),x_y_ticks,"bhaat distance of log(abs(max))",'%.1f',human_stats_map,version_name)
mask_given_data_and_create_heat_map([],bhaat_dist_y_matrix,strcat("heat map bhaat distance alexanders updates created on",string(datetime("today",'Format','MM-d-yyyy'))),x_y_ticks,"bhaat distance of log(abs(shift))",'%.1f',human_stats_map,version_name)
mask_given_data_and_create_heat_map([],bhaat_dist_z_matrix,strcat("heat map bhaat distance alexanders updates created on",string(datetime("today",'Format','MM-d-yyyy'))),x_y_ticks,"bhaat distance of log(abs(slope))",'%.1f',human_stats_map,version_name)

%% (SF 3O-1:3O-5)
create_bar_plots_for_cluster_proportions(human_data_table,0,strcat("bar plot human cluster proportions created on",string(datetime("today",'Format','MM-d-yyyy'))),human_stats_map,version_name);
%% recreate average xyz, using weighted mean of each cluster instead of mean of all data (SF3P)
clc;
C = ['r','g','b','c'];
proportions_to_match = get_cluster_counts_2(human_data_table,unique(human_data_table.experiment),unique(human_data_table.cluster_number),1);
get_average_xyz_per_human_experiment_using_table_and_weights_2(human_data_table,C,"average xyz plot using weighted averages",human_stats_map,proportions_to_match,version_name);

%% try to recreate xyz using data which is not significantly different data from each task (SF3Q)
clc;
C = ['r','g','b','c'];
proportions_to_match = get_cluster_counts_2(human_data_table,unique(human_data_table.experiment),unique(human_data_table.cluster_number),1);
get_average_xyz_per_human_exp_using_non_sig_diff_data(human_data_table, C,strcat("average xyz recreated with non sig diff data created on",string(datetime("today",'Format','MM-d-yyyy'))),human_stats_map,proportions_to_match,map_of_mean_significance_permutations,version_name)

%% create heat map for mean all each row is a cluster and each column is an experiment comparison (SF4H, SF4I, SF4J)
create_heat_maps_for_significance(map_of_mean_significance_permutations,"Significant Change In Means Determined using ttest2",unique(human_data_table.experiment),unique(human_data_table.cluster_number),strcat("heatmap mean cut down created on ",string(datetime("today",'Format','MM-d-yyyy'))),human_stats_map,version_name)
%% create heat map for mean all each row is a cluster and each column is an experiment comparison (SF4K, SF4L, SF4M)
create_heat_maps_for_significance(map_of_variance_significance_permutations,"Significant Change In Variances using vartest2",unique(human_data_table.experiment),unique(human_data_table.cluster_number),strcat("heatmap variance cut down created on",string(datetime("today",'Format','MM-d-yyyy'))),human_stats_map,version_name)
%% SF7a,SF7b,SF7c,SF7d,SF7e,SF7f
colors = distinguishable_colors(30);
create_human_to_rat_comparison_ver_3("rat_reward_choice.xlsx",only_aa_data,"cluster_tables_for_rat_created_04_16_2024",strcat("b_dist_plots_updated_3 Created On",string(datetime("today",'Format','MM-d-yyyy'))),colors,human_stats_map,rat_stats_map, string(datetime("today",'Format','MM-d-yyyy')),version_name)
%% create 3d plot for human to rat comparison (SF7A,SF7B,SF7C,SF7D,SF7E,SF7F
colors = distinguishable_colors(30);
approach_avoid_data = select_single_experiment_from_data_set_2(human_data_table,"approach_avoid");
human_to_rat_3d_plot_normalized(approach_avoid_data,rat_data_table,"human and rat",colors,"transformations");

%% create tables which map n human clusters to p rat clusters
clc;
colors = distinguishable_colors(30);
create_fig_mapping_rat_to_human_plots(human_data_table,rat_data_table,"table of mappings",1,colors,version_name,1)
create_fig_mapping_rat_to_human_plots(human_data_table,rat_data_table,"table of mappings",0,colors,version_name,1)

%% create average sigmoids per cluster ???

%% (NO LONGER USED )create plots which draw shapes around the clusters
% close all;
% colors = distinguishable_colors(30);
draw_a_shape_around_each_cluster(human_data_table,  human_stats_map,"human","human All","cluster shape plots",0,colors);
% draw_a_shape_around_each_cluster(rat_data_table,  rat_stats_map,"rat","Rat","cluster shape plots",0,colors);
% draw_a_shape_around_each_cluster_split_by_tt(human_data_table,human_stats_map,"human","all","3d shape plots split by task type",0,colors);
% draw_a_shape_around_each_cluster_all_tt_on_single_plot(human_data_table,human_stats_map,"human","","3d shape plot permutations",0,colors);
% colors = distinguishable_colors(30);
% approach_avoid_data = select_single_experiment_from_data_set_2(human_data_table,"approach_avoid");
% draw_a_shape_around_cluster_rat_and_human(approach_avoid_data,rat_data_table,"human and rat",colors,"transformations");
% concatenate_many_plots_updated("transformations","transformations.pdf","ALL PDFS")

