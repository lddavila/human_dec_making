function [] = run_permutations_based_on_meta_data_no_story_pref(human_data_table,all_data,all_data_order,colors,version_name,threshold,what_percentage_must_be_significant,surrounding_directory)

    function [reformatted_data_table] = reformat_human_data_table(human_data_table)
        human_data_table.clusterLabels = string(human_data_table.clusterLabels);
        human_data_table.experiment = string(human_data_table.experiment);
        subjectid_story_and_cost = split(human_data_table.clusterLabels,"_");
        subjectidnumber = str2double(subjectid_story_and_cost(:,1));
        story_num = subjectid_story_and_cost(:,3);
        story_col = subjectid_story_and_cost(:,2);
        the_underscore = repelem("_",size(story_col,1),1);
        story_num = strcat(story_col,the_underscore,story_num);
        cost = str2double(strrep(subjectid_story_and_cost(:,5),".mat",""));

        reformatted_data_table = table(subjectidnumber,story_num,cost);
        reformatted_data_table = [human_data_table,reformatted_data_table];
    end

    function [reformatted_all_data] = reformat_all_data(all_data)
        reformatted_all_data = cell(1,length(all_data));
        for i=1:size(all_data,2)
            curr_exp_data = all_data{i};
            curr_exp = curr_exp_data{1};
            for j=2:size(curr_exp_data,2)
                curr_exp = [curr_exp;curr_exp_data{j}];
            end
            reformatted_all_data{i} = curr_exp;
        end
    end


    function [significant_changes,var_significance_matrix,mean_significance_matrix,y_labels,p] = check_for_significant_differences(lower_bound_table,upper_bound_table,unique_clusters,threshold,what_percentage_must_be_significant,hunger_threshold,tiredness_threshold,pain_threshold,preference_threshold)
        lower_bound_cluster_counts = get_cluster_counts(lower_bound_table,unique_clusters);
        upper_bound_cluster_counts = get_cluster_counts(upper_bound_table,unique_clusters);
        [p,~] = chi2test([lower_bound_cluster_counts;upper_bound_cluster_counts]);

        significant_changes = false;
        if p<threshold
            significant_changes = true;
            disp("Had Significant Change In Density")
            disp(p);
            disp(strcat("Found For Hunger Threshold:",string(hunger_threshold)," Tiredness Threshold:",string(tiredness_threshold)," Pain Threshold:",string(pain_threshold)));
        end

        number_of_significances_to_beat = length(unique_clusters) * 3 * what_percentage_must_be_significant;
        number_of_significances_from_mean = 0;
        number_of_significances_from_var = 0;

        mean_significance_matrix = [];
        var_significance_matrix = [];

        y_labels = cell(1,length(unique_clusters));

        for i=1:length(unique_clusters)


            curr_clust = unique_clusters(i);
            y_labels{i} = char(strcat("Human Cluster: ",string(curr_clust)));
            % disp(strcat("Current Cluster: ",string(curr_clust)))
            lower_bound_curr_clust = lower_bound_table(lower_bound_table.cluster_number == curr_clust,:);
            lower_bound_data = [lower_bound_curr_clust.clusterX,lower_bound_curr_clust.clusterY,lower_bound_curr_clust.clusterZ];

            upper_bound_curr_clust = upper_bound_table(upper_bound_table.cluster_number == curr_clust,:);
            upper_bound_data = [upper_bound_curr_clust.clusterX,upper_bound_curr_clust.clusterY,upper_bound_curr_clust.clusterZ];

            % clc;
            % disp(lower_bound_data);
            % disp(upper_bound_data);
            if size(upper_bound_data,1)==1 || size(lower_bound_data,1) == 1
                pm = [1 1 1];
                pv = [1 1 1];
            else
                [~, pm] = ttest2(upper_bound_data,lower_bound_data);
                [hv, pv] = vartest2(upper_bound_data,lower_bound_data);
            end

            number_of_significances_from_mean = number_of_significances_from_mean+  sum(pm < threshold,"all");
            mean_significance_matrix = [mean_significance_matrix;pm];
            % disp("Change in mean")
            % disp(hm)
            % disp(pm)

            var_significance_matrix = [var_significance_matrix;pv];
            number_of_significances_from_var = number_of_significances_from_var+ sum(pv < threshold,"all");
            % disp("Change In Variance")
            % % disp(hv)
            % disp(pv)
            % disp("/////////////////////////")
        end
        if number_of_significances_from_var+number_of_significances_from_mean >= number_of_significances_to_beat
            significant_changes = true;
            disp(strcat("Found at least:",string(number_of_significances_to_beat)))
            disp(strcat("Actually Found:",string(number_of_significances_from_mean + number_of_significances_from_var)))
            disp(strcat("Number of Significances Found From Mean:",string(number_of_significances_from_mean)))
            disp(mean_significance_matrix);
            disp(strcat("Number of Significances Found From Variance:",string(number_of_significances_from_var)))
            disp(var_significance_matrix)
            disp(strcat("Found For Hunger Threshold:",string(hunger_threshold)," Tiredness Threshold:",string(tiredness_threshold)," Pain Threshold:",string(pain_threshold)," Story Pref Threshold ",string(0)));
            disp("/////////////////////")
        end
    end

    function [] = create_heat_map_of_significant_changes(heat_map_matrix_mean,heat_map_matrix_var,y_labels,hunger_threshold,tiredness_threshold,pain_threshold,p,number_of_dp_in_lower_threshold,number_of_dp_in_upper_threshold,threshold,dir_to_save_figs_to)
        % colormap(flip(sky));
        figure('units','normalized','outerposition',[0 0 1 1])
        subplot(1,2,1);
        heatmap({'log(abs(max))','log(abs(shift))','log(abs(slope))'},y_labels,heat_map_matrix_mean)
        colormap(flip(sky));
        title(["Significant Changes In Mean Determined By ttest2", ...
            strcat("Split At Hunger:", string(hunger_threshold)," Tiredness: ",string(tiredness_threshold)," Pain: ",string(pain_threshold)," Story Pref: ",string(0)), ...
            strcat("Significant Change In Density Determined by Chi Squared:",string(p)), ...
            strcat("# of Data Points In lower threshold:",string(number_of_dp_in_lower_threshold)," upper threshold:",string(number_of_dp_in_upper_threshold)) ...
            strcat("# of significant Changes in Mean:",string(sum(heat_map_matrix_mean<threshold,"all")))]);
        % figure;
        subplot(1,2,2);
        heatmap({'log(abs(max))','log(abs(shift))','log(abs(slope))'},y_labels,heat_map_matrix_var)
        colormap(flip(sky));
        title(["Significant Changes In Variance Determined By vartest2", ...
            strcat("Split At Hunger:", string(hunger_threshold)," Tiredness: ",string(tiredness_threshold)," Pain: ",string(pain_threshold)), ...
            strcat("Significant Change In Density Determined by Chi Squared:",string(p)), ...
            strcat("# of Data Points In lower threshold:",string(number_of_dp_in_lower_threshold)," upper threshold:",string(number_of_dp_in_upper_threshold)), ...
            strcat("# of significant Changes In Variance:",string(sum(heat_map_matrix_var<threshold,"all")))]);

        saveas(gcf,strcat(dir_to_save_figs_to,"\Heat Maps For Sig Changes In Variance and Mean Chi Squared ",string(round(p,3)),".fig"),"fig")
        % saveas(gcf,strcat(dir_to_save_figs_to,"\Heat Maps For Sig Changes In Variance and Mean Chi Squared ",string(round(p,3)),".svg"),"svg")
    end

    function [which_is_bigger] = check_which_is_bigger_and_return_the_result(upper_bound_table,lower_bound_table)
        which_is_bigger = "";
        if height(lower_bound_table) < height(upper_bound_table)
            which_is_bigger = "Upper";
        elseif height(lower_bound_table) > height(upper_bound_table)
            which_is_bigger = "Lower";
        elseif height(lower_bound_table) == height(upper_bound_table)
            which_is_bigger = "Neither";
        end
    end

    function [reduced_size_table] = get_random_sample_based_on_size(bigger_table,smaller_table)
        proportion_of_smaller_table_which_takes_up_bigger_table = height(smaller_table) / height(bigger_table);
        number_of_rows_to_take_from_big_table = round(proportion_of_smaller_table_which_takes_up_bigger_table * height(bigger_table));
        reduced_size_table = datasample(bigger_table,height(smaller_table));
    end
surrounding_directory = create_a_file_if_it_doesnt_exist_and_ret_abs_path(surrounding_directory);
home_dir = cd(surrounding_directory);
experiments = unique(human_data_table.experiment);
experiments = string(experiments);
clusters_list = unique(human_data_table.cluster_number);

reformatted_data_table = reformat_human_data_table(human_data_table);
reformatted_all_data = reformat_all_data(all_data);

hunger_table = [];
for k=1:length(all_data_order)
    hunger_table =[hunger_table; get_average_hunger_by_cost(all_data{k},"","cost")];

end

table_with_hunger = join(reformatted_data_table,hunger_table,'Keys',{'clusterLabels','experiment'});

for hunger_threshold=0:10:100
    for tiredness_threshold=0:10:100
        for pain_threshold=0:10:100

            table_of_upper_thresholds = table_with_hunger(table_with_hunger.average_hunger >= hunger_threshold & table_with_hunger.tiredness >= tiredness_threshold & table_with_hunger.pain >= pain_threshold,:);
            table_of_lower_thresholds = table_with_hunger(table_with_hunger.average_hunger < hunger_threshold & table_with_hunger.tiredness < tiredness_threshold & table_with_hunger.pain < pain_threshold,:);
            if size(table_of_upper_thresholds,1) <1 || size(table_of_lower_thresholds,1)<1
                continue;
            end



            [found_significant_changes,var_significance_matrix,mean_significance_matrix,y_labels,p] = check_for_significant_differences(table_of_lower_thresholds,table_of_upper_thresholds,unique(human_data_table.cluster_number),threshold,what_percentage_must_be_significant,hunger_threshold,tiredness_threshold,pain_threshold,0);

            dir_to_save_figs_to = strcat("3d Cluster Plots Hunger split at ",string(hunger_threshold)," Tiredness Split At ",string(tiredness_threshold)," Pain Split At ",string(pain_threshold)," Story Prefs Greater Than", string(0), "chi squared ",string(round(p,3)));
            if found_significant_changes
                human_lower_bound_stats_map = get_human_data_table_stats(table_of_lower_thresholds);
                create3d_cluster_plot_for_human_hunger(table_of_lower_thresholds,colors,"Human","Lower Bound",dir_to_save_figs_to,human_lower_bound_stats_map,version_name,strcat("Hunger <",string(hunger_threshold)," Tiredness <",string(tiredness_threshold)," Pain <",string(pain_threshold), " Story Prefs >=", string(0)),unique(human_data_table.cluster_number),p);
                human_upper_bound_stats_map = get_human_data_table_stats(table_of_upper_thresholds);
                create3d_cluster_plot_for_human_hunger(table_of_upper_thresholds,colors,"Human","Upper Bound",dir_to_save_figs_to,human_upper_bound_stats_map,version_name,strcat("Hunger >=",string(hunger_threshold)," Tiredness >=",string(tiredness_threshold)," Pain >=",string(pain_threshold), " Story Prefs >=", string(0)),unique(human_data_table.cluster_number),p);


                create_heat_map_of_significant_changes(mean_significance_matrix,var_significance_matrix,y_labels,hunger_threshold,tiredness_threshold,pain_threshold,p,height(table_of_lower_thresholds),height(table_of_upper_thresholds),threshold,dir_to_save_figs_to);

                which_is_bigger = check_which_is_bigger_and_return_the_result(table_of_upper_thresholds,table_of_lower_thresholds);

                % if strcmpi(which_is_bigger,"Upper")
                %     smaller_upper_table = get_random_sample_based_on_size(table_of_upper_thresholds,table_of_lower_thresholds);
                %     human_upper_bound_stats_map = get_human_data_table_stats(smaller_upper_table);
                %     create3d_cluster_plot_for_human_hunger(smaller_upper_table,colors,"Human","Upper Bound Smaller",dir_to_save_figs_to,human_upper_bound_stats_map,version_name,strcat("Hunger >",string(hunger_threshold)," Tiredness >",string(tiredness_threshold)," Pain >",string(pain_threshold), " Story Prefs >", string(preference_threshold)),unique(human_data_table.cluster_number));
                %
                %
                % elseif strcmpi(which_is_bigger,"Lower")
                %     smaller_lower_table = get_random_sample_based_on_size(table_of_lower_thresholds,table_of_upper_thresholds);
                %     human_lower_bound_stats_map = get_human_data_table_stats(smaller_upper_table);
                %     create3d_cluster_plot_for_human_hunger(smaller_lower_table,colors,"Human","Lower Bound Smaller",dir_to_save_figs_to,human_lower_bound_stats_map,version_name,strcat("Hunger <",string(hunger_threshold)," Tiredness <",string(tiredness_threshold)," Pain <",string(pain_threshold), " Story Prefs >", string(preference_threshold)),unique(human_data_table.cluster_number));
                %
                % elseif strcmpi(which_is_bigger,"Neither")
                % end
                close all;


            end


        end

    end
end
cd(home_dir);

% lower_bound_hunger_table = table_with_hunger(table_with_hunger.average_hunger <=hunger_threshold_to_use(1),:);
% upper_bound_hunger_table = table_with_hunger(table_with_hunger.average_hunger >= hunger_threshold_to_use(2),:);

% dir_to_save_figs_to = strcat("3d Cluster Plots By Hunger Lower Bound ",string(hunger_threshold_to_use(1)), " Upper Bound ", string(hunger_threshold_to_use(2)));
% human_lower_bound_stats_map = get_human_data_table_stats(lower_bound_hunger_table);
% create3d_cluster_plot_for_human_hunger(lower_bound_hunger_table,colors,strcat("Human Hunger"," less than or equal to",string(hunger_threshold_to_use(1))),strcat("Human Hunger"," less than or equal to",string(hunger_threshold_to_use(1))),dir_to_save_figs_to,human_lower_bound_stats_map,version_name);
% 
% human_upper_bound_stats_map = get_human_data_table_stats(upper_bound_hunger_table);
% create3d_cluster_plot_for_human_hunger(upper_bound_hunger_table,colors,strcat("Human Hunger"," greater than or equal to",string(hunger_threshold_to_use(2))),strcat("Human Hunger"," greater than or equal to",string(hunger_threshold_to_use(2))),dir_to_save_figs_to,human_upper_bound_stats_map,version_name);
% 
% check_for_significant_differences(lower_bound_hunger_table,upper_bound_hunger_table,unique(human_data_table.cluster_number));

end