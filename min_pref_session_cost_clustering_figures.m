%% add the Utility functions to my path
cd("Utility Functions\")
addpath(pwd)
cd("..")
version_name = "min_pref_session_cost_clustering";
%% run fcm for human data (session cost clustering) 
table_of_human_dir = get_dirs_with_data("min_pref_session_cost_clustering");
 centers = [-8.37419 -6.852234e-06 -13.7783;
    -6.38284 0.487881 -0.717614;
    3.55733 -17.1863 1.38514
    0 2.24833 -0.571645;
    2.49831 -0.286583 -2.1873;
    4.23446 3.76109 1.05382;
    3.78414 10.7322 2.43289;
    8.02055 13.1098 0.657097;
    12.72 11.0228 -0.944297];
% call_FCM_for_all_human_data(table_of_human_dir,centers, strcat("Cluster Table For min_pref_session_cost_clustering created on ",string(datetime("today",'Format','MM-d-yyyy'))))
%% Used just to get plot, don't refer to this 
call_FCM_for_all_human_data(table_of_human_dir,centers,"doesnt matter")

%% put rat and human data into a table to be used
rat_data_table = return_given_cluster_table("rat_reward_choice.xlsx","cluster_tables_for_rat_created_04_16_2024");
human_data_table = return_given_cluster_table("all human data.xlsx","Cluster Table For min_pref_session_cost_clustering created on 05-6-2024");

%% get human data information (ie. # of subjects, # of data points )
human_stats_map = get_human_data_table_stats(human_data_table);
rat_stats_map = get_rat_data_table_stats(rat_data_table);
%% create plots which compare rat clusters to human clusters
only_aa_data = select_single_experiment_from_data_set_2(human_data_table,"approach_avoid");

%% create bhaat distance plots comparing rat to human new data, taking the average of the 3 bhaat distance instead of 1 bhaat distance for each dimension
colors = distinguishable_colors(30);
create_human_to_rat_comparison_ver_3("rat_reward_choice.xlsx",only_aa_data,"cluster_tables_for_rat_created_04_16_2024","b_dist_plots_updated_3",colors,human_stats_map,rat_stats_map, string(datetime("today",'Format','MM-d-yyyy')),version_name)

%% create bhaat distance plots comparing rat to human new data, taking the average of the 3 bhaat distance instead of 1 bhaat distance for each plot, all on one plot instead
close all;
create_human_to_rat_comparison_ver_4("rat_reward_choice.xlsx",only_aa_data,"cluster_tables_for_rat_created_04_16_2024","b_dist_plots_updated_4",colors,human_stats_map,rat_stats_map, string(datetime("today",'Format','MM-d-yyyy')),version_name);
%% create bhaat distance graph
create_a_bhaat_distance_tree(human_data_table,"bhaat_distance_tree_graph",human_stats_map,"Sessions","All Human Data",version_name);
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