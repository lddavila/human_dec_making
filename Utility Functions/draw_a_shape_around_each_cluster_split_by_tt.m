function [] = draw_a_shape_around_each_cluster_split_by_tt(data_table,stats_map,human_or_rat,what_data,dir_to_save_figs_to,draw_lines_or_dont,colors)
unique_exps = unique(data_table.experiment);
for i=1:length(unique_exps)
    curr_experiment = unique_exps(i);
    curr_exp = data_table(strcmpi(string(data_table.experiment),curr_experiment),:);
    draw_a_shape_around_each_cluster(curr_exp,stats_map,human_or_rat,curr_experiment,dir_to_save_figs_to,draw_lines_or_dont,colors);
end
end