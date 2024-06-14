function [updated_N_trial_data] =recreate_cluster_labels(N_trial_data)
updated_N_trial_data = cell(1,length(N_trial_data));
for i=1:length(N_trial_data)
    curr_data = N_trial_data{i};
    new_column = strcat(string(curr_data.subjectidnumber),repelem("_",height(curr_data),1), ...
        curr_data.story_num,repelem("_",height(curr_data),1),repelem("cost_",height(curr_data),1),string(curr_data.cost),repelem(".mat",height(curr_data),1));
    disp(new_column);
    curr_data = [curr_data,table(new_column,'VariableNames',{'clusterLabels'})];
    updated_N_trial_data{i} = curr_data;
end
end

