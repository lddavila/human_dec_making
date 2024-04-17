function [] = compare_human_data_to_human_data_using_dg_for_sig(data_table,dir_to_save_figs_to,human_stats_map)
dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);
unique_clusters = unique(data_table.cluster_number);
unique_experiments = unique(data_table.experiment);
all_cluster_counts_by_story = containers.Map('KeyType','char','ValueType','any');
all_cluster_percentages_by_story = containers.Map('KeyType','char','ValueType','any');
disp("Using Dan Gibson chi2test")
for i=1:length(unique_experiments)
    curr_exp = string(unique_experiments(i));
    only_curr_exp = data_table(strcmpi(data_table.experiment,curr_exp),:);
    number_of_data_points_for_current_experiments = size(only_curr_exp,1);
    cluster_counts = get_cluster_counts(only_curr_exp,unique_clusters);

    for j=i+1:length(unique_experiments)
        curr_exp_2 = string(unique_experiments(j));
        only_curr_exp_2 = data_table(strcmpi(data_table.experiment,curr_exp_2),:);
        number_of_data_points_for_current_experiments_2=size(only_curr_exp_2,1);
        cluster_counts_2 = get_cluster_counts(only_curr_exp_2,unique_clusters);
        disp(strcat("Experiment 1: ", curr_exp," Experiment 2: ",curr_exp_2));
        disp([cluster_counts;cluster_counts_2])

        [p,~,~,~,~] = dg_chi2test3([cluster_counts;cluster_counts_2]);
        disp(strcat("Significance",string(p)));
        figure('units','normalized','outerposition',[0 0 1 1]);
        
        scatter3(only_curr_exp.clusterX,only_curr_exp.clusterY,only_curr_exp.clusterZ,'o','filled');
        hold on;
        scatter3(only_curr_exp_2.clusterX,only_curr_exp_2.clusterY,only_curr_exp_2.clusterZ,'o','filled');
        legend(curr_exp,curr_exp_2)
        xlabel("log(abs(max))")
        ylabel("log(abs(shift))")
        zlabel("log(abs(slope))")
        set(gcf,'renderer','Painters');
        title([strcat("Experiment 1: ", curr_exp," Experiment 2: ",curr_exp_2, "P-Value Per DG_chi2test3: ",string(p)), ...
            strcat("Number Of ",curr_exp," Sessions:",string(human_stats_map(strcat(curr_exp," Number of Data Points")))), ...
            strcat("Number Of ",curr_exp," Subjects:",      string(human_stats_map(strcat(curr_exp," Number Of Unique Subjects")))), ...
            strcat("Number of ",curr_exp_2," Sessions:",    string(human_stats_map(strcat(curr_exp_2," Number of Data Points")))), ...
            strcat("Number of ",curr_exp_2," Subjects:",    string(human_stats_map(strcat(curr_exp_2," Number Of Unique Subjects")))), ...
            strcat("Date Created:",string(datetime("today",'Format','MM-d-yyyy'))), ...
            "Created By compare\_human\_data\_to\_human\_data\_using\_dg\_for\_sig.m"])


        saveas(gcf,strcat(dir_to_save_figs_to,"\Experiment 1 ", curr_exp," Experiment 2 ",curr_exp_2, "P-Value Per DG_chi2test3 ",string(p),".fig"),"fig");

    end


    % all_cluster_counts_by_story(curr_exp) = cluster_counts;
    % all_cluster_percentages_by_story(curr_exp) = cluster_counts /number_of_data_points_for_current_experiments;

end

end