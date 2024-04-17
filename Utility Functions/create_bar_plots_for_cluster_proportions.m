function [] = create_bar_plots_for_cluster_proportions(data_table,do_it_in_one_plot,dir_to_save_figs_to,human_stats_map)
dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);
unique_clusters = unique(data_table.cluster_number);
unique_experiments = unique(data_table.experiment);
all_probabilities_matrix = [];
legend_strings = cell(1,length(unique_experiments));
bar_x = cell(1,length(unique_clusters));
for i=1:length(unique_clusters)
    curr_cluster = unique_clusters(i);
    bar_x{i} = char(strcat("Cluster ",string(curr_cluster)));
end
X = categorical(bar_x);
X = reordercats(X,bar_x);

for i=1:length(unique_experiments)
    curr_exp = string(unique_experiments(i));
    legend_strings{i} = curr_exp;
    only_curr_exp = data_table(strcmpi(data_table.experiment,curr_exp),:);
    number_of_data_points_for_current_experiments = size(only_curr_exp,1);
    cluster_counts = get_cluster_counts(only_curr_exp,unique_clusters);
    current_cluster_probabilities = cluster_counts ./ number_of_data_points_for_current_experiments;
    all_probabilities_matrix = [all_probabilities_matrix;current_cluster_probabilities];

end
if do_it_in_one_plot
    b = bar(X,all_probabilities_matrix.');
    for i=1:size(all_probabilities_matrix,1)
        x_tips = b(i).XEndPoints;
        y_tips = b(i).YEndPoints;
        labels = string(round(b(i).YData,2));
        text(x_tips,y_tips,labels,'HorizontalAlignment','center',...
            'VerticalAlignment','bottom')
    end
    title(["Human Cluster Proportions", ...
        strcat("# of approach avoid sessions",string(human_stats_map("approach_avoid Number of Data Points"))),...
        strcat("# of moral sessions",string(human_stats_map("moral Number of Data Points"))),...
        strcat("# of probability sessions",string(human_stats_map("probability Number of Data Points"))),...
        strcat("# of social sessions",string(human_stats_map("social Number of Data Points"))),...
        strcat("Date Created:",string(datetime("today",'Format','MM-d-yyyy'))), ...
        "Created By create\_bar\_plots\_for\_cluster\_proportions.m"]);
    legend(legend_strings);
    saveas(gcf,strcat(dir_to_save_figs_to,"\Human Cluster Proportions.fig"),"fig");



else
    for i=1:length(unique_clusters)
        figure('units','normalized','outerposition',[0 0 1 1]);
        b = bar(strrep(unique_experiments,"_","\_"),all_probabilities_matrix(:,i));
        x_tips = b.XEndPoints;
        y_tips = b.YEndPoints;
        labels = string(round(b.YData,2));
        text(x_tips,y_tips,labels,'HorizontalAlignment','center',...
            'VerticalAlignment','bottom')
        title([strcat("Human Cluster Proportions For Cluster",string(i)), ...
            strcat("# of approach avoid sessions",string(human_stats_map("approach_avoid Number of Data Points"))),...
            strcat("# of moral sessions",string(human_stats_map("moral Number of Data Points"))),...
            strcat("# of probability sessions",string(human_stats_map("probability Number of Data Points"))),...
            strcat("# of social sessions",string(human_stats_map("social Number of Data Points"))),...
            strcat("Date Created:",string(datetime("today",'Format','MM-d-yyyy'))), ...
            "Created By create\_bar\_plots\_for\_cluster\_proportions.m"]);
        saveas(gcf,strcat(dir_to_save_figs_to,"\Human Cluster Proportions For Cluster",string(i),".fig"),"fig");
    end
end

figure('units','normalized','outerposition',[0 0 1 1]);
inv_prob = all_probabilities_matrix.';
for i=1:size(inv_prob,2)
    scatter3(inv_prob(1,i).',inv_prob(2,i).',inv_prob(4,i).');
    hold on;
end
xlabel("Cluster 1 Propotion");
ylabel("Cluster 2 Propotion");
zlabel("Cluster 4 Propotion");

legend("approach\_avoid","moral","probability","social")