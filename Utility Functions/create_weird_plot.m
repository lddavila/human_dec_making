clc;
table_of_rat_data = table("Reward Choice","C:\Users\ldd77\OneDrive\Desktop\Lara Analysis\reward_choice Sigmoid Data");
table_of_human_data = table("approach_avoid","C:\Users\ldd77\OneDrive\Desktop\Lara Analysis\all_human_sigmoids_across_all_tasks");

ax =subplot(2,4,1:4);

create_3d_cluster_plots(table_of_human_data,"3d_cluster_tables","human","all",ax);
create_3d_cluster_plots(table_of_rat_data,"3d_cluster_tables","rat","Baseline",ax);

legend("o = rat", "x=human",'Location','best')

view([66.669953365696159 -1.761610580104299e+02 2.192501372059673e+02])
hold on;



plot_individual_clusters("3d_cluster_tables",ax,5)

