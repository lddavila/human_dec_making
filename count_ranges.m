unique_experiments = unique(human_data_table.experiment);
for i=1:length(unique_experiments)
    curr_exp = string(unique_experiments(i));
    only_curr_exp = human_data_table(strcmpi(human_data_table.experiment,curr_exp),:);
    only_curr_exp.clusterLabels = string(only_curr_exp.clusterLabels);
    all_info = split(only_curr_exp.clusterLabels,"_");
    unique_subject_ids = unique(all_info(:,1));
    appearence_count = zeros(length(unique_subject_ids),1);
    for j=1:length(unique_subject_ids)
        appearence_count(j) = sum(all_info(:,1) == unique_subject_ids(j));
    end
    disp(curr_exp)
    %disp([unique_subject_ids,appearence_count])
    [minA,maxA] = bounds(appearence_count);
    disp(strcat("Min:",string(minA)," Max:",string(maxA)))
end