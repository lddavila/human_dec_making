function cluster= getClusterTable3dWithoutExperiment(xVsYVsZ, labels,indexes,cluster_id)
%xvsY is 1row x 2 col array 
%labels are all labels of the data
%indexes are the indexes of the labels that belong to cluster the cluster
%cluster is the table that represents the cluster
    clusterX = xVsYVsZ(indexes==cluster_id,1);
    clusterY = xVsYVsZ(indexes==cluster_id,2);
    clusterZ = xVsYVsZ(indexes==cluster_id,3);
    clusterLabels = labels(indexes==cluster_id).';
    clusterLabels = clusterLabels.';
    cluster_number = repelem(cluster_id,length(clusterX)).';
    cluster = table(clusterLabels,clusterX,clusterY,clusterZ,cluster_number);

end