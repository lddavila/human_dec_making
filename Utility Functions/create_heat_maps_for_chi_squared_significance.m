function [] = create_heat_maps_for_chi_squared_significance(data_table,dir_to_save_figs_to,mask_or_dont,mask_level,human_stats_map)
unique_clusters = unique(data_table.cluster_number);
unique_experiments = unique(data_table.experiment);
dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);

cluster_counts_matrix_for_heat_map = zeros(length(unique_experiments),length(unique_experiments));

for i=1:length(unique_experiments)
    exp_1 = string(unique_experiments(i));
    exp_1_data = data_table(strcmpi(data_table.experiment,exp_1),:);
    exp_1_cluster_counts = get_cluster_counts(exp_1_data,unique_clusters);
    for j=1:length(unique_experiments)
        exp_2 = string(unique_experiments(j));
        exp_2_data =data_table(strcmpi(data_table.experiment,exp_2),:);
        exp_2_cluster_counts = get_cluster_counts(exp_2_data,unique_clusters);

        if i==j
            cluster_counts_matrix_for_heat_map(i,j) = NaN;
        else
            cluster_counts_matrix_for_heat_map(i,j) = chi2test([exp_1_cluster_counts;exp_2_cluster_counts]);
            if mask_or_dont
                if cluster_counts_matrix_for_heat_map(i,j) > mask_level
                    % cluster_counts_matrix_for_heat_map(i,j) = 3;
                end
            end

        end
    end
end

figure('units','normalized','outerposition',[0 0 1 1]);
heatmap(unique_experiments,unique_experiments,cluster_counts_matrix_for_heat_map,'CellLabelFormat','%.3f');
title(["Significance Determined By Chi Squared Test", ...
    strcat("3 Indicates Signicance Level > ",string(mask_level)), ...
    strcat("Number Of approach avoid Sessions:",string(human_stats_map(strcat("approach_avoid"," Number of Data Points")))," Number of Subjects:",string(human_stats_map('approach_avoid Number Of Unique Subjects'))), ...
    strcat("Number Of moral Sessions:",      string(human_stats_map(strcat("moral"," Number of Data Points")))," Number of Subjects:",string(human_stats_map('moral Number Of Unique Subjects'))), ...
    strcat("Number Of probability Sessions:",      string(human_stats_map(strcat("probability"," Number of Data Points")))," Number of Subjects:",string(human_stats_map('probability Number Of Unique Subjects'))), ...
    strcat("Number Of social Sessions:",      string(human_stats_map(strcat("social"," Number of Data Points")))," Number of Subjects:",string(human_stats_map('social Number Of Unique Subjects'))), ...
    strcat("Date Created:",string(datetime("today",'Format','MM-d-yyyy'))), ...
    "Created By create\_heat\_maps\_for\_chi\_squared\_significance.m"]);
xlabel("experiment")
ylabel("experiment")

saveas(gcf,strcat(dir_to_save_figs_to,"\Significant Change In Density"),"fig")

end