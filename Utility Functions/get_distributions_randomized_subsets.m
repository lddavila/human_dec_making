function [] = get_distributions_randomized_subsets(data_table,dir_to_save_figs_to)
unique_clusters = unique(data_table.cluster_number);
unique_experiments = unique(data_table.experiment);
dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);
all_cluster_probabilities = {cell(1000,1),cell(1000,1),cell(1000,1),cell(1000,1)};
for i=1:1000
    randomized_subsets = datasample(data_table,round((1/3) * height(data_table)));
    cluster_counts_normalized = get_cluster_counts_2(randomized_subsets,unique_experiments,unique_clusters,1);
    for j=1:length(unique_experiments)
        curr_exp = unique_experiments{j};
        all_cluster_probabilities{j}{i} = cluster_counts_normalized(curr_exp);
    end
end

for i=1:length(unique_experiments)
    current_data = cell2mat(all_cluster_probabilities{i});
    curr_exp = unique_experiments{i};
    means = mean(current_data);
    means = round(means,2);
    stds = std(current_data);
    figure;
    b = bar(means);
    title(["Mean Probabilities of Clusters for ", strrep(curr_exp,"_","\_"), "After taking 1000 random samplings of 30% of data"]);

    x_tips = b.XEndPoints;
    y_tips = b.YEndPoints;
    labels = string(b.YData);
    text(x_tips,y_tips,labels,'HorizontalAlignment','center',...
        'VerticalAlignment','bottom')
    hold on;

    errorbar(x_tips,means,stds,stds,'LineStyle','none');

    saveas(gcf,strcat(dir_to_save_figs_to,"\",curr_exp,".fig"),"fig")

end

end