function [] =get_average_xyz_per_human_experiment_using_table_and_weights(human_data_table, C,dir_to_save_figs_to,human_stats_map,weights)
dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);

hs = [];
story_types = unique(human_data_table.experiment);
figure('units','normalized','outerposition',[0 0 1 1])
title_strings = [];
for s=1:length(story_types)
    story_type = story_types(s);
    disp(story_type)
    
    current_exp_data = human_data_table(strcmpi(human_data_table.experiment,story_type),:); %get the sigmoid data and put it into a table
    unique_clusters = unique(current_exp_data.cluster_number);

    array_of_means_for_clusters = zeros(size(unique_clusters,1),3);

    weights_for_current_experiment = weights(string(story_type));
    %get the sample data
    all_weighted_means_for_curr_exp = [];
    all_std_errors_for_curr_exp = [];
    for m=1:1000
        sample_data = [];
        for i=1:length(unique_clusters)
            current_cluster = unique_clusters(i);
            current_cluster_data = current_exp_data(current_exp_data.cluster_number==current_cluster,:);
            data_to_examine = [current_cluster_data.clusterX,current_cluster_data.clusterY,current_cluster_data.clusterZ];
            sample_data = [sample_data;data_to_examine(randi([1 size(data_to_examine,1)],1,1),:)];
        end
        % disp("weights")
        % disp(weights_for_current_experiment)
        % disp("sample data")
        % disp(sample_data)
        weighted_mean_col_1 = mean(sample_data(:,1),Weights=weights_for_current_experiment');
        weighted_mean_col_2 = mean(sample_data(:,2),Weights=weights_for_current_experiment');
        weighted_mean_col_3 = mean(sample_data(:,3),Weights=weights_for_current_experiment');

        weighted_mean = [weighted_mean_col_1,weighted_mean_col_2,weighted_mean_col_3];
        all_weighted_means_for_curr_exp = [all_weighted_means_for_curr_exp;weighted_mean];
        xyz_std = std(sample_data,weights_for_current_experiment);
        xyz_std_error = xyz_std / sqrt(size(sample_data,1));
        all_std_errors_for_curr_exp = [all_std_errors_for_curr_exp;xyz_std_error];
    end
    xyz_mean = mean(all_weighted_means_for_curr_exp);
    xyz_std_error = mean(all_std_errors_for_curr_exp);
    h = scatter3(xyz_mean(1),xyz_mean(2),xyz_mean(3),'o', C(s));
    hold on;
    plot3([xyz_mean(1),xyz_mean(1)]',[xyz_mean(2),xyz_mean(2)]',[-(xyz_std_error(3)),xyz_std_error(3)]'+xyz_mean(3)',C(s));
    plot3([-xyz_std_error(1),xyz_std_error(1)]'+xyz_mean(1)',[xyz_mean(2),xyz_mean(2)]',[xyz_mean(3),xyz_mean(3)]',C(s));
    plot3([xyz_mean(1),xyz_mean(1)]',[-xyz_std_error(2),xyz_std_error(2)]'+xyz_mean(2),[xyz_mean(3),xyz_mean(3)]',C(s));

    % title_strings = [title_strings, strcat(strrep(story_type,"_","\_"), " Number of Data Points",string(height(current_exp_data)), " Number Of Subjects:", string(human_stats_map(strcat(string(story_type)," Number Of Unique Subjects"))))];
    % 
    % 
    % hs = [hs; h];
end
legend(hs,story_types)
title([title_strings,"Created using 1000 weighted means calculated using 1 sample from each cluster",...
    strcat("Date Created:",string(datetime("today",'Format','MM-d-yyyy'))), ...
    "Created By get\_average\_xyz\_per\_human\_experiment\_using\_table\_and\_weights.m"]);
saveas(gcf,strcat(dir_to_save_figs_to,"\All Human Data Average XYZ.fig"),"fig")
end