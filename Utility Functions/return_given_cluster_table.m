function data_table = return_given_cluster_table(name_of_cluster_table,dir_with_cluster_table)
home_dir = cd(dir_with_cluster_table);
data_table = readtable(name_of_cluster_table);
cd(home_dir)
end