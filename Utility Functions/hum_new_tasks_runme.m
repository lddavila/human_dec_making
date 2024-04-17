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




%% avg map per task

story_types = ["approach_avoid", "social", "probability", "moral"];
data{1} = appr_avoid_combined_data;
data{2} = social_combined_data;
data{3} = probability_combined_data;
data{4} = moral_combined_data;
path_to_save = strcat(pwd,"\avg dec maps");
want_bdry = 1;
want_scale = 1;
want_save = 1;

avg_data = cell(1,4);

for i = 1:4
    combined_data = data{i};
    story_type = story_types{i};
    tot_table = [];
    for N = 1:length(combined_data)
        curr_data = combined_data{N};
        if ~isempty(curr_data)
            tot_table = [tot_table; curr_data];
        end
    end
    avg_table = [];
    for r = 1:4
        for c = 1:4
            all_r_c = tot_table(tot_table.rew == r & tot_table.cost == c, :);
            r_c_row = all_r_c(1,:);
            r_c_row.subjectidnumber = "scaled avg";
            r_c_row.approach_rate = mean(all_r_c.approach_rate, 'omitnan');
            avg_table = [avg_table; r_c_row];
        end
    end
    avg_data{i} = avg_table;
    make_dec_making_plots(avg_table, path_to_save, story_type,want_bdry,want_scale)
end

