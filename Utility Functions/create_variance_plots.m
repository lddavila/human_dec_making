function [] = create_variance_plots(directory_with_cluster_tables)
home_dir=cd(directory_with_cluster_tables);
directory_with_cluster_tables_abs = cd(home_dir);

all_cluster_tables = strtrim(string(ls(strcat(directory_with_cluster_tables_abs,"\*.xlsx"))));
cell_array_to_contain_variance_measurements = cell(length(all_cluster_tables),5); % i used 5 because I've determined that each data set has 5 clusters
for i=1:length(all_cluster_tables)
    current_table = readtable(strcat(directory_with_cluster_tables_abs,"\",all_cluster_tables(i)));
    unique_clusters_in_current_table = unique(current_table.cluster_number);

    cell_array_to_contain_variance_measurements{i} = cell(1,length(unique_clusters_in_current_table));

    for j=1:length(unique_clusters_in_current_table)
        current_cluster = current_table(current_table.cluster_number == unique_clusters_in_current_table(j),:);
        array_of_cluster_xyz = table2array(current_cluster(:,2:4));
        cell_array_to_contain_variance_measurements{i,j}= var(array_of_cluster_xyz);
    end



end

for k=1:4
    figure;
    X = categorical({char(strcat("approach_avoid ",string(k))),char(strcat("moral ",string(k))),char(strcat("proability ",string(k))),char(strcat("social ",string(k)))});
    X = reordercats(X,{char(strcat("approach_avoid ",string(k))),char(strcat("moral ",string(k))),char(strcat("proability ",string(k))),char(strcat("social ",string(k)))});
    something_array = cell2mat(cell_array_to_contain_variance_measurements(:,k));
    bar(X,something_array);
    ylabel("Variance")
    xlabel("Cluster Number")
    title(strcat("Comparing Variance of Cluster ", string(k), " Across all tasks"))
    legend("var(log(abs(max)))","var(log(abs(shift)))","var(log(abs(slope)))")
end


end