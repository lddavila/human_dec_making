clc;
table_of_rat_data = table("Reward Choice","C:\Users\ldd77\OneDrive\Desktop\Lara Analysis\reward_choice Sigmoid Data");
table_of_human_data = table("approach_avoid","C:\Users\ldd77\OneDrive\Desktop\Lara Analysis\all_human_sigmoids_across_all_tasks");

ax =subplot(3,4,1:4);

rat_centers = [-9.19224 -0.160122 -5.94521; 0.0725258 9.26768 5.38323;-0.0750791 2.44643 4.20085; 7.26215 9.12042 2.84782];
human_centers = [-7.616854999999999 0.774569569125500 -7.101532000000001;4.16898 11.8951 2.47445;4.06153 3.09722 0.625457;11.3803 12.5503 0.188948];

[current_axis_human,array_of_scatter_objects_human] = create_3d_cluster_plots(table_of_human_data,"3d_cluster_tables","human","all",ax);
for i=1:length(array_of_scatter_objects_human)
    current_scatter_object = array_of_scatter_objects_human{i};

    current_center = human_centers(i,:);
    quiver3(current_center(1),current_center(2),current_center(3), ...
        2,2,5, ...
        'LineWidth',1,'Color',[0 0 0])
    text(current_center(1)+2,current_center(2)+2,current_center(3)+5,strcat('Human Cluster ',string(i)),"FontSize",14)
    if i==1
        current_scatter_object.MarkerEdgeColor = [0,0.1,0.7]; %dark blue
    elseif i==2
        current_scatter_object.MarkerEdgeColor = [0.7,0,0]; %dark red
    elseif i==3
        current_scatter_object.MarkerEdgeColor = [0.5 0 0.5]; %bright purple
    elseif i==4
        current_scatter_object.MarkerEdgeColor = [0 0 0]; %black
    end

end
[current_axis_rat,array_of_scatter_objects_rat] = create_3d_cluster_plots(table_of_rat_data,"3d_cluster_tables","rat","Baseline",ax);
for i=1:length(array_of_scatter_objects_rat)
    current_scatter_object = array_of_scatter_objects_rat{i};
    current_center = rat_centers(i,:);
    quiver3(current_center(1),current_center(2),current_center(3), ...
        -2,-2,5, ...
        'LineWidth',1,'Color',[0 0 0])
    text(current_center(1)-2,current_center(2)-2,current_center(3)+5,strcat('Rat Cluster ',string(i)),"FontSize",14)
    if i==1
        current_scatter_object.MarkerEdgeColor = [0 0 1]; %light
    elseif i==2
        current_scatter_object.MarkerEdgeColor = [1 0 0]; %bright red 
    elseif i==3
        current_scatter_object.MarkerEdgeColor = [0.7 0 0.7]; %light violent
    elseif i==4
        current_scatter_object.MarkerEdgeColor = [.7 .7 .7]; %gray
    end
end

legend("o = rat", "x=human",'Location','best')

view([66.669953365696159 -1.761610580104299e+02 2.192501372059673e+02])
hold on;



plot_individual_clusters_consistent_colors("3d_cluster_tables",ax,5)

