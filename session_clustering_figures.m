%% add the Utility functions to my path
cd("Utility Functions\")
addpath(pwd)
cd("..")
version_name = "session_clustering";
%% run fcm for human data (session_clustering) given by lara on 04/30/2024 PERFORMS IT ON SESSION LEVEL
table_of_human_dir = get_dirs_with_data("session_clustering");
% centers = [-7.95484 -0.2253 -13.3709;
%     3.83399 10.0293 2.36265;
%     3.90476 2.47576 0.328242;
%     2.4325 -0.657053 -2.12422;
%     12.4931 10.63 -1.04503
%     3.71879 -16.3966 1.35765];
% call_FCM_for_all_human_data(table_of_human_dir,centers, strcat("Cluster Table For session_clustering created on ",string(datetime("today",'Format','MM-d-yyyy'))))
%% Used just to get plot, don't refer to this 
centers = [-7.95484 -0.2253 -13.3709;
    3.83399 10.0293 2.36265;
    3.90476 2.47576 0.328242;
    2.4325 -0.657053 -2.12422;
    12.4931 10.63 -1.04503
    3.71879 -16.3966 1.35765];

% call_FCM_for_all_human_data(table_of_human_dir,centers,"doesnt matter")

%% put rat and human data into a table to be used
rat_data_table = return_given_cluster_table("rat_reward_choice.xlsx","cluster_tables_for_rat_created_04_16_2024");
human_data_table = return_given_cluster_table("all human data.xlsx","Cluster Table For session_clustering created on 05-2-2024");

%% get human data information (ie. # of subjects, # of data points )
human_stats_map = get_human_data_table_stats(human_data_table);
rat_stats_map = get_rat_data_table_stats(rat_data_table);
%% create plots which compare rat clusters to human clusters
only_aa_data = select_single_experiment_from_data_set_2(human_data_table,"approach_avoid");

%% create bhaat distance plots comparing rat to human new data, taking the average of the 3 bhaat distance instead of 1 bhaat distance for each dimension
colors = distinguishable_colors(30);
create_human_to_rat_comparison_ver_3("rat_reward_choice.xlsx",only_aa_data,"cluster_tables_for_rat_created_04_16_2024","b_dist_plots_updated_3",colors,human_stats_map,rat_stats_map, string(datetime("today",'Format','MM-d-yyyy')),version_name)

%% create bhaat distance plots comparing rat to human new data, taking the average of the 3 bhaat distance instaead of 1 bhaat distance for each plot, all on one plot instead
close all;
create_human_to_rat_comparison_ver_4("rat_reward_choice.xlsx",only_aa_data,"cluster_tables_for_rat_created_04_16_2024","b_dist_plots_updated_4",colors,human_stats_map,rat_stats_map, string(datetime("today",'Format','MM-d-yyyy')),version_name);
%% create bhaat distance graph
close all;
create_a_bhaat_distance_tree(human_data_table,"bhaat_distance_tree_graph ",human_stats_map,"Sessions","All Human Data",version_name);
create_a_bhaat_distance_tree_for_rat(rat_data_table,"bhaat_distance_tree_graph" ,rat_stats_map,"Sessions","all Rat Data",version_name);
create_a_bhaat_dist_tree_comparing_rat_to_human(only_aa_data,human_stats_map,rat_data_table,rat_stats_map,version_name,"bhaat_distance_tree_graph_human_to_rat","Mean Bhaatycharya Distance Map ")
create_a_bhaat_dist_tree_comparing_rat_to_human_ver_2(only_aa_data,human_stats_map,rat_data_table,rat_stats_map,version_name,"bhaat_distance_tree_graph_human_to_rat_version_2","Mean Bhaatycharya Distance Map ")
create_a_bhaat_dist_tree_comparing_human_to_human(human_data_table,human_stats_map,version_name,"bhaat_distance_tree_graph_human_to_human","Mean bhaatycharya Distance Map ",1)
create_a_bhaat_dist_tree_comparing_human_to_human(human_data_table,human_stats_map,version_name,"bhaat_distance_tree_graph_human_to_human","Mean bhaatycharya Distance Map ",0)

%% create 3d rat and human cluster plots
%% create 3d rat and human cluster plots
colors = distinguishable_colors(10);
create3d_cluster_plot("cluster_tables_for_rat_created_04_16_2024","rat_reward_choice",colors,"rat","Rat 3d Clustering","log(abs(max))","log(abs(shift))","log(abs(slope))","3d_cluster_plots",rat_stats_map,string(datetime("today",'Format','MM-d-yyyy')),version_name)
create3d_cluster_plot_for_human(human_data_table,colors,"human","human 3d Clustering","log(abs(max))","log(abs(shift))","log(abs(slope))","3d_cluster_plots",human_stats_map,string(datetime("today",'Format','MM-d-yyyy')),version_name)
%% create mean bhaat distance plot for rat and human data individually
create_bhaat_distance_mean_plots_for_single_data_type(rat_data_table,colors,"rat","Rat Bhaatycharrya distance Plots","b_dist_plots individual",rat_stats_map("Number Of Unique Subjects"),rat_stats_map('Number of Data Points'),string(datetime("today",'Format','MM-d-yyyy')),version_name)
create_bhaat_distance_mean_plots_for_single_data_type(human_data_table,colors,"human","Human Bhaatycharrya distance Plots","b_dist_plots individual",human_stats_map("Number of Unique Subjects in all human data"),height(human_data_table),string(datetime("today",'Format','MM-d-yyyy')),version_name)

%% create overlain spider plots with dg_significance
create_spider_plots_with_sig_using_dg(human_data_table,"spider plots using dg for significance",human_stats_map,version_name)
% concatenate_many_plots("Spider plots using dg for significance","spider plots using dg for significance.pdf","ALL PDFS")

%% checking for significance using chi2test
clc;
sig_from_chi2test = create_cluster_counts_for_data_using_chi2test(human_data_table,"doesntmatter");
disp("//////////////////////////////////")
%% checking for significance using dan gibson
% clc;
sig_from_dg_chi2test = measure_significance_between_tasks_using_dg(human_data_table,"doesntmatter");
comparison_table = table(string(keys(sig_from_dg_chi2test).'),cell2mat(values(sig_from_dg_chi2test).'),cell2mat(values(sig_from_chi2test).'),'VariableNames',{'Story Comparison','p-value from chi2test','p-value from dg_chi2test'});

%% compare human task to each other, and add significance of comparison 
compare_human_data_to_human_data_using_dg_for_sig(human_data_table,"3d cluster plots human_to_human_comparison",human_stats_map,version_name)
% concatenate_many_plots("3d cluster plots human_to_human_comparison","3d cluster plots human_to_human_comparison.pdf","ALL PDFS")

%% create bhaat distance comparing human experiments to each other
close all;
clc;
colors = distinguishable_colors(20);
create_bhaat_dist_plts_comparing_human_exp_to_eachother(human_data_table,"b_dist_plots comparing human experiments to each other",colors,human_stats_map,version_name);

%% get map of all bhaat_distance permutations
[map_of_bhaat_distance_permutations,map_of_mean_significance_permutations,map_of_variance_significance_permutations] = derive_bhaat_distance_permutations(human_data_table);
 
%% create heat map of all bhat distance
close all;
clc;
[bhaat_dist_x_matrix,x_y_ticks] = create_heat_map_from_map_of_permutations(human_data_table,map_of_bhaat_distance_permutations,"heat maps bhaat distance",1,0,"All Clusters Bhaat Distance Permutations",NaN,human_stats_map,version_name);
[bhaat_dist_y_matrix,x_y_ticks] = create_heat_map_from_map_of_permutations(human_data_table,map_of_bhaat_distance_permutations,"heat maps bhaat distance",2,0,"All Clusters Bhaat Distance Permutations",NaN,human_stats_map,version_name);
[bhaat_dist_z_matrix,x_y_ticks] = create_heat_map_from_map_of_permutations(human_data_table,map_of_bhaat_distance_permutations,"heat maps bhaat distance",3,0,"All Clusters Bhaat Distance Permutations",NaN,human_stats_map,version_name);
[bhaat_dist_mean_matrix,x_y_ticks] = create_heat_map_from_map_of_permutations(human_data_table,map_of_bhaat_distance_permutations,"heat maps bhaat distance",NaN,0,"All Clusters Bhaat Distance Permutations",NaN,human_stats_map,version_name);
%%
concatenate_many_plots_updated("heat maps bhaat distance","heat maps bhaat distance.pdf","ALL PDFS")

%% create chi squared significance permutations (Fig 1L)
create_heat_maps_for_chi_squared_significance(human_data_table,"heat map chi squared significance",1,0.05,human_stats_map,version_name)

%% create updated heat maps for bhaat distance with clim([0,1])
clc;
mask_given_data_and_create_heat_map([],bhaat_dist_x_matrix,"heat map bhaat distance alexanders updates",x_y_ticks,"bhaat distance of log(abs(max))",'%.1f',human_stats_map,version_name)
mask_given_data_and_create_heat_map([],bhaat_dist_y_matrix,"heat map bhaat distance alexanders updates",x_y_ticks,"bhaat distance of log(abs(shift))",'%.1f',human_stats_map,version_name)
mask_given_data_and_create_heat_map([],bhaat_dist_z_matrix,"heat map bhaat distance alexanders updates",x_y_ticks,"bhaat distance of log(abs(slope))",'%.1f',human_stats_map,version_name)

%% create heat map for mean all each row is a cluster and each column is an experiment comparison
create_heat_maps_for_significance(map_of_mean_significance_permutations,"Significant Change In Means Determined using ttest2",unique(human_data_table.experiment),unique(human_data_table.cluster_number),"heatmap mean cut down",human_stats_map,version_name)
%% create heat map for mean all each row is a cluster and each column is an experiment comparison
create_heat_maps_for_significance(map_of_variance_significance_permutations,"Significant Change In Variances using vartest2",unique(human_data_table.experiment),unique(human_data_table.cluster_number),"heatmap variance cut down",human_stats_map,version_name)

%% creaate bar plots showing cluster ratios
create_bar_plots_for_cluster_proportions(human_data_table,0,"bar plot human cluster proportions",human_stats_map,version_name);

%% get average xyz plots for different human experiments
% clc;
% close all;
C = ['r','g','b','c'];
get_average_xyz_per_human_experiment_using_spectral_table(human_data_table,C,"average xyz plot all data",human_stats_map,version_name)
%% recreate average xyz, using a subset of data instead of all data, but keeping proportions the same
% clc;
figure;
C = ['r','g','b','c'];
proportions_to_match = get_cluster_counts_2(human_data_table,unique(human_data_table.experiment),unique(human_data_table.cluster_number),1);
% disp([keys(proportions_to_match).',values(proportions_to_match).'])
run_average_sigmoids_n_times(human_data_table,cell2mat(values(proportions_to_match).'),1000,1,1,C,"Average XYZ plot recreated from proportional subsets","Average Sigmoid Experiment 2",human_stats_map,version_name)

%% recreate average xyz plots using explicitly wrong proportions
% clc;
C = ['r','g','b','c'];
proportions_to_match = get_cluster_counts_2(human_data_table,unique(human_data_table.experiment),unique(human_data_table.cluster_number),1);
% disp([keys(proportions_to_match).',values(proportions_to_match).'])
recreate_average_xyz_using_different_proportions(human_data_table,cell2mat(values(proportions_to_match).'),1000,1,1,C,"Average XYZ plot recreated from incorrect proportional subsets","Average Sigmoid Experiment 2",human_stats_map,version_name)
close all;

%% recreate average xyz, using weighted mean of each cluster instead of mean of all data
clc;
C = ['r','g','b','c'];
proportions_to_match = get_cluster_counts_2(human_data_table,unique(human_data_table.experiment),unique(human_data_table.cluster_number),1);
get_average_xyz_per_human_experiment_using_table_and_weights_2(human_data_table,C,"average xyz plot using weighted averages",human_stats_map,proportions_to_match,version_name);

%% try to recreate xyz using data which is not significantly different data from each task
clc;
C = ['r','g','b','c'];
proportions_to_match = get_cluster_counts_2(human_data_table,unique(human_data_table.experiment),unique(human_data_table.cluster_number),1);
get_average_xyz_per_human_exp_using_non_sig_diff_data(human_data_table, C,strcat("average xyz recreated with non sig diff data created on",string(datetime("today",'Format','MM-d-yyyy'))),human_stats_map,proportions_to_match,map_of_mean_significance_permutations,version_name)