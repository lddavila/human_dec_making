function subjects_in_cluster_3d_for_rat_data(all_psych_data,rat_stats_map,dir_to_save_figs_to)


dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);
num_clusters = length(unique(all_psych_data.cluster_number));

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
    
end

figure
max_vals = 0;
for i = 1:length(cluster_stats)
    cluster = cluster_stats{i};
    num_vals = length(cluster);
    avg_percent = mean(cluster);
    scatter(i,avg_percent,num_vals*10,num_vals,'filled')
    if max_vals < num_vals
        max_vals = num_vals;
    end
    hold on
end
num_subjects = length(unique_ids);
title([ "Percentage of Subjects Per Cluster", ...
    strcat("Number of Data Points:",string(rat_stats_map('Number of Data Points'))), ...
    strcat("Date Created:",string(datetime("today",'Format','MM-d-yyyy'))), ...
    strcat("number of subjects: ",string(num_subjects))])
colormap('default')
cb = colorbar;
ylabel(cb,'Number of subjects in cluster','FontSize',16,'Rotation',270);
cb.Ticks = [0 max_vals/2 max_vals];
clim([0 max_vals]);
% ylim([0 y_max])
xlabel('cluster number')
ylabel('percent of subject sessions in cluster')
curtick = get(gca, 'xTick');
xticks(unique(round(curtick)));

saveas(gcf,strcat(dir_to_save_figs_to,"\2b for rat.fig"),"fig");
end