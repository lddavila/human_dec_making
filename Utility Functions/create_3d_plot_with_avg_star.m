function [] = create_3d_plot_with_avg_star(human_data_table,dir_to_save_figs_to,distinguishable_colors,remove_propotion,how_much_to_keep,which_cluster)
dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);
unique_expeirments = unique(human_data_table.experiment);
unique_clusters = unique(human_data_table.cluster_number);


for i=1:length(unique_expeirments)
    curr_exp = unique_expeirments(i);
    figure;
    hs =[];
    legend_strings = [];
    means_of_each_cluster =cell(1,length(unique_clusters));
    % plot the clusters and get ths mean xyz of each cluster
    rows_to_keep = [];
    for j=1:length(unique_clusters)
        current_cluster_color = distinguishable_colors(j,:);
        curr_clust = unique_clusters(j);
        table_of_relevant_data = human_data_table(human_data_table.cluster_number == curr_clust & strcmpi(human_data_table.experiment,curr_exp),:);
        if remove_propotion && curr_clust == which_cluster
            table_of_relevant_data = datasample(table_of_relevant_data,(round(how_much_to_keep*height(table_of_relevant_data))));
            rows_to_keep = [rows_to_keep;table_of_relevant_data];
        else
            rows_to_keep =[rows_to_keep;table_of_relevant_data];
        end
        
        h = scatter3(table_of_relevant_data.clusterX,table_of_relevant_data.clusterY,table_of_relevant_data.clusterZ,'x','MarkerEdgeColor',current_cluster_color);
        hold on;
        hs = [hs,h];
        legend_strings = [legend_strings,strcat("Cluster ",string(curr_clust))];
        means_of_each_cluster{j} = mean([table_of_relevant_data.clusterX,table_of_relevant_data.clusterY,table_of_relevant_data.clusterZ]);
    end
    %get the mean xyz of current experiment and plot it
    table_of_curr_exp = human_data_table(strcmpi(human_data_table.experiment,curr_exp),:);

    if remove_propotion
        data_to_keep = string(rows_to_keep.clusterLabels);
        table_of_curr_exp = table_of_curr_exp(ismember(table_of_curr_exp.clusterLabels,data_to_keep),:);
    end
    xyz = [table_of_curr_exp.clusterX,table_of_curr_exp.clusterY,table_of_curr_exp.clusterZ];
    xyz_mean = mean(xyz);
    std_of_xyz = std(xyz);
    xyz_std_error = std_of_xyz / sqrt(size(xyz,1));

    h = scatter3(xyz_mean(1),xyz_mean(2),xyz_mean(3),'o', 'k');
    hs = [hs,h];

    %plot the first standard error along the xyz axies
    plot3([xyz_mean(1),xyz_mean(1)]',[xyz_mean(2),xyz_mean(2)]',[-(xyz_std_error(3)),xyz_std_error(3)]'+xyz_mean(3)','k');
    plot3([-xyz_std_error(1),xyz_std_error(1)]'+xyz_mean(1)',[xyz_mean(2),xyz_mean(2)]',[xyz_mean(3),xyz_mean(3)]','k');
    plot3([xyz_mean(1),xyz_mean(1)]',[-xyz_std_error(2),xyz_std_error(2)]'+xyz_mean(2),[xyz_mean(3),xyz_mean(3)]','k');


    %get probabilities of each cluster for current experiment data
    current_probabilities = get_cluster_counts(table_of_curr_exp,unique_clusters) ./ size(xyz,1);
    disp(curr_exp);
    disp(current_probabilities);

    % draw lines from each of the current experiments to the average point where line thickness is 
    for j=1:length(current_probabilities)
        current_cluster_color = distinguishable_colors(j,:);
        current_probability = current_probabilities(j);
        mean_of_current_cluster = means_of_each_cluster{j};
        plot3([mean_of_current_cluster(1),xyz_mean(1)]',[mean_of_current_cluster(2),xyz_mean(2)]',[mean_of_current_cluster(3),xyz_mean(3)]','LineWidth',current_probability*10,'MarkerEdgeColor',current_cluster_color,'MarkerFaceColor',current_cluster_color,'Color',current_cluster_color);
    end
    
    title(curr_exp);
    xlabel("log(abs(max))");
    ylabel("log(abs(shift))");
    zlabel("log(abs(slope))");
    legend(hs,[legend_strings,"average xyz of task"])
    xlim([-20 20])
    ylim([-20 20])
    zlim([-20 20])
    set(gcf,'renderer','Painters');
    saveas(gcf,strcat(dir_to_save_figs_to,"\",curr_exp,".fig"),"fig")
    hold off;
end
end