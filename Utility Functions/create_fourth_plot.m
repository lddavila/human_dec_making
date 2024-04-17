clc;
table_of_rat_data = table("Reward Choice","C:\Users\ldd77\OneDrive\Desktop\Lara Analysis\reward_choice Sigmoid Data");
table_of_human_data = table("approach_avoid","C:\Users\ldd77\OneDrive\Desktop\Lara Analysis\all_human_sigmoids_across_all_tasks");
table_of_human_data = table("approach_avoid","C:\Users\ldd77\OneDrive\Desktop\Lara Analysis\clustering_data\approach_avoid\Sigmoid Data");
ax =subplot(1,1,1);

rat_centers = [-9.19224 -0.160122 -5.94521; 0.0725258 9.26768 5.38323;-0.0750791 2.44643 4.20085; 7.26215 9.12042 2.84782];
human_centers = [-9.58304 9.75048e-08 -14.0991;
                -6.3448 1.54914 0.437736;
                 4.16898 11.8951 2.47445;
                  4.06153 3.09722 0.625457;
                11.3803 12.5503 0.188948];


human_colors ={[0,0.1,0.7],[0,0.1,0.7],[0.7,0,0],[0.5 0 0.5],[0 0 0]};
rat_colors = {[0 0 1],[1 0 0],[0.7 0 0.7],[.7 .7 .7]};

[current_axis_human,array_of_scatter_objects_human] = create_3d_cluster_plots_provide_centers(table_of_human_data,"3d_cluster_tables","human","all",ax,human_centers,human_colors,5);

[current_axis_rat,array_of_scatter_objects_rat] = create_3d_cluster_plots_provide_centers(table_of_rat_data,"3d_cluster_tables","rat","reward_choice",ax,rat_centers,rat_colors,4);


