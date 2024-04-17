human_clusters = readtable('C:\Users\ldd77\OneDrive\Desktop\Lara Analysis\3d_cluster_tables\human all M.xlsx');
rat_clusters = readtable('C:\Users\ldd77\OneDrive\Desktop\Lara Analysis\3d_cluster_tables\rat Baseline M.xlsx');

clusters = [1 2 3 4];

%% Compare human to rats
for i=1:length(clusters)
    table_for_only_current_human_clusters = human_clusters(human_clusters.cluster_number==i,:);
    figure;
    for j=1:length(clusters)
        table_for_only_current_rat_clusters = rat_clusters(rat_clusters.cluster_number==j,:);
        
        matrix_of_human_and_rat_data = [[table_for_only_current_human_clusters.clusterX,table_for_only_current_human_clusters.clusterY,table_for_only_current_human_clusters.clusterZ];
                [table_for_only_current_rat_clusters.clusterX,table_for_only_current_rat_clusters.clusterY,table_for_only_current_rat_clusters.clusterZ]];

            logical_classification_labels_for_human = logical(zeros(height(table_for_only_current_human_clusters),1));

            logical_classification_labels_for_rats = logical(ones(height(table_for_only_current_rat_clusters),1));

            b_dist = bhattacharyyaDistance(matrix_of_human_and_rat_data,[logical_classification_labels_for_human;logical_classification_labels_for_rats]);

            subplot(2,2,j)
            
            bar(["Max","Shift","Slope"],b_dist)
            title(strcat("Human Cluster ",string(i),"'s Bhattacharyya Distance To Rat Cluster ",string(j)));
    end
end

%% compare rat clusters to rat clusters
for i=1:length(clusters)
    table_for_only_current_human_clusters = rat_clusters(rat_clusters.cluster_number==i,:);
    figure;
    for j=1:length(clusters)
        table_for_only_current_rat_clusters = rat_clusters(rat_clusters.cluster_number==j,:);
        
        matrix_of_human_and_rat_data = [[table_for_only_current_human_clusters.clusterX,table_for_only_current_human_clusters.clusterY,table_for_only_current_human_clusters.clusterZ];
                [table_for_only_current_rat_clusters.clusterX,table_for_only_current_rat_clusters.clusterY,table_for_only_current_rat_clusters.clusterZ]];

            logical_classification_labels_for_human = logical(zeros(height(table_for_only_current_human_clusters),1));

            logical_classification_labels_for_rats = logical(ones(height(table_for_only_current_rat_clusters),1));

            b_dist = bhattacharyyaDistance(matrix_of_human_and_rat_data,[logical_classification_labels_for_human;logical_classification_labels_for_rats]);

            subplot(2,2,j)
            
            bar(["Max","Shift","Slope"],b_dist)
            title(strcat("Rat Cluster ",string(i),"'s Bhattacharyya Distance To Rat Cluster ",string(j)));
    end
end

%% compare rat clusters to rat clusters
for i=1:length(clusters)
    table_for_only_current_human_clusters = human_clusters(human_clusters.cluster_number==i,:);
    figure;
    for j=1:length(clusters)
        table_for_only_current_rat_clusters = human_clusters(human_clusters.cluster_number==j,:);
        
        matrix_of_human_and_rat_data = [[table_for_only_current_human_clusters.clusterX,table_for_only_current_human_clusters.clusterY,table_for_only_current_human_clusters.clusterZ];
                [table_for_only_current_rat_clusters.clusterX,table_for_only_current_rat_clusters.clusterY,table_for_only_current_rat_clusters.clusterZ]];

            logical_classification_labels_for_human = logical(zeros(height(table_for_only_current_human_clusters),1));

            logical_classification_labels_for_rats = logical(ones(height(table_for_only_current_rat_clusters),1));

            b_dist = bhattacharyyaDistance(matrix_of_human_and_rat_data,[logical_classification_labels_for_human;logical_classification_labels_for_rats]);

            subplot(2,2,j)
            
            bar(["Max","Shift","Slope"],b_dist)
            title(strcat("Human Cluster ",string(i),"'s Bhattacharyya Distance To Human Cluster ",string(j)));
    end
end
