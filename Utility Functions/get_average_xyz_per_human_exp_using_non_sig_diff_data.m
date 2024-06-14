function [] =get_average_xyz_per_human_exp_using_non_sig_diff_data(human_data_table, C,dir_to_save_figs_to,human_stats_map,weights,map_of_mean_significance,version_name)

    function [randomized_data] = compile_a_randomized_set_of_non_significantly_different_data(current_task,all_tasks,human_data_table,unique_clusters,map_of_mean_significance)
        randomized_data = [];


        %ad the current_task's data to the randomized_data
        randomized_data = [randomized_data;human_data_table(strcmpi(human_data_table.experiment,string(current_task)),:)];

        %add other task's data to the randomized data provided their means are not significantly different
        for task_n_counter=1:length(all_tasks)
            task_n = string(all_tasks(task_n_counter));
            if strcmpi(task_n,string(current_task))
                continue;
            end
            for cluster_counter=1:length(unique_clusters)
                curr_clust = unique_clusters(cluster_counter);
                sig_diff = map_of_mean_significance(strcat(string(current_task)," cluster ",string(curr_clust), " vs ", task_n, " cluster ",string(curr_clust), " "));
                if all(sig_diff < 0.1)
                    randomized_data = [randomized_data;human_data_table(strcmpi(human_data_table.experiment,task_n) & human_data_table.cluster_number==curr_clust,:)];

                end
            end
            
        end
    end


dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);

hs = [];
story_types = unique(human_data_table.experiment);
unique_clusters = unique(human_data_table.cluster_number);
figure('units','normalized','outerposition',[0 0 1 1])
title_strings = [];
for s=1:length(story_types)
    story_type = story_types(s);
    disp(story_type)
    
    randomized_data = compile_a_randomized_set_of_non_significantly_different_data(story_type,story_types,human_data_table,unique_clusters,map_of_mean_significance);

    non_sig_different_subset = match_proportions_and_return_updated_table_4(randomized_data,weights(string(story_type)));


    data_to_examine = [non_sig_different_subset.clusterX,non_sig_different_subset.clusterY,non_sig_different_subset.clusterZ];
    disp("Mean")
    xyz_mean = mean(data_to_examine);
    disp(xyz_mean);
    xyz_std = std(data_to_examine);
    disp("std")
    disp(xyz_std)
    xyz_std_error = xyz_std / sqrt(size(data_to_examine,1));
    disp("std error")
    disp(xyz_std_error)


    h = scatter3(xyz_mean(1),xyz_mean(2),xyz_mean(3),'o', C(s));
    hold on;
    plot3([xyz_mean(1),xyz_mean(1)]',[xyz_mean(2),xyz_mean(2)]',[-(xyz_std_error(3)),xyz_std_error(3)]'+xyz_mean(3)',C(s));
    plot3([-xyz_std_error(1),xyz_std_error(1)]'+xyz_mean(1)',[xyz_mean(2),xyz_mean(2)]',[xyz_mean(3),xyz_mean(3)]',C(s));
    plot3([xyz_mean(1),xyz_mean(1)]',[-xyz_std_error(2),xyz_std_error(2)]'+xyz_mean(2),[xyz_mean(3),xyz_mean(3)]',C(s));

    title_strings = [title_strings, strcat(strrep(story_type,"_","\_"), " Number of Data Points",string(human_stats_map(strcat(string(story_type)," Number Of Unique Subjects"))), " Number Of Subjects:", string(human_stats_map(strcat(string(story_type)," Number Of Unique Subjects"))))];
    % 
    % 
    hs = [hs; h];
end
legend(hs,story_types)
title([title_strings,"Created Using weighted means of each cluster",...
    strcat("Date Created:",string(datetime("today",'Format','MM-d-yyyy'))), ...
    "Created By get\_average\_xyz\_per\_human\_exp\_using\_non\_sig\_diff\_data.m", ...
    version_name]);
saveas(gcf,strcat(dir_to_save_figs_to,"\All Human Data Average XYZ ",version_name,".fig"),"fig")
end