function [] = run_3d_fcm_analysis(xVsYVsZ,labels,xAxis,yAxis,zAxis,experiment,called_by,centers, cluster_table_dir)
%format underscores
called_by = strrep(called_by,"_","\_");

if isempty(centers)
    [centers_determined_by_fcm,U,~,info] = fcm(xVsYVsZ);
    optimum_number_of_clusters = info.OptimalNumClusters;
else
    opt = fcmOptions(ClusterCenters = centers,NumClusters=size(centers,1));
    [centers_determined_by_fcm,U] = fcm(xVsYVsZ,opt);
    optimum_number_of_clusters = size(centers,1);
end

maxU = max(U);
mpc = calculate_mpc(U);
array_of_scatter_objects = cell(1,optimum_number_of_clusters);
array_of_plot_objects = cell(1,optimum_number_of_clusters);
figure;
number_of_data_points = 0;
for i=1:optimum_number_of_clusters
    indexes = find(U(i,:)==maxU);
    number_of_data_points = number_of_data_points+size(indexes,1);
    array_of_scatter_objects{i} = scatter3(xVsYVsZ(indexes,1),xVsYVsZ(indexes,2),xVsYVsZ(indexes,3));
    hold on;
    array_of_plot_objects{i} = plot3(centers_determined_by_fcm(i,1),centers_determined_by_fcm(i,2),centers_determined_by_fcm(i,3),"xk",MarkerSize=30,LineWidth=3);
    cluster_table = getClusterTable3d(xVsYVsZ,labels,indexes,i);
    writetable(cluster_table,strcat(cluster_table_dir,"\",experiment,".xlsx"), 'WriteMode','append')
    dt_row = [dataTipTextRow("Cluster\_Number: ",i)];
    array_of_plot_objects{i}.DataTipTemplate.DataTipRows(end+1) = dt_row;

    
end

xlabel(xAxis)
ylabel(yAxis)
zlabel(zAxis)

title(strcat(experiment," ",string(optimum_number_of_clusters)," Clusters MPC:",string(mpc)))
subtitle(called_by)
end