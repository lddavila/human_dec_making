function [] = get_average_sig_by_cluster_and_experiment(human_data_table,same_scale,story_types,want_plot,dir_to_save_figs_to_1,dir_to_save_figs_to_2,experiment_to_use)
dir_to_save_figs_to_1 = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to_1);
dir_to_save_figs_to_2 = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to_2);

% ingest data
[init_approach_data, r_ratings, c_ratings] = get_new_task();
approach_data = clean_ingested_new_task(init_approach_data);

%add new column for story type 
[approach_data] = add_story_column_loop(approach_data);

% get data w enough trials 
min_num_sessions = 2;
[N_trial_data, idxs] = filter_hum_appr_data(approach_data, 16*min_num_sessions);


% separate each individual story out by type
appr_avoid_sessions = sessions_by_tasktype(N_trial_data, "approach_avoid");
social_sessions = sessions_by_tasktype(N_trial_data, "social");
probability_sessions = sessions_by_tasktype(N_trial_data, "probability");
moral_sessions = sessions_by_tasktype(N_trial_data, "moral");


% dictate what experiment data to use
if experiment_to_use == "approach_avoid"
    all_data = {appr_avoid_sessions,{}};
elseif experiment_to_use =="social"
    all_data = {social_sessions,{}};
elseif experiment_to_use == "probability"
    all_data = {probability_sessions,{}};
elseif experiment_to_use =="moral"
    all_data = {moral_sessions,{}};
end


% all_data = {appr_avoid_sessions,social_sessions,probability_sessions,moral_sessions};

plot_avg_spec_cluster_psychs(human_data_table,all_data,same_scale,story_types,dir_to_save_figs_to_1,want_plot) 
plot_avg_spec_cluster_psychs_for_whole_experiment(human_data_table,all_data,story_types,dir_to_save_figs_to_2,want_plot)
end