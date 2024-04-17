function [stats_map] = get_rat_data_table_stats(rat_data_table)

    function [number_of_unqiue_subjects] = count_unique_subjects(cluster_labels)
        split_info = split(cluster_labels," ");
        subject_ids = string(split_info(:,1));
        unique_subject_ids = unique(subject_ids);
        number_of_unqiue_subjects = size(unique_subject_ids,1);


    end

stats_map = containers.Map('KeyType','char','ValueType','any');




stats_map(strcat("Number of Data Points")) = height(rat_data_table);

stats_map(strcat("Number Of Unique Subjects")) = count_unique_subjects(rat_data_table.clusterLabels);

end