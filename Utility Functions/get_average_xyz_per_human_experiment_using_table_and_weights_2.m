function [] =get_average_xyz_per_human_experiment_using_table_and_weights_2(human_data_table, C,dir_to_save_figs_to,human_stats_map,weights,version_name)
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
    array_of_stds_for_clusters = zeros(size(unique_clusters,1),3);
    array_of_std_errs_for_clusters = zeros(size(unique_clusters,1),3);

    weights_for_current_experiment = weights(string(story_type));
    %get the sample data
    for i=1:length(unique_clusters)
        current_cluster = unique_clusters(i);
        current_cluster_data = current_exp_data(current_exp_data.cluster_number ==current_cluster,:);
        current_cluster_xyz = [current_cluster_data.clusterX,current_cluster_data.clusterY,current_cluster_data.clusterZ];
        array_of_means_for_clusters(i,:) = mean(current_cluster_xyz);
        array_of_stds_for_clusters(i,:) = std(current_cluster_xyz);

        array_of_std_errs_for_clusters(i,:) = array_of_stds_for_clusters(i,:) / sqrt(size(current_cluster_data,1));
    end
    
    %weigh the means and standard errors and cluster std
    weighed_cluster_means = zeros(size(array_of_means_for_clusters,1),size(array_of_means_for_clusters,2));
    weighed_cluster_std = zeros(size(array_of_means_for_clusters,1),size(array_of_means_for_clusters,2));
    weighed_std_error = zeros(size(array_of_means_for_clusters,1),size(array_of_means_for_clusters,2));
    for i=1:length(unique_clusters)
       weighed_cluster_means(i,:) = array_of_means_for_clusters(i,:) * weights_for_current_experiment(i);
       weighed_cluster_std(i,:) = array_of_stds_for_clusters(i,:) * weights_for_current_experiment(i);
       weighed_std_error(i,:) = array_of_std_errs_for_clusters(i,:) * weights_for_current_experiment(i);
    end

    xyz_mean = sum(weighed_cluster_means,1);
    xyz_std_error = sum(weighed_std_error,1);



    h = scatter3(xyz_mean(1),xyz_mean(2),xyz_mean(3),'o', C(s));
    hold on;
    plot3([xyz_mean(1),xyz_mean(1)]',[xyz_mean(2),xyz_mean(2)]',[-(xyz_std_error(3)),xyz_std_error(3)]'+xyz_mean(3)',C(s));
    plot3([-xyz_std_error(1),xyz_std_error(1)]'+xyz_mean(1)',[xyz_mean(2),xyz_mean(2)]',[xyz_mean(3),xyz_mean(3)]',C(s));
    plot3([xyz_mean(1),xyz_mean(1)]',[-xyz_std_error(2),xyz_std_error(2)]'+xyz_mean(2),[xyz_mean(3),xyz_mean(3)]',C(s));

    title_strings = [title_strings, strcat(strrep(story_type,"_","\_"), " Number of Data Points",string(height(current_exp_data)), " Number Of Subjects:", string(human_stats_map(strcat(string(story_type)," Number Of Unique Subjects"))))];
    % 
    % 
    hs = [hs; h];
end
legend(hs,story_types)
title([title_strings,"Created Using weighted means of each cluster",...
    strcat("Date Created:",string(datetime("today",'Format','MM-d-yyyy'))), ...
    "Created By get\_average\_xyz\_per\_human\_experiment\_using\_table\_and\_weights\_2.m", ...
    version_name]);
saveas(gcf,strcat(dir_to_save_figs_to,"\All Human Data Average XYZ ",version_name,".fig"),"fig")
end