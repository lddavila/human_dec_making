function create_avg_psych_for_whole_experiment(sesh_data, psych_to_cluster, type, save_to,experiment)

clusters = unique(psych_to_cluster.idx);
num_clusters = length(clusters);

ax = zeros(num_clusters,1);
y_min = 100;
y_max = 0;

sesh_info = psych_to_cluster; %take only the rows of psych_to_cluster which have the belong to the current cluster

story_num = sesh_info.story_num;
cost_lvl = sesh_info.cost;
subid = sesh_info.subjectidnumber;

% before (which was wrong) was:
% sesh_table = sesh_data(ismember(sesh_data.story_num,story_num) &...
% ismember(sesh_data.cost,cost_lvl) &...
% ismember(sesh_data.subjectidnumber,subid), :);

merge = outerjoin(sesh_info,sesh_data,'Keys',{'cost','story_num','subjectidnumber'});
sesh_table = merge(~isnan(merge.idx),:);

lvl_1 = sesh_table(sesh_table.rew == 1, :).approach_rate;
lvl_2 = sesh_table(sesh_table.rew == 2, :).approach_rate;
lvl_3 = sesh_table(sesh_table.rew == 3, :).approach_rate;
lvl_4 = sesh_table(sesh_table.rew == 4, :).approach_rate;

mean_lvl_1 = mean(lvl_1, 'omitnan');
mean_lvl_2 = mean(lvl_2, 'omitnan');
mean_lvl_3 = mean(lvl_3, 'omitnan');
mean_lvl_4 = mean(lvl_4, 'omitnan');

x = [1,2,3,4];
y = [mean_lvl_1, mean_lvl_2, mean_lvl_3, mean_lvl_4];


if  ~anynan(x) && ~anynan(y)
    [fit_object_to_be_returned,gof_to_be_returned,type_of_fit] = fit_sigmoid(x,y);
end
disp(experiment)
disp(fit_object_to_be_returned)
disp(gof_to_be_returned.rsquare)

title([experiment + type_of_fit, "R SQ" + gof_to_be_returned.rsquare])


figname = save_to + "/" + strrep(type," ", "_") + ".fig";

savefig(figname)
close all
end