function [current_axis,array_of_scatter_objects] =create_overlain_3d_cluster_plots(human_data,human_experiment,human_feature,rat_data,rat_experiment,rat_feature,human_or_rat_gray)

for i=1:height(table_of_directories)
    current_experiment=table_of_directories{i,1};
    current_data_location = table_of_directories{i,2};
    current_sigmoid_data = getTable(current_data_location);
    max_shift_slope = log(abs([current_sigmoid_data.A,current_sigmoid_data.B,current_sigmoid_data.C]));
    

    options = fcmOptions(NumClusters=[2,3,4,5,6],Verbose=false);
    [centers,U,~,info] = fcm(max_shift_slope,options);
    number_of_clusters = info.OptimalNumClusters;
    maxU=max(U);

    figure;
    array_of_scatter_objects = cell(1,number_of_clusters);
    for j=1:number_of_clusters
        indexes = find(U(j,:) == maxU);
        hold on;
        array_of_scatter_objects{j} = scatter3(max_shift_slope(indexes,1),max_shift_slope(indexes,2),max_shift_slope(indexes,3));
    end
    plot3(centers(:,1),centers(:,2),centers(:,3), ...
        "xk",MarkerSize=30,LineWidth=3);
    xlabel("Sigmoid Max")
    ylabel("Sigmoid Shift")
    zlabel("Sigmoid Slope")
    title(strrep(current_experiment,"_","\_"));
    subtitle("Created by create\_3d\_cluster\_plots.m")
    view([-11 63])
    current_axis = gca;

end
end