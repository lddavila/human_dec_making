function cluster= getClusterTable3d_for_rat(xVsYVsZ, labels,indexes,cluster_id)
%xvsY is 1row x 2 col array 
%labels are all labels of the data
%indexes are the indexes of the labels that belong to cluster the cluster
%cluster is the table that represents the cluster
    clusterX = xVsYVsZ(indexes,1);
    clusterY = xVsYVsZ(indexes,2);
    clusterZ = xVsYVsZ(indexes,3);
    clusterLabels = labels(indexes).';
    cluster_number = repelem(cluster_id,length(clusterX)).';
    disp(strcat("Cluster",string(cluster_id)));
    % disp([size(clusterX),size(clusterY),size(clusterZ),size(clusterLabels),size(cluster_number),size(experiment)]);
    cluster = table(clusterLabels,clusterX,clusterY,clusterZ,cluster_number);
end