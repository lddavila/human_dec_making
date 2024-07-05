%% ingest data
[init_approach_data, r_ratings, c_ratings] = get_new_task();
approach_data = clean_ingested_new_task(init_approach_data);

% add new column for story type 
[approach_data] = add_story_column_loop(approach_data);

% get data w enough trials 
min_num_sessions = 2;
[N_trial_data, idxs] = filter_hum_appr_data(approach_data, 16*min_num_sessions);

% combine trials for dec maps
appr_avoid_combined_data = combine_for_map(N_trial_data, "approach_avoid");
social_combined_data = combine_for_map(N_trial_data, "social");
probability_combined_data = combine_for_map(N_trial_data, "probability");
moral_combined_data = combine_for_map(N_trial_data, "moral");

% separate each individual story out by type
appr_avoid_sessions = sessions_by_tasktype(N_trial_data, "approach_avoid");
social_sessions = sessions_by_tasktype(N_trial_data, "social");
probability_sessions = sessions_by_tasktype(N_trial_data, "probability");
moral_sessions = sessions_by_tasktype(N_trial_data, "moral");

%%

want_bdry = 1;
want_scale = 1;
story_types = ["approach_avoid", "social", "probability", "moral"];
data{1} = appr_avoid_combined_data;
data{2} = social_combined_data;
data{3} = probability_combined_data;
data{4} = moral_combined_data;
path_to_save = strcat(pwd,'\dec making maps');
dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path("dec making maps");
for i = 1:4
    combined_data = data{i};
    story_type = story_types{i};
    for N = 1:length(combined_data)
        curr_data = combined_data{N};
        if ~isempty(curr_data)
            make_dec_making_plots(curr_data, path_to_save, story_type,want_bdry,want_scale)
        end
    end
end