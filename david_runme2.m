
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

%%
% clc;
want_bdry = 0;
want_scale = 0;
story_types = ["approach_avoid", "social", "probability", "moral"];
data{1} = appr_avoid_combined_data;
data{2} = social_combined_data;
data{3} = probability_combined_data;
data{4} = moral_combined_data;
path_to_save = 'average_sigmoids';
all_data = {appr_avoid_sessions,social_sessions,probability_sessions,moral_sessions};

plot_avg_spec_cluster_psychs(human_data_table,all_data,1,story_types,"average_sigmoids",1) 
plot_avg_spec_cluster_psychs_for_whole_experiment(human_data_table,all_data,story_types,"average_sigmoids_3",1)



% all_non_aa_data = {};
% for i=1:length(social_sessions)
%     all_non_aa_data{end+1} = social_sessions{i};
% end
% for i=1:length(probability_sessions)
%     all_non_aa_data{end+1} = probability_sessions{i};
% end
% for i=1:length(moral_sessions)
%     all_non_aa_data{end+1} = moral_sessions{i};
% end
% 
% all_non_s_data = {};
% for i=1:length(appr_avoid_sessions)
%     all_non_s_data{end+1} = appr_avoid_sessions{i};
% end
% for i=1:length(probability_sessions)
%     all_non_s_data{end+1} = probability_sessions{i};
% end
% for i=1:length(moral_sessions)
%     all_non_s_data{end+1} = moral_sessions{i};
% end
% 
% all_non_m_data = {};
% for i=1:length(appr_avoid_sessions)
%     all_non_m_data{end+1} = appr_avoid_sessions{i};
% end
% for i=1:length(probability_sessions)
%     all_non_m_data{end+1} = probability_sessions{i};
% end
% for i=1:length(social_sessions)
%     all_non_m_data{end+1} = social_sessions{i};
% end
% 
% all_non_p_data = {};
% for i=1:length(appr_avoid_sessions)
%     all_non_p_data{end+1} = appr_avoid_sessions{i};
% end
% for i=1:length(social_sessions)
%     all_non_p_data{end+1} = social_sessions{i};
% end
% for i=1:length(moral_sessions)
%     all_non_p_data{end+1} = moral_sessions{i};
% end
% plot_avg_spec_cluster_psychs(table_with_aa_proportions,{all_non_aa_data,{}},1,["approach_avoid"],"average_sigmoids_2",1)
% plot_avg_spec_cluster_psychs(table_with_m_proportions,{all_non_m_data,{}},1,["moral"],"average_sigmoids_2",1)
% plot_avg_spec_cluster_psychs(table_with_s_proportions,{all_non_s_data,{}},1,["social"],"average_sigmoids_2",1)
% plot_avg_spec_cluster_psychs(table_with_p_proportions,{all_non_p_data,{}},1,["probability"],"average_sigmoids_2",1)
% for i = 1:4
%     combined_data = data{i};
% end