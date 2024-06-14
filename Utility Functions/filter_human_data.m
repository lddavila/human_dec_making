function [filtered_human_data_table] = filter_human_data(human_data_table,updated_N_trial_data)
filtered_human_data_table = [];
human_data_table.clusterLabels = string(human_data_table.clusterLabels);
human_data_table.experiment = string(human_data_table.experiment);
sum = 0;
for i=1:length(updated_N_trial_data)
    sum = sum + height(updated_N_trial_data{i});
end
disp(sum)
end