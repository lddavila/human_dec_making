function [all_histogram_counts] =create_histograms_by_experiment(data_table)
    list_of_unique_experiments = unique(data_table.experiment);
    figure;
    legend_string =[];
    all_histogram_counts = [];
    for i=1:length(list_of_unique_experiments)
        current_experiment = string(list_of_unique_experiments(i));
        legend_string = [legend_string,current_experiment];
        table_with_only_current_experiment = data_table(strcmpi(data_table.experiment,current_experiment),:);
        all_xyz_of_curr_experiment = [table_with_only_current_experiment.clusterX,table_with_only_current_experiment.clusterY,table_with_only_current_experiment.clusterZ];
        h = histogram(all_xyz_of_curr_experiment,6,Normalization='probability');
        all_histogram_counts = [all_histogram_counts;h.Values];
        title(current_experiment)
        ylabel("Probability")
        xlabel("Bins")
        hold on;
    end
    legend(legend_string)
end