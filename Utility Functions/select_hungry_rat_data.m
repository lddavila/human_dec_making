function [] = select_hungry_rat_data(human_data_table,hunger_threshold_to_use,all_data)

    function [reformatted_data_table] = reformat_human_data_table(human_data_table)
        human_data_table.clusterLabels = string(human_data_table.clusterLabels);
        subjectid_story_and_cost = split(human_data_table.clusterLabels,"_");
        subjectid = subjectid_story_and_cost(:,1);
        story = subjectid_story_and_cost(:,3);
        cost = strrep(subjectid_story_and_cost(:,5),".mat","");

        reformatted_data_table = table(subjectid,story,cost);
        reformatted_data_table = [human_data_table,reformatted_data_table];


    end
    experiments = unique(human_data_table.experiment);
    experiments = string(experiments);
    clusters_list = unique(human_data_table.cluster_number);

    reformatted_data_table = reformat_human_data_table(human_data_table);

    

end