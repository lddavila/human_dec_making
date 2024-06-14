%% Human New Tasks Run Me

datasource = 'live_database'; %ENTER YOUR DATASOURCE NAME HERE, default should be "live_database"
username = 'postgres'; %ENTER YOUR USERNAME HERE, default should be "postgres"
password = '1234'; %ENTER YOUR PASSWORD HERE, default should be "1234"

% ingest data
[init_approach_data, r_ratings, c_ratings] = get_new_task();
approach_data = clean_ingested_new_task(init_approach_data);

%add new column for story type 
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

%% filter down to just people who are hungry
appr_avoid_sessions_hungry ={};
for i=1:length(appr_avoid_sessions)
    current_data = appr_avoid_sessions{i};
    hunger_rows = current_data(current_data.hunger>50,:);
    if height(hunger_rows)>0
        appr_avoid_sessions_hungry{end+1} = hunger_rows;
    end
end

%% filter down to just people who are not hungry
appr_avoid_sessions_not_hungry ={};
for i=1:length(appr_avoid_sessions)
    current_data = appr_avoid_sessions{i};
    hunger_rows = current_data(current_data.hunger<=50,:);
    if height(hunger_rows)>0
        appr_avoid_sessions_not_hungry{end+1} = hunger_rows;
    end
end