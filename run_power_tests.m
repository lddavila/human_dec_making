%% get the mean and standard deviation along the axis for session_cost_100 data
%make sure to run session_cost_clustering_figures_threshold_100 first
appr_avoid_rows = select_single_experiment_from_data_set_2(human_data_table,"approach_avoid");
social_rows = select_single_experiment_from_data_set_2(human_data_table,"social");
moral_rows =select_single_experiment_from_data_set_2(human_data_table,"moral"); 
probability_rows = select_single_experiment_from_data_set_2(human_data_table,"probability");

appr_avoid_mean = mean([appr_avoid_rows.clusterX,appr_avoid_rows.clusterY,appr_avoid_rows.clusterZ]);
social_mean = mean([social_rows.clusterX,social_rows.clusterY,social_rows.clusterZ]);
moral_mean = mean([moral_rows.clusterX,moral_rows.clusterY,moral_rows.clusterZ]);
probability_mean = mean([probability_rows.clusterX,probability_rows.clusterY,probability_rows.clusterZ]);

appr_avoid_std_dvn = ((std([appr_avoid_rows.clusterX,appr_avoid_rows.clusterY,appr_avoid_rows.clusterZ]))/sqrt(size(appr_avoid_rows,1)));
social_std_dvn = ((std([social_rows.clusterX,social_rows.clusterY,social_rows.clusterZ]))/sqrt(size(social_rows,1)));
moral_std_dvn =  ((std([moral_rows.clusterX,moral_rows.clusterY,moral_rows.clusterZ]))/sqrt(size(moral_rows,1)));
probability_std_dvn = ((std([probability_rows.clusterX,probability_rows.clusterY,probability_rows.clusterZ]))/sqrt(size(probability_rows,1)));


%% run a power analysis

testtype = 't2';
p0 =[];
%If testtype is 't2', then p0 is a two-element array [mu0,sigma0] of the mean and standard deviation, 
% respectively, of the first sample under the null and alternative hypotheses.
p1 =[];
%If testtype is 't2', then p1 is the value of the mean of the second sample under the alternative hypothesis.
pwr = sampsizepwr('t2',[appr_avoid_mean(1) appr_avoid_std_dvn(1)],probability_mean(1),[],height(probability_rows),'Ratio',size(appr_avoid_rows,1)/size(probability_rows,1));
disp(pwr)

%% 
perform_power_t_test_and_get_heat_map(human_data_table,"doesnt matter")

