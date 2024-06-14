function probability_of_behavior_3d_for_rat(all_psych_data,dir_to_save_figs_to,rat_stats_map)
figure 
dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);
story_psychs = all_psych_data;
num_clusters = max(story_psychs.cluster_number);

tot_pts = height(story_psychs);
for i = 1:num_clusters
    cluster_psychs = story_psychs(story_psychs.cluster_number == i, :);
    mean_x = mean(cluster_psychs.clusterX, 'omitnan');
    mean_y = mean(cluster_psychs.clusterY, 'omitnan');
    mean_z = mean(cluster_psychs.clusterZ, 'omitnan');

    tot_in_cluster = height(cluster_psychs);
    prob = tot_in_cluster / tot_pts;

    scatter3(mean_x, mean_y, mean_z, prob*1000, 'r','filled')
    hold on
end

title(['probability of cluster for Rat Data', ...
    strcat("Number Of Unique Subjects:",string(rat_stats_map('Number Of Unique Subjects'))), ...
    strcat("Number of Data Points:",string(rat_stats_map('Number of Data Points'))), ...
    strcat("Date Created:",string(datetime("today",'Format','MM-d-yyyy'))), ...
    strcat("Created by: probability\_of\_behavior\_3d\_for\_rat")])
xlabel('log(abs(max))')
ylabel('log(abs(shift))')
zlabel('log(abs(slope))')
set(gcf,'renderer','Painters')
savefig(dir_to_save_figs_to + "\prob_of_behavior_Rat_Data.fig")

end