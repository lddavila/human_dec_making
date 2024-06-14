function [] = run_average_sigmoids_n_times(human_data_table,proportions_to_match,n,same_scale,want_plot,C,dir_to_save_figs_to_1,dir_to_save_figs_to_2,human_stats_map,version_name)
story_types = unique(human_data_table.experiment);
hs = [];
disp("////////////////////////////////////")
title_strings = [];
for i=1:length(story_types)
    story_type = story_types(i);
    title_strings = [title_strings, strcat(strrep(story_type,"_","\_"),...
    " Number of Data Points",string(human_stats_map(strcat(string(story_type)," Number of Data Points"))),... 
    " Number Of Subjects:", string(human_stats_map(strcat(string(story_type)," Number Of Unique Subjects"))))];
    current_proportions_to_match_to = proportions_to_match(i,:);
    random_one_to_use = randi(1000);
    all_means_from_random_sampling = [];
    all_std_from_random_sampling = [];
    all_std_error_from_random_sampling = [];
    for j=1:n
        subset_data = match_proportions_and_return_updated_table_3(human_data_table,current_proportions_to_match_to,story_type);
        data_to_examine = [subset_data.clusterX,subset_data.clusterY,subset_data.clusterZ];
        xyz_mean = mean(data_to_examine);
        xyz_std = std(data_to_examine);
        xyz_std_error = xyz_std / sqrt(size(data_to_examine,1));

        
        all_means_from_random_sampling = [all_means_from_random_sampling;xyz_mean];
        all_std_from_random_sampling = [all_std_error_from_random_sampling;xyz_std];
        all_std_error_from_random_sampling = [all_std_error_from_random_sampling;xyz_std_error];
        if random_one_to_use==j
            % get_average_sig_by_cluster_and_experiment(subset_data,same_scale,story_types(i),want_plot,dir_to_save_figs_to_1,dir_to_save_figs_to_2,experiment_to_use);
        end

    end
    x = mean(all_means_from_random_sampling(:,1));
    y = mean(all_means_from_random_sampling(:,2));
    z = mean(all_means_from_random_sampling(:,3));

    mean_std_error_x = mean(all_std_error_from_random_sampling(:,1));
    mean_std_error_y = mean(all_std_error_from_random_sampling(:,2));
    mean_std_error_z = mean(all_std_error_from_random_sampling(:,3));

    h = scatter3(x,y,z,'o',C(i));
    hold on;
    plot3([x,x]',[y,y]',[-mean_std_error_z,mean_std_error_z]'+z',C(i))
    plot3([x,x]',[-mean_std_error_y,mean_std_error_y]'+y',[z,z]',C(i))
    plot3([-mean_std_error_x,mean_std_error_x]'+x',[y,y]',[z,z]',C(i))

    hs = [hs;h];

   
    disp(story_type)
    disp("Mean")
    disp([x,y,z])
    disp("std")
    disp([])
    disp("std error")
    disp([mean_std_error_x,mean_std_error_y,mean_std_error_z])


end
% xlim([1.5,3])
% ylim([3,6.4])
% zlim([-1.8,-0.4])
dir_to_save_figs_to_1 = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to_1);
title(["Each Recreated from 1000 random samplings", ...
    title_strings,...
    strcat("Date Created:",string(datetime("today",'Format','MM-d-yyyy'))), ...
    "Created By run\_average\_sigmoids\_n\_times.m", ...
    version_name])
legend(hs,string(story_types))
saveas(gcf,strcat(dir_to_save_figs_to_1,"\Recreated average XYZ plot using 1000 samples per task type ",version_name),"fig")
end