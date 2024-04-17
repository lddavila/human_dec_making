function [map_of_bhaat_distances,map_of_mean_significance_permutations,map_of_variance_significance_permutations] = derive_bhaat_distance_permutations(data_table)
map_of_bhaat_distances = containers.Map('KeyType','char','ValueType','any');
map_of_mean_significance_permutations = containers.Map('KeyType','char','ValueType','any');
map_of_variance_significance_permutations = containers.Map('KeyType','char','ValueType','any');
unique_clusters = unique(data_table.cluster_number);
unique_experiments = unique(data_table.experiment);


for j=1:length(unique_experiments)
    exp_1 = string(unique_experiments(j));
    for k=1:length(unique_experiments)
        exp_2 = string(unique_experiments(k));
        for i=1:length(unique_clusters)
            exp_1_cluster = unique_clusters(i);

            exp_1_data = data_table(strcmpi(data_table.experiment,exp_1) & data_table.cluster_number==exp_1_cluster,:);
            exp_1_xyz = [exp_1_data.clusterX,exp_1_data.clusterY,exp_1_data.clusterZ];
            exp_1_labels = logical(zeros(size(exp_1_data,1),1));
            for m=1:length(unique_clusters)
                exp_2_cluster = unique_clusters(m);
                exp_2_data = data_table(strcmpi(data_table.experiment,exp_2) & data_table.cluster_number==exp_2_cluster,:);
                exp_2_xyz = [exp_2_data.clusterX,exp_2_data.clusterY,exp_2_data.clusterZ];
                exp_2_labels = logical(ones(size(exp_2_data,1),1));
                if all([length(exp_1_xyz)>1,length(exp_2_xyz)>1,length(exp_2_labels)>1,length(exp_1_labels)>1])
                    map_of_bhaat_distances(sprintf('%s cluster %d vs %s cluster %d ',exp_1,exp_1_cluster,exp_2,exp_2_cluster)) = bhattacharyyaDistance([exp_1_xyz;exp_2_xyz],[exp_1_labels;exp_2_labels]);
                    [~,pm] = ttest2(exp_1_xyz,exp_2_xyz);
                    map_of_mean_significance_permutations(sprintf('%s cluster %d vs %s cluster %d ',exp_1,exp_1_cluster,exp_2,exp_2_cluster)) = pm;
                    [~,pv] = vartest2(exp_1_xyz,exp_2_xyz);
                    map_of_variance_significance_permutations(sprintf('%s cluster %d vs %s cluster %d ',exp_1,exp_1_cluster,exp_2,exp_2_cluster)) = pv;

                else
                    map_of_bhaat_distances(sprintf('%s cluster %d vs %s cluster %d ',exp_1,exp_1_cluster,exp_2,exp_2_cluster)) = [NaN NaN NaN];

                    map_of_mean_significance_permutations(sprintf('%s cluster %d vs %s cluster %d ',exp_1,exp_1_cluster,exp_2,exp_2_cluster)) =  [NaN NaN NaN];

                    map_of_variance_significance_permutations(sprintf('%s cluster %d vs %s cluster %d ',exp_1,exp_1_cluster,exp_2,exp_2_cluster)) =  [NaN NaN NaN];

                end
                
            end


        end
    end
end

end