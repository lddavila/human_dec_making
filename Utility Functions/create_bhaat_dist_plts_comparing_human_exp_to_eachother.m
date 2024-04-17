function [] = create_bhaat_dist_plts_comparing_human_exp_to_eachother(data_table,dir_to_save_figs_to,distinct_colors,human_stats_map)
unique_clusters = unique(data_table.cluster_number);
unique_experiments = unique(data_table.experiment);
dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);

for i=1:length(unique_experiments)
    curr_exp_1 = unique_experiments(i);
    exp_1_data = data_table(strcmpi(curr_exp_1,data_table.experiment),:);
    for j=i+1:length(unique_experiments)
        curr_exp_2 = unique_experiments(j);
        exp_2_data = data_table(strcmpi(curr_exp_2,data_table.experiment),:);
        array_of_bhaat_distance = zeros(1,length(unique_clusters));
        figure('units','normalized','outerposition',[0 0 1 1]);
        subplot(1,2,1);
        legend_strings = [];
        x_tick_for_bar = cell(1,length(unique_clusters));
        for k=1:length(unique_clusters) 
            exp_1_color = distinct_colors(k,:);
            exp_2_color = distinct_colors(end-k,:);
            curr_clust = unique_clusters(k);
            exp_1_clust_k_data = exp_1_data(exp_1_data.cluster_number==curr_clust,:);
            exp_2_clust_k_data = exp_2_data(exp_2_data.cluster_number==curr_clust,:);

            exp_1_xyz = [exp_1_clust_k_data.clusterX,exp_1_clust_k_data.clusterY,exp_1_clust_k_data.clusterZ];
            exp_1_labels = logical(ones(size(exp_1_xyz,1),1));
            exp_2_xyz = [exp_2_clust_k_data.clusterX,exp_2_clust_k_data.clusterY,exp_2_clust_k_data.clusterZ];
            exp_2_labels = logical(zeros(size(exp_2_xyz,1),1));

            scatter3(exp_1_xyz(:,1),exp_1_xyz(:,2),exp_1_xyz(:,3),'x','MarkerEdgeColor',exp_1_color);
            hold on;
            scatter3(exp_2_xyz(:,1),exp_2_xyz(:,2),exp_2_xyz(:,3),'o','MarkerEdgeColor',exp_2_color);

            legend_strings = [legend_strings;strrep(strcat(curr_exp_1," Cluster ",string(curr_clust)),"_","\_");strrep(strcat(curr_exp_2," Cluster ",string(curr_clust)),"_","\_")];

            if ~all([length(exp_1_xyz)>2,length(exp_2_xyz)>2,length(exp_1_labels)>2,length(exp_2_labels)>2])
                array_of_bhaat_distance(k) = NaN;
            else
                array_of_bhaat_distance(k) = mean(bhattacharyyaDistance([exp_1_xyz;exp_2_xyz],[exp_1_labels;exp_2_labels]));
            end

            

            x_tick_for_bar{k} = char(strcat("Cluster ",string(curr_clust))); 
        end

        cluster_counts_for_exp_1 = get_cluster_counts(exp_1_data,unique_clusters);
        cluster_counts_for_exp_2 = get_cluster_counts(exp_2_data,unique_clusters);

        [p,~] = chi2test([cluster_counts_for_exp_1;cluster_counts_for_exp_2]);

        X = categorical(x_tick_for_bar);
        X = reordercats(X,x_tick_for_bar);
        legend(legend_strings);
        title(strcat(curr_exp_1," Vs ",curr_exp_2))
        set(gcf,'renderer','Painters');

        disp(strcat("Meaan bhaat_distance of ",curr_exp_1," Vs ",curr_exp_2));
        array_of_bhaat_distance(isinf(array_of_bhaat_distance))=NaN;
        disp(array_of_bhaat_distance);
        disp(mean(array_of_bhaat_distance,'omitmissing'));

        subplot(1,2,2)
        bar(X,array_of_bhaat_distance);
        xlabel("Cluster");
        ylabel("mean bhaat distance");
        title(strcat("Mean bhaat distance Between ",curr_exp_1," Clusters Vs ",curr_exp_2, " Clusters"))
        set(gcf,'renderer','Painters');

        


        sgtitle([strcat("Experiment 1: ", curr_exp_1," Experiment 2: ",curr_exp_2, "P-Value Per chi2test: ",string(p)), ...
            strcat("Number Of ",curr_exp_1," Sessions:",      string(human_stats_map(strcat(curr_exp_1," Number of Data Points")))), ...
            strcat("Number Of ",curr_exp_1," Subjects:",      string(human_stats_map(strcat(curr_exp_1," Number Of Unique Subjects")))), ...
            strcat("Number of ",curr_exp_2," Sessions:",    string(human_stats_map(strcat(curr_exp_2," Number of Data Points")))), ...
            strcat("Number of ",curr_exp_2," Subjects:",    string(human_stats_map(strcat(curr_exp_2," Number Of Unique Subjects")))), ...
            strcat("Date Created:",string(datetime("today",'Format','MM-d-yyyy'))), ...
            "Created By create\_bhaat\_dist\_plts\_comparing\_human\_exp\_to\_eachother.m"])

        saveas(gcf,strcat(dir_to_save_figs_to,"\","Mean bhaat distance Between ",curr_exp_1," Clusters Vs ",curr_exp_2, " Clusters.fig"),"fig")
    end
end


end