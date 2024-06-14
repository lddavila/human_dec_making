function [] = create_a_bhaat_dist_tree_comparing_human_to_human(human_data_table,human_stats_map,version_name,dir_to_save_figs_to,the_title,only_do_relevant_comparisons)
dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);
human_clusters = unique(human_data_table.cluster_number);
array_of_bhaat_distance = zeros(length(human_clusters)+length(human_clusters),length(human_clusters)+length(human_clusters));
human_experiments = unique(human_data_table.experiment);


for j=1:length(human_experiments)
    exp_1 = human_experiments{j};
    exp_1_table = human_data_table(strcmpi(human_data_table.experiment,exp_1),:);

    for k=j+1:length(human_experiments)
        exp_2 = human_experiments{k};
        exp_2_table = human_data_table(strcmpi(human_data_table.experiment,exp_2),:);


        array_of_bhaat_distance = zeros(length(human_clusters)*2,length(human_clusters)*2);
        for i=1:length(human_clusters)
            clust_1 = human_clusters(i);
            exp_1_clust_i = exp_1_table(exp_1_table.cluster_number ==clust_1,:);
            exp_1_clust_i_data = [exp_1_clust_i.clusterX,exp_1_clust_i.clusterY,exp_1_clust_i.clusterZ];
            exp_1_clust_i_labels = logical(zeros(height(exp_1_clust_i),1));
            for p=1:length(human_clusters)
                clust_2 = human_clusters(p);
                if only_do_relevant_comparisons && clust_1 ~=clust_2
                    continue;
                end
                exp_2_clust_p = exp_2_table(exp_2_table.cluster_number==clust_2,:);
                exp_2_clust_p_data = [exp_2_clust_p.clusterX,exp_2_clust_p.clusterY,exp_2_clust_p.clusterZ];
                exp_2_clust_p_labels = logical(zeros(height(exp_2_clust_p),1)+1);

                array_of_bhaat_distance(i,p+length(human_clusters)) = mean(bhattacharyyaDistance([exp_1_clust_i_data;exp_2_clust_p_data],[exp_1_clust_i_labels;exp_2_clust_p_labels]));
                if isnan(array_of_bhaat_distance(i,p+length(human_clusters)))
                    array_of_bhaat_distance(i,p+length(human_clusters)) = 0;
                end
                array_of_bhaat_distance(p+length(human_clusters),i) = mean(bhattacharyyaDistance([exp_1_clust_i_data;exp_2_clust_p_data],[exp_1_clust_i_labels;exp_2_clust_p_labels]));
                if isnan(array_of_bhaat_distance(p+length(human_clusters),i))
                    array_of_bhaat_distance(p+length(human_clusters),i) = 0;
                end
            end
        end
        cluster_labels = [];
        for i=1:length(human_clusters)*2
            if i<=length(human_clusters)
                cluster_labels = [cluster_labels;strcat(exp_1," Cluster ",string(i))];
            else
                cluster_labels = [cluster_labels;strcat(exp_2," Cluster ",string(i-9))];
            end
        end

        figure('units','normalized','outerposition',[0 0 1 1])
        disp(array_of_bhaat_distance)
        disp(size(array_of_bhaat_distance))
        disp(cluster_labels)
        disp(size(cluster_labels))
        G = graph(array_of_bhaat_distance,cluster_labels);
        LWidths = 5*G.Edges.Weight/max(G.Edges.Weight);
        cmap = colormap("hsv");
        flip(colormap);
        % plot(G,'XData',array_of_mean_xyz(:,1),'YData',array_of_mean_xyz(:,2),'ZData',array_of_mean_xyz(:,3),'EdgeLabel',G.Edges.Weight,'LineWidth',LWidths);
        p=plot(G,'EdgeLabel',G.Edges.Weight,'LineWidth',LWidths,'Layout','layered','EdgeCData',G.Edges.Weight,'EdgeColor','flat','MarkerSize',20);
        title([strcat(the_title, exp_1, " vs ",exp_2),...
            strcat("Number of ",exp_1," Sessions: ",string(human_stats_map(strcat(exp_1,' Number of Data Points')))," Number of ",exp_1," Subjects: ",string(human_stats_map(strcat(exp_1,' Number Of Unique Subjects')))), ...
            strcat("Number of ",exp_2, "Sessions: ",string(human_stats_map(strcat(exp_2,' Number of Data Points')))," Number of ",exp_2," Subjects: ",string(human_stats_map(strcat(exp_2,' Number Of Unique Subjects')))), ...
            strcat("Date Created:",string(datetime("today",'Format','MM-d-yyyy'))), ...
            "Created by create\_a\_bhaat\_dist\_tree\_comparing\_human\_to\_human", ...
            version_name]);
        c = colorbar;
        c.Label.String = "Mean Bhaatycharya distance";

        saveas(gcf,strcat(dir_to_save_figs_to,"\Bhaat distance Tree Graph ",exp_1," vs ",exp_2," " ,version_name),"fig")





    end
end



end