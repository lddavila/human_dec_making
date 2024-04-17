function [] = run_3d_fcm_analysis_for_rat(xVsYVsZ,labels,xAxis,yAxis,zAxis,experiment,called_by,centers, cluster_table_dir)
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
number_of_data_points = size(xVsYVsZ,1);
for i=1:optimum_number_of_clusters
    indexes = find(U(i,:)==maxU);
    array_of_scatter_objects{i} = scatter3(xVsYVsZ(indexes,1),xVsYVsZ(indexes,2),xVsYVsZ(indexes,3),'filled');
    hold on;
    array_of_plot_objects{i} = plot3(centers_determined_by_fcm(i,1),centers_determined_by_fcm(i,2),centers_determined_by_fcm(i,3),"xk",MarkerSize=30,LineWidth=3);
    cluster_table = getClusterTable3d_for_rat(xVsYVsZ,labels,indexes,i);
    writetable(cluster_table,strcat(cluster_table_dir,"\",experiment,".xlsx"), 'WriteMode','append')
    dt_row = [dataTipTextRow("Cluster\_Number: ",i)];
    array_of_plot_objects{i}.DataTipTemplate.DataTipRows(end+1) = dt_row;

    
end

xlabel(xAxis)
ylabel(yAxis)
zlabel(zAxis)

labels_individiual = split(string(labels(:,1))," ");
labels_unique = unique(labels_individiual(:,1));
title([strcat(experiment," ",string(optimum_number_of_clusters)," Clusters MPC:",string(mpc)), ...
    strcat( "Number Of Data Points",string(number_of_data_points)), ...
    strcat("Date Created: ",string(datetime("today",'Format','MM-d-yyyy'))), ...
    strcat("Unique Subjects: ",string(size(labels_unique,1))), ...
    called_by])
end