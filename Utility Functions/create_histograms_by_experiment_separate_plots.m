function [all_histogram_counts] =create_histograms_by_experiment_separate_plots(data_table)
    list_of_unique_experiments = unique(data_table.experiment);
    figure;
    legend_string =[];
    all_histogram_counts = [];
    % figure;
    
    for i=1:length(list_of_unique_experiments)
        subplot(length(list_of_unique_experiments),1,i)
        current_experiment = string(list_of_unique_experiments(i));
        legend_string = [legend_string,current_experiment];
        table_with_only_current_experiment = data_table(strcmpi(data_table.experiment,current_experiment),:);
        all_xyz_of_curr_experiment = [table_with_only_current_experiment.clusterX,table_with_only_current_experiment.clusterY,table_with_only_current_experiment.clusterZ];
        h = histogram(all_xyz_of_curr_experiment,Normalization='probability');
        % all_histogram_counts = [all_histogram_counts;h.Values];
        title(current_experiment)
        ylabel("Probability")
        xlabel("Bins")
        ylim([0,0.5])
        legend(current_experiment)
        hold on;
    end
    
end