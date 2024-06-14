%% add the Utility functions to my path
cd("Utility Functions\")
addpath(pwd)
cd("..")
version_name = "sessions";

%% Get all absolute directories of human data
table_of_human_dir = get_dirs_with_data("sessions");
%% creating rat data from scratch and reading it into file (this part shouldn't be rerun because it takes a long time to run)
% getting_rat_data; 
% home_dir = cd(strcat("rat sigmoid data created ",string(datetime("today",'Format','MM-dd-yyyy'))));
% cd("reward choice Sigmoid Data\")
% rat_data_dir = string(cd(home_dir));
%% FINAL RAT CLUSTERING CONFIGURATION, DO NOT RUN AGAIN unless there's more data to be analyzed
% home_dir = cd("rat sigmoid data created 04-15-2024");
% cd("reward choice Sigmoid Data\");
% rat_data_dir = string(cd(home_dir));
% rat_centers = {[-9.19223 -0.160124 -5.94521; 0.0725309 9.26771 5.38323; -0.0750793 2.44644 4.20085; 7.26216 9.12042 2.84782; -1.0078 3.31472 6.58382; 8.22584 6.32504 6.05144 ]};
% % rat_centers = {[]};
% table_of_rat_data = table("rat_reward_choice",rat_data_dir,'VariableNames',["Task", "Data_Directory"]);
% call_FCM_for_each_row_of_data_for_rat(table_of_rat_data,rat_centers,"cluster_tables_for_rat_created_04_16_2024");

%% Final Human Clustering Configuration DO NOT RUN AGAIN 
% centers = [-8.37419 -6.852234e-06 -13.7783;
%     -6.38284 0.487881 -0.717614;
%     0 -0.0258518 -5.53169;
%     0 2.24833 -0.571645;
%     2.49831 -0.286583 -2.1873;
%     4.23446 3.76109 1.05382;
%     3.78414 10.7322 2.43289;
%     8.02055 13.1098 0.657097;
%     12.72 11.0228 -0.944297];
% 
% call_FCM_for_all_human_data(table_of_human_dir,centers,"correct human clusters")
%% Used just to get plot, don't refer to this 
centers = [-8.37419 -6.852234e-06 -13.7783;
    -6.38284 0.487881 -0.717614;
    0 -0.0258518 -5.53169;
    0 2.24833 -0.571645;
    2.49831 -0.286583 -2.1873;
    4.23446 3.76109 1.05382;
    3.78414 10.7322 2.43289;
    8.02055 13.1098 0.657097;
    12.72 11.0228 -0.944297];

call_FCM_for_all_human_data(table_of_human_dir,centers,"doesnt matter")
%% Used to get mpc for rat clustering, dont refer to this 
% home_dir = cd("rat sigmoid data created 04-15-2024");
% cd("reward choice Sigmoid Data\");
% rat_data_dir = string(cd(home_dir));
% rat_centers = {[-9.19223 -0.160124 -5.94521; 0.0725309 9.26771 5.38323; -0.0750793 2.44644 4.20085; 7.26216 9.12042 2.84782 ]};
% % rat_centers = {[]};
% table_of_rat_data = table("rat_reward_choice",rat_data_dir,'VariableNames',["Task", "Data_Directory"]);
% call_FCM_for_each_row_of_data_for_rat(table_of_rat_data,rat_centers,"doesnt matter");

%% put rat and human data into a table to be used
rat_data_table = return_given_cluster_table("rat_reward_choice.xlsx","cluster_tables_for_rat_created_04_16_2024");
human_data_table = return_given_cluster_table("all human data.xlsx","correct human clusters");

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
% create_bar_plots_for_cluster_proportions(human_data_table,1,"doesnt matter");
create_bar_plots_for_cluster_proportions(human_data_table,0,"bar plot human cluster proportions",human_stats_map,version_name);
%% get average rat cluster sigmoids % do not run again as random start points will create varying sigmoids
% raw_rat_psychometric_function_data = readtable(strcat(pwd,"\psych functions created 04-15-2024\Baseline reward_choice psychometric functions table.xlsx"));
% create_avg_psych_2("session",1,"Average Sigmoid For Rat Cluster",rat_data_table,raw_rat_psychometric_function_data);

%% create an average sigmoid for per experiment set and average sigmoid per cluster of experiment
% mkdir("average_sigmoids")
% mkdir("average_sigmoids_3")
% david_runme2;

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
%% create dec making maps with dec making boundaries for individuals
david_runme;
%% create average dec making maps with boundaries for tasks
hum_new_tasks_runme;
%% (NO LONGER USED) FINAL RAT CLUSTERING CONFIGURATION DO NOT RUN AGAIN run 3d fcm analysis for rat reward choice data
% cd("reward_choice Sigmoid Data\");
% rat_data_dir = string(cd(".."));
% rat_centers = {[-9.19223 -0.160124 -5.94521; 0.0725309 9.26771 5.38323; -0.0750793 2.44644 4.20085; 7.26216 9.12042 2.84782 ]};
% % rat_centers = {[]};
% table_of_rat_data = table("rat_reward_choice",rat_data_dir,'VariableNames',["Task", "Data_Directory"]);
% call_FCM_for_each_row_of_data_for_rat(table_of_rat_data,rat_centers,"cluster_tables_for_rat");

%% NO LONGER USED just run fcm on human data without predefined clusters
% call_FCM_for_each_row_of_data(table_of_human_dir,[],"fcm cluster tables no predefined centers")
%% NO LONGER USED run fcm on each data set in table_of_human_dir, give it some predefined centers (no longer used)
% human_centers = {[-10.5293 -1.50034e-06 -15.4114; -5.89701 1.84973 0.615069; 3.95703 3.36883 0.513961; 4.21262 11.2556 1.8508; 13.3924 10.0056 -1.48298];
%     [-9.77164 -7.63464e-07 -14.9739; -6.77383 0.90109 -0.104095; 4.20008 3.33285 0.931631; 3.67208 10.6227 2.38519; 12.1674 9.99574 -1.99041];
%     [-7.05592 -9.09509e-06 -13.6549; -6.11177 1.51743 0.417047; 4.32305 3.48227 1.02419; 4.12161 11.097 2.3453; 14.1524 10.1705 -2.1117];
%     [-8.19711 -4.88581e-05 -12.6653; -5.90094 1.29924 0.261814; 4.10807 3.57129 0.983193; 4.48111 8.22331 2.30676; 14.1167 10.19 -1.16533]};
% call_FCM_for_each_row_of_data(table_of_human_dir, human_centers, "cluster_tables_by_task");

%% run fcm with new cluster centers (no longer used)
% human_centers = {[-8.4395 2.63385e-06 -12.2387;-5.82472 1.65457 0.503579; 4.36271 14.5368 2.77715; 4.30037 4.39307 0.985194; 13.3924 10.0056 -1.48298];
%     [-8.47596 0.22516 -12.2809; -6.77383 0.90109 -0.104095; 4.28589 11.937 2.40274; 4.15948 3.17684 0.522273; 13.4403 10.8114 -0.8872];
%     [-6.28922 0.421487 -10.6863; -6.01457 1.26604 0.23593; 2.78744 17.6656 1.95159; 4.07527 3.09281 0.873556; 14.8398 10.206 -0.48517];
%     [-8.19711 -4.88581e-06 -12.6656;-6.01324 1.45008 0.371652; 4.50307 15.4999 2.67301; 3.1057 6.24288 1.97559; 14.1167 10.19 -1.16533]};
% 
% call_FCM_for_each_row_of_data(table_of_human_dir,human_centers,"cluster_tables_by_task_new_centers")

%% find improved human_centers from the initial guesses I took above and try running fcm again (no longer used)
% human_centers = get_centers_from_precreated_clusters_by_task_type("cluster_tables_by_task_new_centers");
% call_FCM_for_each_row_of_data(table_of_human_dir,human_centers,"cluster_tables_by_task_new_centers_2");

%% estimate the epsilons to be used when clustering (no longer used)
% estimated_epsilons = find_ideal_epsilon_per_dataset(table_of_human_dir);
%% now perform dbscan (no longer used)
% min_pts = {7,4,7,5};
% call_DB_clustering_for_each_row_of_data(table_of_human_dir,"cluster_tables_by_task_new_centers_3",estimated_epsilons,min_pts)


%% use density based cluster on all combined human data (no longer used)
%call_DB_clustering_combine_all_human_data(table_of_human_dir,"cluster_tables_by_task_new_centers_4",0,14)
%% get distinct cluster
colors = distinguishable_colors(10); %get distinguishable cluster colors
%% NO LONGER USED call spectral clustering on all combined human data
% call_spectral_clustering_combine_all_human_data(table_of_human_dir,"cluster_tables_by_task_new_centers_spectral_based",0,5,colors,'euclidean')
%% call spectral clustering on all combined human data 6 clusters according to kmeans daviesbouldin using euclidian
%this part isn't actually the used one, it's just something to be rerun so we can get the validity numbers 
% colors = distinguishable_colors(10);
% call_spectral_clustering_combine_all_human_data(table_of_human_dir,"doesnt matter",0,6,colors,'euclidean')

%% NO LONGER USED call spectral clustering on all combined human data 6 clusters according to kmeans daviesbouldin and using seuclidian (no longer used)
% colors = distinguishable_colors(10);
%call_spectral_clustering_combine_all_human_data(table_of_human_dir,"cluster_tables_by_task_new_centers_spectral_based_6_s_euc",0,5,colors,'seuclidean')

%% NO LONGER USED FINAL HUMAN CLUSTERING CONFIGURATION DO NOT RUN AGAIN call spectral clustering on all combined human data 6 clusters according to kmeans daviesbouldin using euclidian
% colors = distinguishable_colors(10);
% call_spectral_clustering_combine_all_human_data(table_of_human_dir,"cluster_tables_by_task_new_centers_spectral_based_6",0,6,colors,'euclidean')

%% NO LONGER USED call spectral clustering on rat data
% rat_data = get_rat_data("reward_choice Sigmoid Data");
% call_spectral_clustering_on_rat_data(rat_data,"cluster_tables_rat_spectral_clustering",0,4,colors);

%% (NO LONGER USED) calculate the bhaat distance as found in the previous section
% get_bhattacharyya_distance_plots("cluster_tables_by_task_new_centers")
%% (NO LONGER USED)create bhaat distance plots comparing rat to human new data
%create_human_to_rat_comparison_ver_2("rat_reward_choice.xlsx",one_one,"cluster_tables_for_rat","b_dist_plots_updated_2",colors)
%% (NO LONGER USED)create histograms, and get array of histcounts on a story/experiment basis
% create_histograms_by_experiment(human_data_table);
%% (NO LONGER USED) create histogram, but separate them 
% create_histograms_by_experiment_separate_plots(human_data_table);

%% (NO LONGER USED)create spider plots for human tasks
% create_spider_plots_for_data(human_data_table,"Individual_spider_plots");
%% (NO LONGER USED) create overlain spider plots
% clc;
%create_overlain_spider_plots_for_data(human_data_table,"Overlain_spider_plots");
%% concatenate the above into single
% concatenate_many_plots("Overlain_spider_plots","overlain_spider_plots.pdf","ALL PDFS")
% concatenate_many_plots("Individual_spider_plots","Individual_spider_plots.pdf","ALL PDFS")
% create_variance_plots("cluster_tables_by_task_new_centers")

%% (NO LONGER USED)create variance spider plots, each plot is the same cluster across all tasks (there will be 4 spider plots per chart* 6 clusters)
% create_variance_spider_plots_same_cluster_different_story(human_data_table,"Spider Plots Variance Same Cluster Different Story")
% concatenate_many_plots("Spider Plots Variance Same Cluster Different Story","Spider Plots Variance Same Cluster Different Story.pdf","ALL PDFS")
% close all;

%% (NO LONGER USED) create variance spider plots as above, but separate them all out into their permutations instead of having them all together
% create_variance_spider_plots_same_cluster_different_story_permu(human_data_table,"Spider Plots Variance Same Cluster Different Story Permutations");
% close all;
% concatenate_many_plots("Spider Plots Variance Same Cluster Different Story Permutations","Spider Plots Variance Same Cluster Different Story Permutations.pdf","ALL PDFS")

%% (NO LONGER USED) create variance spider plots, but represent the variance of all clusters in a single experiment
% create_variance_spider_plots_different_clusters_same_story(human_data_table,"Spider Plots Variance Different Clusters Same Story");
% concatenate_many_plots("Spider Plots Variance Different Clusters Same Story", "Spider Plots Variance Different Clusters Same Story.pdf","ALL PDFS")
% close all;

%% (NO LONGER USED)create mean spider plots, each plot is the same cluster across all tasks
% create_mean_spider_plots_same_cluster_different_story(human_data_table,"spider plots mean same story different cluster")
% concatenate_many_plots("spider plots mean same story different cluster","spider plots mean same story different clusters.pdf","ALL PDFS")
% close all;
%% (NO LONGER USED)create mean spider plots as above, but separe them all out into their permutations instead of having them all together
% create_mean_spider_plots_same_cluster_different_story_permu(human_data_table,"spider plots mean same cluster different story permutations");
% concatenate_many_plots("spider plots mean same cluster different story permutations","spider plots mean same cluster different story permutations.pdf","ALL PDFS")
% close all;
%% (NO LONGER USED)create mean spider plots, but represent the mean of all clusters in single experiment 
% clc;
% create_mean_spider_plots_different_clusters_same_story(human_data_table,"spider plots mean differnet clusters same story");
% close all;
% concatenate_many_plots("spider plots mean differnet clusters same story","spider plots mean differnet clusters same story.pdf","ALL PDFS")

%% (NO LONGER USED) create box plots of xyz between human tasks/stories/experiments 
% close all;
% clc;
% create_boxplot_cluster_permutations(human_data_table,"box plot permutations");
% close all;
% concatenate_many_plots_updated("box plot permutations","box plot permutations.pdf","ALL PDFS")

%% (NO LONGER USED) create more advanced box plot
% create_boxplot_cluster_permutations_2(human_data_table,"box plot permutations 2")
% close all;
% concatenate_many_plots_updated("box plot permutations 2","box plot permutations 2.pdf","ALL PDFS")
%% (NO LONGER USED)combine the xyz of box plots into single plot instead of having separate ones as above
% create_boxplot_cluster_permutations_3(human_data_table,"box plot permutations 3")
% close all;
% concatenate_many_plots_updated("box plot permutations 3","box plot permutations 3.pdf","ALL PDFS")

%% (NO LONGER USED) create 3d bar plot of variance significance normalized
% clc;
% close all;
% create_3d_bar_plots_for_variance(human_data_table,"bar3 variance plots normalized",1);
% close all;
% concatenate_many_plots_updated("bar3 variance plots normalized","bar3 variance plots normalized.pdf","ALL PDFS")

%% (NO LONGER USED) create 3d bar plot of variance significance  not normalized
% clc;
% close all;
% create_3d_bar_plots_for_variance(human_data_table,"bar3 variance plots not normalized",0);
% close all;
% concatenate_many_plots_updated("bar3 variance plots not normalized","bar 3 variance plots not normalized.pdf","ALL PDFS")

%% (NO LONGER USED)create 3d bar plot of mean significance normalized 
% clc;
% close all;
% create_3d_bar_plots_for_mean(human_data_table,"bar3 mean plots normalized",1)
% close all;
% concatenate_many_plots_updated("bar3 mean plots normalized","bar3 mean plots normalized.pdf","ALL PDFS")

%% (NO LONGER USED)create 3d bar plot of mean significance normalized 
% clc;
% close all;
% create_3d_bar_plots_for_mean(human_data_table,"bar3 mean plots not normalized",1)
% close all;
% concatenate_many_plots_updated("bar3 mean plots not normalized","bar3 mean plots not normalized.pdf","ALL PDFS")

%% (NO LONGER USED)create heat maps of variance changes for signifiance with mask
% clc;
% create_heat_maps_for_variance(human_data_table,"heat maps variance with mask",1);
% close all;
% concatenate_many_plots_updated("heat maps variance with mask","heat maps variance with mask.pdf","ALL PDFS")
%% (NO LONGER USED) create heat maps for significance not normalized
% clc;
% create_heat_maps_for_variance(human_data_table,"heat maps variance not normalized",0);
% close all;
% concatenate_many_plots_updated("heat maps variance not normalized","heat maps variance not normalized.pdf","ALL PDFS")

%% (no longer used) create heat maps for mean with mask
% clc;
% create_heat_maps_for_mean(human_data_table,"heat maps mean with mask",1);
% close all;
% concatenate_many_plots_updated("heat maps mean with mask","heat maps mean with mask.pdf","ALL PDFS")

%% (No Longer Used) create heat maps for variance with mask 3x1
% close all;
% create_heat_maps_for_variance_three_by_one(human_data_table,"heat maps variance three by one with mask",1)
% concatenate_many_plots_updated("heat maps variance three by one with mask", "heat maps variance three by one with mask.pdf","ALL PDFS")

%% (NO LONGER USED)create heat maps for mean with mask 3x1
% close all;
% create_heat_maps_for_mean_three_by_one(human_data_table,"heat maps mean three by one with mask",1);
% concatenate_many_plots_updated("heat maps mean three by one with mask","heat maps mean three by one with mask.pdf","ALL PDFS")

%% (NO LONGER USED) create heat map of all permutations of all mean significance clusters
% [mean_sig_x_matrix,x_y_ticks] = create_heat_map_from_map_of_permutations(human_data_table,map_of_mean_significance_permutations,"heat maps mean all permutations",1,1,"All Clusters Significant Change In Mean",0.001);
% [mean_sig_y_matrix,x_y_ticks] =create_heat_map_from_map_of_permutations(human_data_table,map_of_mean_significance_permutations,"heat maps mean all permutations",2,1,"All Clusters Significant Change In Mean",0.001);
% [mean_sig_z_matrix,x_y_ticks] =create_heat_map_from_map_of_permutations(human_data_table,map_of_mean_significance_permutations,"heat maps mean all permutations",3,1,"All Clusters Significant Change In Mean",0.001);
% close all;
% concatenate_many_plots_updated("heat maps mean all permutations","heat maps mean all permutations.pdf","ALL PDFS")
%% (NO LONGER USED) create heat map of all permutations of all variance significance clusters
% [var_sig_x_matrix,x_y_ticks] = create_heat_map_from_map_of_permutations(human_data_table,map_of_variance_significance_permutations,"heat maps var all permutations",1,1,"All Clusters Significant Change In Var",0.001);
% [var_sig_y_matrix,x_y_ticks] = create_heat_map_from_map_of_permutations(human_data_table,map_of_variance_significance_permutations,"heat maps var all permutations",2,1,"All Clusters Significant Change In Var",0.001);
% [var_sig_z_matrix,x_y_ticks] = create_heat_map_from_map_of_permutations(human_data_table,map_of_variance_significance_permutations,"heat maps var all permutations",3,1,"All Clusters Significant Change In Var",0.001);
% close all;
% concatenate_many_plots_updated("heat maps var all permutations","heat maps var all permutations.pdf","ALL PDFS")

%% (No longer used)create updated heat maps for singicant change in mean with clim([0,1])
% clc;
% mask_given_data_and_create_heat_map(["binary"],mean_sig_x_matrix,"heat map mean alexanders updates",x_y_ticks,"Significance in change of means of log(abs(max))",'%.3f')
% 
% %%
% mask_given_data_and_create_heat_map([],mean_sig_y_matrix,"heat map mean alexanders updates",x_y_ticks,"Significance in change of means of log(abs(max))",'%.3f')
% mask_given_data_and_create_heat_map([],mean_sig_z_matrix,"heat map mean alexanders updates",x_y_ticks,"Significance in change of means of log(abs(max))",'%.3f')

%% (No Longer Used)create updated heat maps for singicant change in variance with clim([0,1])
% clc;
% mask_given_data_and_create_heat_map([],var_sig_x_matrix,"heat map var alexanders updates",x_y_ticks,"Significance in change of var of log(abs(max))",'%.3f')
% mask_given_data_and_create_heat_map([],var_sig_y_matrix,"heat map var alexanders updates",x_y_ticks,"Significance in change of var of log(abs(shift))",'%.3f')
% mask_given_data_and_create_heat_map([],var_sig_z_matrix,"heat map var alexanders updates",x_y_ticks,"Significance in change of var of log(abs(slope))",'%.3f')
%% (NO LONGER USED) take randomized subsets of human data
% get_distributions_randomized_subsets(human_data_table,"bar plot randomized subsets")
%% (NO LONGER USED) create the 3d average xyz plot we want to match to 
%  story_types = ["approach_avoid","moral","probability","social"];
% home_dir_name = pwd+"\updated_clusters\";
% C = ['r','g','b','c'];
% sigmoid_type = "session";
% story_comparison_by_subj_3d(story_types,home_dir_name,C,sigmoid_type,0)
%% test if we can match average xyz by changing proportion data
% clc;
% table_with_aa_proportions = match_proportions_and_return_updated_table(human_data_table,[0.07 0.74 0.04 0.06 0.05 0.04],"approach_avoid");
% table_with_m_proportions = match_proportions_and_return_updated_table(human_data_table,[0.15 0.60 0.03 0.11 0.04 0.06],"moral");
% table_with_p_proportions = match_proportions_and_return_updated_table(human_data_table,[0.06 0.72 0.05 0.11 0.03 0.05],"probability");
% table_with_s_proportions = match_proportions_and_return_updated_table(human_data_table,[0.1 0.64 0.04 0.16 0.01 0.05],"social");
% 
% story_comparison_by_subj_3d_3(story_types,home_dir_name,C,sigmoid_type,0,{table_with_aa_proportions,table_with_m_proportions,table_with_p_proportions,table_with_s_proportions});

%% (No longer used) do 3d average xyz using by cluster
% story_types = ["approach_avoid","moral","probability","social"];
% home_dir_name = pwd+"\updated_clusters\";
% C = ['r','g','b','c'];
% sigmoid_type = "session";
% story_comparison_by_subj_3d_2(story_types,home_dir_name,C,sigmoid_type,0,human_data_table)



%% (NO LONGER USED) try to recreate the average through random sampling
% 
% proportions_to_match = [0.07 0.74 0.04 0.06 0.05 0.04;
%     0.15 0.60 0.03 0.11 0.04 0.06;
%     0.06 0.72 0.05 0.11 0.03 0.05;
%     0.1 0.64 0.04 0.16 0.01 0.05];
% story_types = ["approach_avoid","moral","probability","social"];
% C = ['r','g','b','c'];
% create_random_sampling_3d_average_plots(proportions_to_match,story_types,human_data_table,C)

%% (NO LONGER USED) create 3d human plot with the average xyz in the middle dont remove anything
% clc;
% close all;
% create_3d_plot_with_avg_star(human_data_table,"3d scatter with average star",colors,0,.5,2)

%% (NO LONGER USED) create 3d human plot with the average xyz in the middle remove 50% of cluster 2
% clc;
% close all;
% create_3d_plot_with_avg_star(human_data_table,"3d scatter with average star",colors,1,.5,2)
%% (NO LONGE USED) create 3d human plot with the average xyz in the middle remove 70% of cluster 2
% clc;
% close all;
% create_3d_plot_with_avg_star(human_data_table,"3d scatter with average star",colors,1,.3,2)

%% (NO LONGER USED) try different validation methods for human data
% try_different_validation_methods(table_of_human_dir,"cluster_tables_by_task_new_centers_spectral_based",0,5,colors)

%% (NO LONGER USED)call spectral clustering on all combined human data 6 clusters according to kmeans daviesbouldin using euclidian
%updated version using Lara's thing 
%do not run again
% colors = distinguishable_colors(10);
% call_spectral_clustering_combine_all_human_data_2(table_of_human_dir,"updated_correct_cluster_tables",0,5,colors,'euclidean')
%% (no longer used) for demonstration purposes do not use
% clc;
% colors = distinguishable_colors(10);
% call_spectral_clustering_combine_all_human_data_2(table_of_human_dir,"doesnt matter",0,9,colors,'euclidean')
%% (NO LONGER USED) get average xyz plots for different human experiments
% clc;
% close all;
% C = ['r','g','b','c'];
% get_average_xyz_per_human_experiment(string(unique(human_data_table.experiment)),pwd+"\sessions\",C)