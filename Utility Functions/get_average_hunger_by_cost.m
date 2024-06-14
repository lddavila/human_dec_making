function[table_of_average_hunger_by_cost] = get_average_hunger_by_cost(approach_data, dirName, sig_type)
    function[single_row_of_average_hunger] = get_single_row_of_average_hunger(results, c, thresh, dirName, sig_type)
        
        if ~isempty(results)
            if sig_type == "cost" 
                constant_lvl = results(results.cost == c,:);
                x = constant_lvl.rew.';
            else
                constant_lvl = results(results.rew == c,:);
                x = constant_lvl.cost.';
            end
            y = constant_lvl.approach_rate.';
        
            if length(y) >= 4 && all(~isnan(y))
             subid = constant_lvl.subjectidnumber(1);
             story_num = constant_lvl.story_num(1);

             average_hunger_level = mean(constant_lvl.hunger);
             average_tiredness_level = mean(constant_lvl.tiredness);
             average_pain_level = mean(constant_lvl.pain);
             sex = string(constant_lvl.sex{1,1});
             age = string(constant_lvl.age{1,1});
             average_story_prefs = mean(constant_lvl.story_prefs);
             

             clusterLabel = strcat(string(subid),"_",string(story_num),"_cost_",string(c),".mat");

             experiment = string(constant_lvl.story_type(1,1));

             single_row_of_average_hunger = table(clusterLabel,average_hunger_level,experiment,average_tiredness_level,sex,age,average_pain_level,average_story_prefs, ...
                 'VariableNames', ...
                 ["clusterLabels","average_hunger","experiment","tiredness","sex","age","pain","story_prefs"]);

            else
                single_row_of_average_hunger = cell2table(cell(0,8), ...
                    'VariableNames', ...
                    ["clusterLabels","average_hunger","experiment","tiredness","sex","age","pain","story_prefs"]);
            end
        end
end
          
thresh = 0.4;
N = length(approach_data);
table_of_average_hunger_by_cost = cell2table(cell(0,8), ...
    "VariableNames", ...
    ["clusterLabels","average_hunger","experiment","tiredness","sex","age","pain","story_prefs"]);
for i = 1:N
    results = approach_data{i};
    maxc = max(results.cost);
    
    for c = 1:maxc
        table_of_average_hunger_by_cost = [table_of_average_hunger_by_cost;get_single_row_of_average_hunger(results, c, thresh, dirName, sig_type)];
    end
end

end