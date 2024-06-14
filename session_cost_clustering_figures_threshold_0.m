%% add the Utility functions to my path
cd("Utility Functions\")
addpath(pwd)
cd("..")
threshold = 0;
version_name = strcat(" session_cost_clustering_",string(threshold),"_threshold");
data_dir = "C:\Users\ldd77\OneDrive\Desktop\human_dec_making\session_cost_clustering";
name_of_dir_with_newly_thresholded_data = "psych_dir_thresh_0";

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

%% FINAL RAT CLUSTERING CONFIGURATION, DO NOT RUN AGAIN unless there's more data to be analyzed
% home_dir = cd("rat sigmoid data created 04-15-2024");
% cd("reward choice Sigmoid Data\");
% rat_data_dir = string(cd(home_dir));
% rat_centers = {[-9.19223 -0.160124 -5.94521; 0.0725309 9.26771 5.38323; -0.0750793 2.44644 4.20085; 7.26216 9.12042 2.84782; -1.0078 3.31472 6.58382; 8.22584 6.32504 6.05144 ]};
% % rat_centers = {[]};
% table_of_rat_data = table("rat_reward_choice",rat_data_dir,'VariableNames',["Task", "Data_Directory"]);
% call_FCM_for_each_row_of_data_for_rat(table_of_rat_data,rat_centers,"cluster_tables_for_rat_created_04_16_2024");

%% put rat and human data into a table to be used
rat_data_table = return_given_cluster_table("rat_reward_choice.xlsx","cluster_tables_for_rat_created_04_16_2024");
human_data_table = return_given_cluster_table("all human data.xlsx","Cluster Table For  session_cost_clustering_0_thresholdfigures created on 05-21-2024");

%% get human data information (ie. # of subjects, # of data points )
human_stats_map = get_human_data_table_stats(human_data_table);
rat_stats_map = get_rat_data_table_stats(rat_data_table);
%% use just to get fcm plot (Fig 1I)
table_of_human_dir = get_dirs_with_data(name_of_dir_with_newly_thresholded_data);
centers = [-8.4228 -2.9848e-06 -13.7845;
    -6.252 1.14615 0.136439;
    4.50766 5.22001 0.740335;
    3.57903, -16.7105, 1.37222;
    13.1213 9.77206 -1.31392];
call_FCM_for_all_human_data(table_of_human_dir,centers, "doesnt matter")
%% use just to get rat fcm plot, do not refer to this 
home_dir = cd("rat sigmoid data created 04-15-2024");
cd("reward choice Sigmoid Data\");
rat_data_dir = string(cd(home_dir));
rat_centers = {[-9.19223 -0.160124 -5.94521; 0.0725309 9.26771 5.38323; -0.0750793 2.44644 4.20085; 7.26216 9.12042 2.84782; -1.0078 3.31472 6.58382; 8.22584 6.32504 6.05144 ]};
% rat_centers = {[]};
table_of_rat_data = table("rat_reward_choice",rat_data_dir,'VariableNames',["Task", "Data_Directory"]);
call_FCM_for_each_row_of_data_for_rat(table_of_rat_data,rat_centers,"doesn't matter");
%% create average sigmoid for each of the human clusters, not splitting by task
create_average_sigmoids_by_cluster_only = 1;
create_average_sigmoid_by_cluster_and_task = 0;

multiple_ys = cell(1,10);
for i=1:10
    if i==1
        run_the_first_part =1;
    else
        run_the_first_part =0;
    end
    version_name = strcat(" session_cost_clustering_",string(threshold),"_threshold",string(i));
    david_runme2;
    multiple_ys{i} = all_ys;
end
%% comparing the ys
for i=1:5
    for j=1:length(multiple_ys)
        curr_something = multiple_ys{j};
        curr_clust = curr_something(curr_something.cluster_number==i,:);
        disp(strcat("Cluster ",string(i)," ",string(curr_clust.y1)," ",string(curr_clust.y2)," ",string(curr_clust.y3), " ",string(curr_clust.y4)))
        
    end
    disp("///////////////////////////////")
end
%% create heat map for Chi squared significance (FIG 1M)
create_heat_maps_for_chi_squared_significance(human_data_table,"heat map chi squared significance",0,0.052,human_stats_map,version_name)

%% fig 3F
colors = distinguishable_colors(10);
create3d_cluster_plot("cluster_tables_for_rat_created_04_16_2024","rat_reward_choice",colors,"rat","Rat 3d Clustering","log(abs(max))","log(abs(shift))","log(abs(slope))","3d_cluster_plots",rat_stats_map,string(datetime("today",'Format','MM-d-yyyy')),version_name)

%% Fig 3G
only_aa_data = select_single_experiment_from_data_set_2(human_data_table,"approach_avoid");
create_human_to_rat_comparison_ver_4("rat_reward_choice.xlsx",only_aa_data,"cluster_tables_for_rat_created_04_16_2024",strcat("b_dist_plots_updated_4 Created On",string(datetime("today",'Format','MM-d-yyyy'))),colors,human_stats_map,rat_stats_map, string(datetime("today",'Format','MM-d-yyyy')),version_name);
%% create average sigmoid split by tasks, and by cluster
create_average_sigmoids_by_cluster_only = 0;
create_average_sigmoid_by_cluster_and_task = 1;
mkdir("average_sigmoids_version_2")
mkdir("average_sigmoids_3_version_2")
david_runme2
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

%% create spider plots with dg for signifiance 
create_spider_plots_with_sig_using_dg(human_data_table,"spider plots using dg for significance",human_stats_map,version_name)

%% Figure 3
%% create just the rat cluster by itself Fig 3f
colors = distinguishable_colors(10);
create3d_cluster_plot("cluster_tables_for_rat_created_04_16_2024","rat_reward_choice",colors,"rat","Rat 3d Clustering","log(abs(max))","log(abs(shift))","log(abs(slope))","3d_cluster_plots",rat_stats_map,string(datetime("today",'Format','MM-d-yyyy')),version_name)

%% create non normalized plot comparing rat to human clusters
only_aa_data = select_single_experiment_from_data_set_2(human_data_table,"approach_avoid");
create_human_to_rat_comparison_ver_4("rat_reward_choice.xlsx",only_aa_data,"cluster_tables_for_rat_created_04_16_2024",strcat("b_dist_plots_updated_4 Created On",string(datetime("today",'Format','MM-d-yyyy'))),colors,human_stats_map,rat_stats_map, string(datetime("today",'Format','MM-d-yyyy')),version_name);
%% create normalized plot comparing rat to human clusters
colors = distinguishable_colors(30);
approach_avoid_data = select_single_experiment_from_data_set_2(human_data_table,"approach_avoid");
human_to_rat_3d_plot_normalized_ver_2(approach_avoid_data,rat_data_table,"Normalized human approach\_avoid and rat",colors,"normalized human to rat comparison",rat_stats_map,human_stats_map,version_name);
%% create non normalized  tables which map n human clusters to p rat clusters
clc;
colors = distinguishable_colors(30);
create_fig_mapping_rat_to_human_plots(human_data_table,rat_data_table,"table of mappings",0,colors,version_name,1)

%% create normalized  tables which map n human clusters to p rat clusters
clc;
colors = distinguishable_colors(30);
create_fig_mapping_rat_to_human_plots(human_data_table,rat_data_table,"table of mappings",1,colors,version_name,1)

%% Compare human Tasks to each other (FIGS LIKE SF3B,SF3C,SF3D,SF3E,SF3F)
compare_human_data_to_human_data_using_dg_for_sig(human_data_table,strcat("3d cluster plots human_to_human_comparison created on ",string(datetime("today",'Format','MM-d-yyyy'))),human_stats_map,version_name)

%% (SF 3O-1:3O-5)
create_bar_plots_for_cluster_proportions(human_data_table,0,strcat("bar plot human cluster proportions created on",string(datetime("today",'Format','MM-d-yyyy'))),human_stats_map,version_name);

%% create heat map for mean all each row is a cluster and each column is an experiment comparison (SF4H, SF4I, SF4J)
[map_of_bhaat_distance_permutations,map_of_mean_significance_permutations,map_of_variance_significance_permutations] = derive_bhaat_distance_permutations(human_data_table);
create_heat_maps_for_significance(map_of_mean_significance_permutations,"Significant Change In Means Determined using ttest2",unique(human_data_table.experiment),unique(human_data_table.cluster_number),strcat("heatmap mean cut down created on ",string(datetime("today",'Format','MM-d-yyyy'))),human_stats_map,version_name)
%% create heat map for variance all each row is a cluster and each column is an experiment comparison (SF4K, SF4L, SF4M)
[map_of_bhaat_distance_permutations,map_of_mean_significance_permutations,map_of_variance_significance_permutations] = derive_bhaat_distance_permutations(human_data_table);
create_heat_maps_for_significance(map_of_variance_significance_permutations,"Significant Change In Variances using vartest2",unique(human_data_table.experiment),unique(human_data_table.cluster_number),strcat("heatmap variance cut down created on",string(datetime("today",'Format','MM-d-yyyy'))),human_stats_map,version_name)
%% SF7a,SF7b,SF7c,SF7d,SF7e,SF7f
colors = distinguishable_colors(30);
approach_avoid_data = select_single_experiment_from_data_set_2(human_data_table,"approach_avoid");
create_human_to_rat_comparison_ver_3("rat_reward_choice.xlsx",approach_avoid_data,"cluster_tables_for_rat_created_04_16_2024",strcat("b_dist_plots_updated_3 Created On",string(datetime("today",'Format','MM-d-yyyy'))),colors,human_stats_map,rat_stats_map, string(datetime("today",'Format','MM-d-yyyy')),version_name)

%% run food dep data (shouldn't run again unless there's new data to be analyzed)
% get_food_dep_rat_data;
%% run fcm on food dep data (shouldn't be run again unless more data is created)
% home_dir = cd("food deprivation rat sigmoid data created 04-28-2024");
% cd("food deprivation reward choice Sigmoid Data\");
% rat_data_dir = string(cd(home_dir));
% rat_centers = {[-9.19223 -0.160124 -5.94521; 0.0725309 9.26771 5.38323; -0.0750793 2.44644 4.20085; 7.26216 9.12042 2.84782; -1.0078 3.31472 6.58382; 8.22584 6.32504 6.05144 ]};
% % rat_centers = {[]};
% table_of_rat_data = table("food_deprivation_rat_reward_choice",rat_data_dir,'VariableNames',["Task", "Data_Directory"]);
% call_FCM_for_each_row_of_data_for_rat(table_of_rat_data,rat_centers,"cluster_tables_for_rat_food_deprivation_created_04_28_2024");

%% get food deprivation plot
colors = distinguishable_colors(20);
rat_food_dep_data = return_given_cluster_table("food_deprivation_rat_reward_choice","cluster_tables_for_rat_food_deprivation_created_04_28_2024");
rat_food_dep_stats_map = get_rat_data_table_stats(rat_food_dep_data);
create3d_cluster_plot("cluster_tables_for_rat_food_deprivation_created_04_28_2024","food_deprivation_rat_reward_choice",colors,"rat","food deprivatin rat data","log(abs(max))","log(abs(shift))","log(abs(slope))","food deprivation 3d plot",rat_food_dep_stats_map,string(datetime("today",'Format','MM-d-yyyy')),"food deprivation")

%% split food dep data into 2 bins
rebin_individual_rats_cluster_info_2("cluster_tables_for_rat_food_deprivation_created_04_28_2024","Cluster Tables Rebinned Into 2 Bins",["Food Deprivation"],2)
%% run various permutations of meta data (hunger, tiredness, pain,and story_pref) to see if there's any significant differences between them
clc;
colors = distinguishable_colors(30);
run_permutations_based_on_meta_data(human_data_table, ...
    {appr_avoid_sessions,social_sessions,probability_sessions,moral_sessions}, ...
    ["approach_avoid","social","probability","moral"],colors,version_name,0.054,0.5, ...
    "3d Cluster Plots and Heat Maps Of Significant Changes");

%% run various permutations of meta data (hunger, tiredness, pain, no story_pref) to see if there's any significant differences between them
clc;
colors = distinguishable_colors(30);
run_permutations_based_on_meta_data_no_story_pref(human_data_table, ...
    {appr_avoid_sessions,social_sessions,probability_sessions,moral_sessions}, ...
    ["approach_avoid","social","probability","moral"],colors,version_name,0.05,0.5, ...
    "3d Cluster Plots and Heat Maps Of Significant Changes No Story Pref");

%% check to see if hunger causes any significant differences by itself (also runs different levels of story_pref incremented by 10)
clc;
colors = distinguishable_colors(30);
filter_based_on_individual_meta_data(human_data_table, ...
    {appr_avoid_sessions,social_sessions,probability_sessions,moral_sessions}, ...
    ["approach_avoid","social","probability","moral"],colors,version_name,0.054,0.5, ...
    "3d Cluster Plots and heat Maps of Significant Changes Hunger","average_hunger");
%% check to see if tiredness causes any significant differences by itself (also runs different levels of story_pref incremented by 10)
clc;
colors = distinguishable_colors(30);
filter_based_on_individual_meta_data(human_data_table, ...
    {appr_avoid_sessions,social_sessions,probability_sessions,moral_sessions}, ...
    ["approach_avoid","social","probability","moral"],colors,version_name,0.054,0.5, ...
    "3d Cluster Plots and heat Maps of Significant Changes Tiredness","tiredness");
%% check to see if pain causes any significant differences by itself(also runs different levels of story_pref incremented by 10)
clc;
colors = distinguishable_colors(30);
filter_based_on_individual_meta_data(human_data_table, ...
    {appr_avoid_sessions,social_sessions,probability_sessions,moral_sessions}, ...
    ["approach_avoid","social","probability","moral"],colors,version_name,0.054,0.5, ...
    "3d Cluster Plots and heat Maps of Significant Changes Pain","pain");
%% check to see if gender causes any significant differences by itself(also runs different levels of story_pref incremented by 10)

%% get bhaatycharya distance between clusters, do not distinguish between tasks
clc;
[bhaat_distance_permutations_not_split_by_task,mean_permutations_not_split_by_task,variance_permutations_not_split_by_task] = derive_bhaat_distance_permutations_dont_split_by_task(human_data_table);
create_heat_maps_from_permutations_without_splitting(bhaat_distance_permutations_not_split_by_task,"Heat Map Not Split By Task", version_name,human_data_table,"bhat distance",human_stats_map);
create_heat_maps_from_permutations_without_splitting(mean_permutations_not_split_by_task,"Heat Map Not Split By Task", version_name,human_data_table,"mean",human_stats_map);
create_heat_maps_from_permutations_without_splitting(variance_permutations_not_split_by_task,"Heat Map Not Split By Task", version_name,human_data_table,"variance",human_stats_map);
%% get normalized comparison between rat and human clusters
colors = distinguishable_colors(30);
only_aa_data = select_single_experiment_from_data_set_2(human_data_table,"approach_avoid");
normalized_human_to_rat_comparison("rat_reward_choice.xlsx",only_aa_data,"cluster_tables_for_rat_created_04_16_2024","b_dist_plots_updated_3",colors,human_stats_map,rat_stats_map, string(datetime("today",'Format','MM-d-yyyy')),version_name)

%% get normalized comparison between rat and human clusters, consolidated on single plot 
colors = distinguishable_colors(30);
only_aa_data = select_single_experiment_from_data_set_2(human_data_table,"approach_avoid");
normalized_human_to_rat_comparison_single_plot("rat_reward_choice.xlsx",only_aa_data,"cluster_tables_for_rat_created_04_16_2024","3d cluster plot rat to human comparison",colors,human_stats_map,rat_stats_map, string(datetime("today",'Format','MM-d-yyyy')),version_name,1)
normalized_human_to_rat_comparison_single_plot("rat_reward_choice.xlsx",only_aa_data,"cluster_tables_for_rat_created_04_16_2024","3d cluster plot rat to human comparison",colors,human_stats_map,rat_stats_map, string(datetime("today",'Format','MM-d-yyyy')),version_name,0)

%% get normalized and non normalized bhaat heat map comparing human to rat data
only_aa_data = select_single_experiment_from_data_set_2(human_data_table,"approach_avoid");
get_bhat_dist_heat_map_comparing_rat_to_human(only_aa_data,rat_data_table,1,"heat map human to rat Comparison",rat_stats_map,human_stats_map,version_name,1)
get_bhat_dist_heat_map_comparing_rat_to_human(only_aa_data,rat_data_table,0,"heat map human to rat Comparison",rat_stats_map,human_stats_map,version_name,1)