%% SETUP PART 1: add the Utility functions to my path
cd("Utility Functions\")
addpath(pwd)
cd("..")
threshold = 0;
version_name = strcat(" session_cost_clustering_",string(threshold),"_threshold");
data_dir = "C:\Users\ldd77\OneDrive\Desktop\human_dec_making\session_cost_clustering";
name_of_dir_with_newly_thresholded_data = "psych_dir_thresh_0";

%% SET UP PART 2(Don't Run Again)copy only the data which meets the threshold
%story_types = ["approach_avoid", "social", "probability", "moral"];
%make_thresh_psych_folder(clean_approach_data, subject_prefs,threshold,data_dir,story_types);

%% SET UP PART 3 (DONT RUN AGAIN UNLESS THERE'S MORE DATA) run fcm for human data (session cost clustering) 
% table_of_human_dir = get_dirs_with_data(name_of_dir_with_newly_thresholded_data);
% centers = [-8.4228 -2.9848e-06 -13.7845;
%     -6.252 1.14615 0.136439;
%     4.50766 5.22001 0.740335;
%     3.57903, -16.7105, 1.37222;
%     13.1213 9.77206 -1.31392];
% call_FCM_for_all_human_data(table_of_human_dir,centers, strcat("Cluster Table For ",version_name,"figures created on ",string(datetime("today",'Format','MM-d-yyyy'))))

%% SET UP PART 4: FINAL RAT CLUSTERING CONFIGURATION, DO NOT RUN AGAIN unless there's more data to be analyzed
% home_dir = cd("rat sigmoid data created 04-15-2024");
% cd("reward choice Sigmoid Data\");
% rat_data_dir = string(cd(home_dir));
% rat_centers = {[-9.19223 -0.160124 -5.94521; 0.0725309 9.26771 5.38323; -0.0750793 2.44644 4.20085; 7.26216 9.12042 2.84782; -1.0078 3.31472 6.58382; 8.22584 6.32504 6.05144 ]};
% % rat_centers = {[]};
% table_of_rat_data = table("rat_reward_choice",rat_data_dir,'VariableNames',["Task", "Data_Directory"]);
% call_FCM_for_each_row_of_data_for_rat(table_of_rat_data,rat_centers,"cluster_tables_for_rat_created_04_16_2024");

%% SET UP PART 5: put rat and human data into a table to be used
rat_data_table = return_given_cluster_table("rat_reward_choice.xlsx","cluster_tables_for_rat_created_04_16_2024");
human_data_table = return_given_cluster_table("all human data.xlsx","Cluster Table For  session_cost_clustering_0_thresholdfigures created on 05-21-2024");

%% SET UP PART 6: get human and rat data information (i.e. # of subjects, # of data points)
human_stats_map = get_human_data_table_stats(human_data_table);
rat_stats_map = get_rat_data_table_stats(rat_data_table);
%% Fig 1G
hum_new_tasks_runme;
%% SF1K,SF1L,SF1O,SF1T,SF1Y,SF2E,SF2F,SF2K,SF2L,SF2Q,SF2R,SF2W,SF2X,
david_runme;
%% FIG 1J: DISCRETE DECISION-Making STRATEGIES
table_of_human_dir = get_dirs_with_data(name_of_dir_with_newly_thresholded_data);
centers = [-8.4228 -2.9848e-06 -13.7845;
    -6.252 1.14615 0.136439;
    4.50766 5.22001 0.740335;
    3.57903, -16.7105, 1.37222;
    13.1213 9.77206 -1.31392];
call_FCM_for_all_human_data(table_of_human_dir,centers, "doesnt matter")

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
%% FIG 1K: Strategy Utilization Differs across tasks
create_heat_maps_for_chi_squared_significance(human_data_table,"heat map chi squared significance",0,0.052,human_stats_map,version_name)
%% FIG 2C: RAT DISCRETE DECISION STRATEGIES
home_dir = cd("rat sigmoid data created 04-15-2024");
cd("reward choice Sigmoid Data\");
rat_data_dir = string(cd(home_dir));
rat_centers = {[-9.19223 -0.160124 -5.94521; 0.0725309 9.26771 5.38323; -0.0750793 2.44644 4.20085; 7.26216 9.12042 2.84782; -1.0078 3.31472 6.58382; 8.22584 6.32504 6.05144 ]};
% rat_centers = {[]};
table_of_rat_data = table("rat_reward_choice",rat_data_dir,'VariableNames',["Task", "Data_Directory"]);
call_FCM_for_each_row_of_data_for_rat(table_of_rat_data,rat_centers,"doesn't matter");
%% Fig 2C: Average Sigmoid Per Cluster
raw_rat_psychometric_function_data = readtable(strcat(pwd,"\psych functions created 04-15-2024\Baseline reward_choice psychometric functions table.xlsx"));
create_avg_psych_2("session",1,"Average Sigmoid For Rat Cluster",rat_data_table,raw_rat_psychometric_function_data);

%% (NO LONGER USED) comparing the ys
% for i=1:5
%     for j=1:length(multiple_ys)
%         curr_something = multiple_ys{j};
%         curr_clust = curr_something(curr_something.cluster_number==i,:);
%         disp(strcat("Cluster ",string(i)," ",string(curr_clust.y1)," ",string(curr_clust.y2)," ",string(curr_clust.y3), " ",string(curr_clust.y4)))
% 
%     end
%     disp("///////////////////////////////")
% end
%% fig 3F
colors = distinguishable_colors(10);
create3d_cluster_plot("cluster_tables_for_rat_created_04_16_2024","rat_reward_choice",colors,"rat","Rat 3d Clustering","log(abs(max))","log(abs(shift))","log(abs(slope))","3d_cluster_plots",rat_stats_map,string(datetime("today",'Format','MM-d-yyyy')),version_name)

%% Fig 3G
only_aa_data = select_single_experiment_from_data_set_2(human_data_table,"approach_avoid");
create_human_to_rat_comparison_ver_4("rat_reward_choice.xlsx",only_aa_data,"cluster_tables_for_rat_created_04_16_2024",strcat("b_dist_plots_updated_4 Created On",string(datetime("today",'Format','MM-d-yyyy'))),colors,human_stats_map,rat_stats_map, string(datetime("today",'Format','MM-d-yyyy')),version_name);
%% SF3A create average sigmoid split by tasks, and by cluster
create_average_sigmoids_by_cluster_only = 0;
create_average_sigmoid_by_cluster_and_task = 1;
mkdir("average_sigmoids_version_2")
mkdir("average_sigmoids_3_version_2")
david_runme2
%% SF4G, SF4H, SF4I: Clusters across task have same location 
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

%% Supplemental Figure 4A-4F: Task Comparisons
compare_human_data_to_human_data_using_dg_for_sig(human_data_table,strcat("3d cluster plots human_to_human_comparison created on ",string(datetime("today",'Format','MM-d-yyyy'))),human_stats_map,version_name)

%% Supplemental Figure 4L: probability of cluster observation for each task
create_bar_plots_for_cluster_proportions(human_data_table,0,strcat("bar plot human cluster proportions created on",string(datetime("today",'Format','MM-d-yyyy'))),human_stats_map,version_name);

%% Supplemental Figure 4J: create heat map for mean all each row is a cluster and each column is an experiment comparison 
[map_of_bhaat_distance_permutations,map_of_mean_significance_permutations,map_of_variance_significance_permutations] = derive_bhaat_distance_permutations(human_data_table);
create_heat_maps_for_significance(map_of_mean_significance_permutations,"Significant Change In Means Determined using ttest2",unique(human_data_table.experiment),unique(human_data_table.cluster_number),strcat("heatmap mean cut down created on ",string(datetime("today",'Format','MM-d-yyyy'))),human_stats_map,version_name)
%% Supplemental Figure 4K: create heat map for variance all each row is a cluster and each column is an experiment comparison
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

%% Fig 2E: get food dep data
colors = distinguishable_colors(20);
rat_food_dep_data = return_given_cluster_table("food_deprivation_rat_reward_choice","cluster_tables_for_rat_food_deprivation_created_04_28_2024");
rat_food_dep_stats_map = get_rat_data_table_stats(rat_food_dep_data);
create3d_cluster_plot("cluster_tables_for_rat_food_deprivation_created_04_28_2024","food_deprivation_rat_reward_choice",colors,"rat","food deprivatin rat data","log(abs(max))","log(abs(shift))","log(abs(slope))","food deprivation 3d plot",rat_food_dep_stats_map,string(datetime("today",'Format','MM-d-yyyy')),"food deprivation")

%% split food dep data into 2 bins
rebin_individual_rats_cluster_info_2("cluster_tables_for_rat_food_deprivation_created_04_28_2024","Cluster Tables Rebinned Into 2 Bins",["Food Deprivation"],2)
%% run various permutations of meta data (hunger, tiredness, pain,and story_pref) to see if there's any significant differences between them
clc;
colors = distinguishable_colors(30);
run_permutations_based_on_meta_data_with_power_analysis(human_data_table, ...
    {appr_avoid_sessions,social_sessions,probability_sessions,moral_sessions}, ...
    ["approach_avoid","social","probability","moral"],colors,version_name,0.054,0.5, ...
    "3d Cluster Plots and Heat Maps Of Significant Changes With Power");

%% run various permutations of meta data (hunger, tiredness, pain, no story_pref) to see if there's any significant differences between them
clc;
colors = distinguishable_colors(30);
run_permutations_based_on_meta_data_no_story_pref(human_data_table, ...
    {appr_avoid_sessions,social_sessions,probability_sessions,moral_sessions}, ...
    ["approach_avoid","social","probability","moral"],colors,version_name,0.05,0.5, ...
    "3d Cluster Plots and Heat Maps Of Significant Changes No Story Pref Ver 2");

%% check to see if hunger and gender causes any significant differences by itself (also runs different levels of story_pref incremented by 10)
clc;
colors = distinguishable_colors(30);
filter_based_on_individual_meta_data_with_power_analysis(human_data_table, ...
    {appr_avoid_sessions,social_sessions,probability_sessions,moral_sessions}, ...
    ["approach_avoid","social","probability","moral"],colors,version_name,0.054,0.5, ...
    "3d Cluster Plots and heat Maps of Significant Changes Hunger Ver 3","average_hunger");
%% check to see if tiredness causes any significant differences by itself (also runs different levels of story_pref incremented by 10)
clc;
colors = distinguishable_colors(30);
filter_based_on_individual_meta_data(human_data_table, ...
    {appr_avoid_sessions,social_sessions,probability_sessions,moral_sessions}, ...
    ["approach_avoid","social","probability","moral"],colors,version_name,0.054,0.5, ...
    "3d Cluster Plots and heat Maps of Significant Changes Tiredness Ver 2","tiredness");
%% check to see if tiredness and gender causes any significant differences together (also runs different levels of story_pref incremented by 10)
clc;
colors = distinguishable_colors(30);
filter_based_on_individual_meta_data_with_power_analysis(human_data_table, ...
    {appr_avoid_sessions,social_sessions,probability_sessions,moral_sessions}, ...
    ["approach_avoid","social","probability","moral"],colors,version_name,0.054,0.5, ...
    "3d Cluster Plots and heat Maps of Significant Changes Tiredness Ver 3","tiredness");

%% check to see if pain and gender causes any significant differences together (also runs different levels of story_pref incremented by 10)
clc;
colors = distinguishable_colors(30);
filter_based_on_individual_meta_data_with_power_analysis(human_data_table, ...
    {appr_avoid_sessions,social_sessions,probability_sessions,moral_sessions}, ...
    ["approach_avoid","social","probability","moral"],colors,version_name,0.054,0.5, ...
    "3d Cluster Plots and heat Maps of Significant Changes Pain Ver 3","pain");
%% check to see if pain causes any significant differences by itself(also runs different levels of story_pref incremented by 10)
clc;
colors = distinguishable_colors(30);
filter_based_on_individual_meta_data(human_data_table, ...
    {appr_avoid_sessions,social_sessions,probability_sessions,moral_sessions}, ...
    ["approach_avoid","social","probability","moral"],colors,version_name,0.054,0.5, ...
    "3d Cluster Plots and heat Maps of Significant Changes Pain Ver 2","pain");
%% check to see if gender and pain causes any significant differences together(also runs different levels of story_pref incremented by 10)
clc;
colors = distinguishable_colors(30);
filter_based_on_individual_meta_data_and_gender(human_data_table, ...
    {appr_avoid_sessions,social_sessions,probability_sessions,moral_sessions}, ...
    ["approach_avoid","social","probability","moral"],colors,version_name,0.054,0.5, ...
    "3d Cluster Plots and heat Maps of Significant Changes Pain And Gender","pain");

%% check to see if gender and hunger causes any significant differences together(also runs different levels of story_pref incremented by 10)
clc;
colors = distinguishable_colors(30);
filter_based_on_individual_meta_data_and_gender(human_data_table, ...
    {appr_avoid_sessions,social_sessions,probability_sessions,moral_sessions}, ...
    ["approach_avoid","social","probability","moral"],colors,version_name,0.054,0.5, ...
    "3d Cluster Plots and heat Maps of Significant Changes Hunger And Gender","average_hunger");
%% check to see if gender and tiredness causes any significant differences together(also runs different levels of story_pref incremented by 10)
clc;
colors = distinguishable_colors(30);
filter_based_on_individual_meta_data_and_gender(human_data_table, ...
    {appr_avoid_sessions,social_sessions,probability_sessions,moral_sessions}, ...
    ["approach_avoid","social","probability","moral"],colors,version_name,0.054,0.5, ...
    "3d Cluster Plots and heat Maps of Significant Changes Tiredness And Gender","tiredness");

%% check to see if age range and tiredness causes any significant differences together(also runs different levels of story_pref incremented by 10)
clc;
colors = distinguishable_colors(30);
filter_based_on_individual_meta_data_and_age_range(human_data_table, ...
    {appr_avoid_sessions,social_sessions,probability_sessions,moral_sessions}, ...
    ["approach_avoid","social","probability","moral"],colors,version_name,0.054,0.5, ...
    "3d Cluster Plots and heat Maps of Significant Changes Tiredness And Age Range","tiredness");
%% check to see if age range and hunger causes any significant differences together(also runs different levels of story_pref incremented by 10)
clc;
colors = distinguishable_colors(30);
filter_based_on_individual_meta_data_and_age_range(human_data_table, ...
    {appr_avoid_sessions,social_sessions,probability_sessions,moral_sessions}, ...
    ["approach_avoid","social","probability","moral"],colors,version_name,0.054,0.5, ...
    "3d Cluster Plots and heat Maps of Significant Changes Hunger And Age Range","average_hunger");

%% check to see if age range and pain causes any significant differences together(also runs different levels of story_pref incremented by 10)
clc;
colors = distinguishable_colors(30);
filter_based_on_individual_meta_data_and_age_range(human_data_table, ...
    {appr_avoid_sessions,social_sessions,probability_sessions,moral_sessions}, ...
    ["approach_avoid","social","probability","moral"],colors,version_name,0.054,0.5, ...
    "3d Cluster Plots and heat Maps of Significant Changes Pain And Age Range","pain");
%% Supplemental Figure 3E: cluster locations significantly differ
% get bhaatycharya distance between clusters, do not distinguish between tasks
clc;
[bhaat_distance_permutations_not_split_by_task,~,~] = derive_bhaat_distance_permutations_dont_split_by_task(human_data_table);
create_heat_maps_from_permutations_without_splitting(bhaat_distance_permutations_not_split_by_task,"Heat Map Not Split By Task", version_name,human_data_table,"bhat distance",human_stats_map);
%% Supplemental Figure 3F: means
% get mean between clusters, do not distinguish between tasks
[~,mean_permutations_not_split_by_task,~] = derive_bhaat_distance_permutations_dont_split_by_task(human_data_table);
create_heat_maps_from_permutations_without_splitting(mean_permutations_not_split_by_task,"Heat Map Not Split By Task", version_name,human_data_table,"mean",human_stats_map);
%% Supplemental Figure 3G: variancecs
% get variancec between clusters, do not distinguish between tasks
[bhaat_distance_permutations_not_split_by_task,mean_permutations_not_split_by_task,variance_permutations_not_split_by_task] = derive_bhaat_distance_permutations_dont_split_by_task(human_data_table);
create_heat_maps_from_permutations_without_splitting(variance_permutations_not_split_by_task,"Heat Map Not Split By Task", version_name,human_data_table,"variance",human_stats_map);
%% get normalized comparison between rat and human clusters
colors = distinguishable_colors(30);
only_aa_data = select_single_experiment_from_data_set_2(human_data_table,"approach_avoid");
normalized_human_to_rat_comparison("rat_reward_choice.xlsx",only_aa_data,"cluster_tables_for_rat_created_04_16_2024","b_dist_plots_updated_3",colors,human_stats_map,rat_stats_map, string(datetime("today",'Format','MM-d-yyyy')),version_name)

%% Supplemental Figure 6A: rat vs human decision-making largely differs 
% get normalized comparison between rat and human clusters, consolidated on single plot 
colors = distinguishable_colors(30);
only_aa_data = select_single_experiment_from_data_set_2(human_data_table,"approach_avoid");
normalized_human_to_rat_comparison_single_plot("rat_reward_choice.xlsx",only_aa_data,"cluster_tables_for_rat_created_04_16_2024","3d cluster plot rat to human comparison",colors,human_stats_map,rat_stats_map, string(datetime("today",'Format','MM-d-yyyy')),version_name,1)
normalized_human_to_rat_comparison_single_plot("rat_reward_choice.xlsx",only_aa_data,"cluster_tables_for_rat_created_04_16_2024","3d cluster plot rat to human comparison",colors,human_stats_map,rat_stats_map, string(datetime("today",'Format','MM-d-yyyy')),version_name,0)

%% Supplemental Figure 2B: rat 1,3,4 overlap human 2,3,5
% get normalized and non normalized bhaat heat map comparing human to rat data
only_aa_data = select_single_experiment_from_data_set_2(human_data_table,"approach_avoid");
get_bhat_dist_heat_map_comparing_rat_to_human(only_aa_data,rat_data_table,1,"heat map human to rat Comparison",rat_stats_map,human_stats_map,version_name,1)
get_bhat_dist_heat_map_comparing_rat_to_human(only_aa_data,rat_data_table,0,"heat map human to rat Comparison",rat_stats_map,human_stats_map,version_name,1)

%% Supplemental Figures 6G, 6H 
% compare to see if there's any significant difference between rat hunger between genders
% compare_genders_for_rat_data(rat_food_dep_data,rat_food_dep_stats_map,1,"Rat Gender Food Preferences",version_name);
compare_genders_for_rat_data(rat_food_dep_data,rat_food_dep_stats_map,0,"Rat Gender Food Preferences No Power Analysis",version_name);

%% compare to see if there's any significant difference between rat data baseline
% compare_genders_for_rat_data(rat_data_table,rat_stats_map,1,"Rat Gender Baseline",version_name);
compare_genders_for_rat_data(rat_data_table,rat_stats_map,0,"Rat Gender Baseline No Power Analysis",version_name);

%% get a table with all different meta data permutations
do_gender_or_dont = [0 1];
do_power_analysis_or_dont = [0,1];
all_meta_data_to_use = ["average_hunger","tiredness","pain"];

a_bunch_of_permutations = cell(1,10);
only_significant_a_bunch_of_permutations = cell(1,10);
permutation_data = [];
only_significant_permutation_data = [];
for gender_counter = 1:length(do_gender_or_dont)
    do_gender = do_gender_or_dont(gender_counter);
    for power_analysis_counter = 1:length(do_power_analysis_or_dont)
        do_power_analysis = do_power_analysis_or_dont(power_analysis_counter);
        for meta_data_counter =1:length(all_meta_data_to_use)
            meta_data = all_meta_data_to_use(meta_data_counter);
            new_data = filt_based_on_indiv_meta_data_with_power_analysis_return_table(human_data_table, ...
                {appr_avoid_sessions,social_sessions,probability_sessions,moral_sessions}, ...
                ["approach_avoid","social","probability","moral"], ...
                distinguishable_colors(30), ...
                version_name, ...
                0.054,0.5,"Table of Permutations",meta_data,do_power_analysis,do_gender);
            permutation_data = [permutation_data;new_data];
            only_significant_permutation_data = [only_significant_permutation_data;new_data(new_data.Significant==true,:)];
        end
    end
end


%% create histograms to measure the affect of differences between upper and lower half
clc;
do_gender_or_dont = [0 1];
do_power_analysis_or_dont = [0 1];
all_meta_data_to_use = ["average_hunger","tiredness","pain"];
do_significant_differences_or_dont = [0 1];


container_of_diff_tables = containers.Map('KeyType','char','ValueType','any');
container_of_significance_by_gender_upper = containers.Map('KeyType','char','ValueType','any');
container_of_significance_by_gender_lower = containers.Map('KeyType','char','ValueType','any');
container_of_significance_by_upper_and_lower = containers.Map('KeyType','char','ValueType','any');
container_of_male_significance_upper_and_lower = containers.Map('KeyType','char','ValueType','any');
container_of_female_significance_upper_and_lower = containers.Map('KeyType','char','ValueType','any');
make_example_plots = false;
for sig_diff_counter=1:length(do_significant_differences_or_dont)
    do_sig_diff = do_significant_differences_or_dont(sig_diff_counter);
    for gender_counter = 1:length(do_gender_or_dont)
        do_gender = do_gender_or_dont(gender_counter);
        for power_analysis_counter = 1:length(do_power_analysis_or_dont)
            do_power_analysis = do_power_analysis_or_dont(power_analysis_counter);
            for meta_data_counter =1:length(all_meta_data_to_use)
                meta_data = all_meta_data_to_use(meta_data_counter);
                surrounding_directory_string = strcat(meta_data," Ver 4");
                if do_power_analysis
                    surrounding_directory_string = surrounding_directory_string + " Cut to Fit Smaller";
                else
                    surrounding_directory_string = surrounding_directory_string + " Without Cut To Fit Smaller";
                end
                if do_gender
                    surrounding_directory_string = surrounding_directory_string + " With Gender";
                else
                    surrounding_directory_string = surrounding_directory_string + " Without Gender";
                end
                if do_sig_diff
                    surrounding_directory_string = surrounding_directory_string + " With Significance Check";
                else
                    surrounding_directory_string = surrounding_directory_string + " Without Significance Check";
                end

                
                [diff_table,array_of_significance_based_on_gender_upper,array_of_significance_based_on_gender_lower,array_of_significance_based_on_upper_and_lower,array_of_significance_for_male,array_of_significance_for_female,table_with_hunger] = compare_male_and_female_add_magnitude(human_data_table, ...
                    {appr_avoid_sessions,social_sessions,probability_sessions,moral_sessions}, ...
                    ["approach_avoid","social","probability","moral"], ...
                    distinguishable_colors(30), ...
                    version_name, ...
                    0.054,0.5,surrounding_directory_string,meta_data,do_power_analysis,do_gender,true,do_sig_diff,make_example_plots);

                container_of_diff_tables(surrounding_directory_string) = diff_table;
                container_of_significance_by_gender_upper(surrounding_directory_string + " Upper Male Vs Female")=array_of_significance_based_on_gender_upper;
                container_of_significance_by_gender_lower(surrounding_directory_string + " Lower Male Vs Female") = array_of_significance_based_on_gender_lower;
                container_of_male_significance_upper_and_lower(surrounding_directory_string + " Upper Vs Lower Male") = array_of_significance_for_male;
                container_of_female_significance_upper_and_lower(surrounding_directory_string + " Upper Vs Lower Female") = array_of_significance_for_female;

                container_of_significance_by_upper_and_lower(surrounding_directory_string + " Mixed Gender Upper Vs Lower") = array_of_significance_based_on_upper_and_lower;
            end
        end
    end
end



%% create heat maps
close all;
clc;
array_of_containers = {container_of_significance_by_upper_and_lower,container_of_significance_by_gender_upper,container_of_significance_by_gender_lower};
create_heatmap_based_off_of_chi_squared_significance_arrays(array_of_containers,"Heat Maps For Various Distributions");

%% create heat maps for the female upper lower bound vs male upper/lower bound
close all;
array_of_containers = {container_of_female_significance_upper_and_lower, container_of_male_significance_upper_and_lower};
create_heatmap_based_off_of_chi_squared_significance_arrays(array_of_containers,"Heat Maps For Upper Vs Lower Male And Female Ver 2",1);

%% Supplemental Figures 6C, 6D Sex Differences in human clusters do exist 
% get 3d example of male vs female
% compare_male_and_female_without_meta_data(human_data_table,{appr_avoid_sessions,social_sessions,probability_sessions,moral_sessions},["approach_avoid","social","probability","moral"],1,0,"3d plot Male Vs Female")
compare_male_and_female_without_meta_data(human_data_table,{appr_avoid_sessions,social_sessions,probability_sessions,moral_sessions},["approach_avoid","social","probability","moral"],0,0,"3d plot Male Vs Female")
%% find best representative example
key_used ='pain Ver 4 With Power Analysis Without Gender Without Significance Check' ;
[pain_biggest_decrease_in_cluster_5_no_gender,~] = find_best_representative_example(key_used,container_of_diff_tables(key_used),5,"decrease",0,50);
[pain_biggest_increase_in_cluster_3_no_gender,~] = find_best_representative_example(key_used,container_of_diff_tables(key_used),3,"increase",0,50);
%% select and save specific example
clc;
create_and_save_specified_example(pain_biggest_decrease_in_cluster_5_no_gender,key_used,table_with_hunger,"Representative 3d Cluster Plots",version_name)
% create_and_save_specified_example(pain_biggest_increase_in_cluster_3_no_gender,key_used,table_with_hunger,"Representative 3d Cluster Plots",version_name)

%% look at male and female proportions when you split by task and get a heat map if it's significantly different
clc;
compare_male_and_female_without_meta_data(human_data_table,{appr_avoid_sessions,social_sessions,probability_sessions,moral_sessions},["approach_avoid","social","probability","moral"],1,1,"Heat Map For Power Analysis Split By Gender and Task");
compare_male_and_female_without_meta_data(human_data_table,{appr_avoid_sessions,social_sessions,probability_sessions,moral_sessions},["approach_avoid","social","probability","moral"],0,1,"Heat Map For Power Analysis Split By Gender and Task");

%% Fig 2F: create a male and female first column heat map 
clc;
create_heatmap_for_male_vs_female_tiredness(container_of_male_significance_upper_and_lower,container_of_female_significance_upper_and_lower,"Two Column Heat Maps With Gender Differences",1)

%% compare male/female baseline and food deprived with and without power analysis
clc;
compare_rat_food_dep_to_baseline_split_by_gender(rat_data_table,rat_food_dep_data,"Male and Female Rat Dot Plots",0,version_name)
compare_rat_food_dep_to_baseline_split_by_gender(rat_data_table,rat_food_dep_data,"Male and Female Rat Dot Plots",1,version_name)