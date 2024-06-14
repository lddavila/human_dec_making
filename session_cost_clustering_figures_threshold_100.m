%% add the Utility functions to my path
cd("Utility Functions\")
addpath(pwd)
cd("..")
threshold = 100;
version_name = strcat(" session_cost_clustering_",string(threshold),"_threshold");
data_dir = "C:\Users\ldd77\OneDrive\Desktop\human_dec_making\session_cost_clustering";
name_of_dir_with_newly_thresholded_data = "psych_dir_thresh_100";

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
human_data_table = return_given_cluster_table("all human data.xlsx","Cluster Table For  session_cost_clustering_100_thresholdfigures created on 05-21-2024");

%% get human data information (ie. # of subjects, # of data points )
human_stats_map = get_human_data_table_stats(human_data_table);
rat_stats_map = get_rat_data_table_stats(rat_data_table);
%% create the average xyz plot  1N
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
% close all;
%% (NO LONGER USED) try to recreate xyz using data which is not significantly different data from each task (SF3Q)
% clc;
% C = ['r','g','b','c'];
% [map_of_bhaat_distance_permutations,map_of_mean_significance_permutations,map_of_variance_significance_permutations] = derive_bhaat_distance_permutations(human_data_table);
% proportions_to_match = get_cluster_counts_2(human_data_table,unique(human_data_table.experiment),unique(human_data_table.cluster_number),1);
% get_average_xyz_per_human_exp_using_non_sig_diff_data(human_data_table, C,strcat("average xyz recreated with non sig diff data created on",string(datetime("today",'Format','MM-d-yyyy'))),human_stats_map,proportions_to_match,map_of_mean_significance_permutations,version_name)

%% try to recreate xyz using data which is not significantly different data from each task (SF3Q) version 2
clc;
C = ['r','g','b','c'];
[map_of_bhaat_distance_permutations,map_of_mean_significance_permutations,map_of_variance_significance_permutations] = derive_bhaat_distance_permutations(human_data_table);
proportions_to_match = get_cluster_counts_2(human_data_table,unique(human_data_table.experiment),unique(human_data_table.cluster_number),1);
get_average_xyz_per_human_exp_using_non_sig_diff_data_ver_2(human_data_table, C,strcat("average xyz recreated with non sig diff data created on",string(datetime("today",'Format','MM-d-yyyy'))),human_stats_map,proportions_to_match,map_of_mean_significance_permutations,version_name)

%% recreate average xyz, using weighted mean of each cluster instead of mean of all data (SF3P)
clc;
C = ['r','g','b','c'];
proportions_to_match = get_cluster_counts_2(human_data_table,unique(human_data_table.experiment),unique(human_data_table.cluster_number),1);
get_average_xyz_per_human_experiment_using_table_and_weights_2(human_data_table,C,"average xyz plot using weighted averages",human_stats_map,proportions_to_match,version_name);
