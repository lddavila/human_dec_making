function [all_ys] = plot_avg_spec_cluster_psychs_dont_split_by_story(spectral_table, all_data, same_scale, story_types, save_to, want_plot,version_name)

[totals,~] = setup_for_avgs(all_data,story_types,1,0); % returns a cell array where each item is a table with only a single experiment type
all_data_together = [totals{1};totals{2};totals{3};totals{4}];
    if want_plot
        all_ys = create_avg_psych_dont_split_by_story(all_data_together,psychs_in_spec_cluster(spectral_table),"all together"+version_name,same_scale,save_to);
    end

end