function all_psych_data = plot_avg_spec_cluster_psychs(spectral_table, all_data, same_scale, story_types, save_to, want_plot)

[totals,~] = setup_for_avgs(all_data,story_types,1,0); % returns a cell array where each item is a table with only a single experiment type

all_psych_data = [];
for s = 1:length(story_types)
    story_type = story_types(s); %get a current experiment
    disp(story_type);
    spectral_table.clusterLabels = string(spectral_table.clusterLabels);
    spectral_table.experiment = string(spectral_table.experiment);
    story_table = spectral_table(spectral_table.experiment == story_type, :); % take only the rows of spectral table which match the current story
    sesh_data = totals{s}; %get the session data for the current experiment, stored in totals

    psych_to_cluster = psychs_in_spec_cluster(story_table); %
    all_psych_data = [all_psych_data; psych_to_cluster];

    if want_plot
        create_avg_psych(sesh_data,psych_to_cluster,story_type + " spectral",same_scale,save_to)
    end
end
end