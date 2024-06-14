function indiv_subjects_in_cluster_3d_for_rat_data(all_psych_data,dir_to_save_figs_to,rat_stats_map)
dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);
num_clusters = length(unique(all_psych_data.cluster_number));
all_psych_data.clusterLabels = string(all_psych_data.clusterLabels);

names_and_dates = string(all_psych_data.clusterLabels);
names_and_dates_split = split(names_and_dates," ");
just_names = names_and_dates_split(:,1);





unique_ids = unique(just_names);
cluster_stats = cell(1,num_clusters);




for i = 1:length(unique_ids)
    id = unique_ids(i);
    curr_table = all_psych_data(contains(all_psych_data.clusterLabels,id), :);
    clusters = curr_table.cluster_number;
    [gc,gr] = groupcounts(clusters);
    sum_gc = sum(gc);
    gc = gc / sum_gc;
    for n = 1:length(gr)
        cluster = gr(n);
        stat = gc(n);
        cluster_stats{cluster} = [cluster_stats{cluster} ; stat];
    end

    figure
    bar(gr,gc)
    xlabel('cluster number')
    ylabel('percentage')
    ylim([0,1])
    title(["distribution of " + string(id) + "'s pts across cluster", ...
        strcat("Number of Data Points:",string(height(curr_table))), ...
        strcat("Date Created:",string(datetime("today",'Format','MM-d-yyyy'))), ...
        strcat("Created by: indiv\_subjects\_in\_cluster\_3d\_for\_rat\_data")])

    savefig(dir_to_save_figs_to +"\"+ string(id)+".fig")
    close all
end

end