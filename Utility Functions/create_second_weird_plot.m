clc;
table_of_rat_data = table("Reward Choice","C:\Users\ldd77\OneDrive\Desktop\Lara Analysis\reward_choice Sigmoid Data");
table_of_human_data = table("approach_avoid","C:\Users\ldd77\OneDrive\Desktop\Lara Analysis\all_human_sigmoids_across_all_tasks");

ax =subplot(2,4,1:2);

create_3d_cluster_plots(table_of_human_data,"3d_cluster_tables","human","all",ax);
create_3d_cluster_plots(table_of_rat_data,"3d_cluster_tables","rat","Baseline",ax);

view(1.0e+02 *[-0.237569505255322  -1.556328985807294   2.264902854654401])

ax =subplot(2,4,3:4);
home_dir=cd("3d_cluster_tables\");
delete("*.xlsx")
cd(home_dir);
create_3d_cluster_plots_consistent_colors(table_of_human_data,"3d_cluster_tables","human","all",ax);
create_3d_cluster_plots_consistent_colors(table_of_rat_data,"3d_cluster_tables","rat","Baseline",ax);
view([0,90])

ax =subplot(2,4,5:6);
home_dir=cd("3d_cluster_tables\");
delete("*.xlsx")
cd(home_dir);
create_3d_cluster_plots(table_of_human_data,"3d_cluster_tables","human","all",ax);
create_3d_cluster_plots(table_of_rat_data,"3d_cluster_tables","rat","Baseline",ax);
view(1.0e+02 *[2.562814019074814  -0.481211695441144   0.995515354777021])

ax =subplot(2,4,7:8);
home_dir=cd("3d_cluster_tables\");
delete("*.xlsx")
cd(home_dir);
create_3d_cluster_plots(table_of_human_data,"3d_cluster_tables","human","all",ax);
create_3d_cluster_plots(table_of_rat_data,"3d_cluster_tables","rat","Baseline",ax);
view([90 0 0])

% legend("o = rat", "x=human",'Location','best')



