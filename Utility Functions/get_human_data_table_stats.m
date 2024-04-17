function [stats_map] = get_human_data_table_stats(human_data_table)

    function [number_of_unqiue_subjects] = count_unique_subjects(cluster_labels)
        split_info = split(cluster_labels,"_");
        subject_ids = string(split_info(:,1));
        unique_subject_ids = unique(subject_ids);
        number_of_unqiue_subjects = size(unique_subject_ids,1);


    end
unique_experiments = human_data_table.experiment;
stats_map = containers.Map('KeyType','char','ValueType','any');

for i=1:length(unique_experiments)
    curr_exp = string(unique_experiments(i));
    curr_exp_data = human_data_table(strcmpi(curr_exp,human_data_table.experiment),:);
    stats_map(strcat(curr_exp, " Number of Data Points")) = height(curr_exp_data);

    stats_map(strcat(curr_exp, " Number Of Unique Subjects")) = count_unique_subjects(curr_exp_data.clusterLabels);
end
stats_map("Number of Unique Subjects in all human data") = count_unique_subjects(human_data_table.clusterLabels);
stats_map("Number of Sessions in all human data") = height(human_data_table);
end