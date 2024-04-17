function [updated_table] = select_single_experiment_from_data_set(name_of_cluster_dir,name_of_cluster_file,name_of_experiment_you_want)
home_dir = cd(name_of_cluster_dir);
updated_table = readtable(name_of_cluster_file);
updated_table = updated_table(strcmp(updated_table.experiment,name_of_experiment_you_want),:);
cd(home_dir)
end