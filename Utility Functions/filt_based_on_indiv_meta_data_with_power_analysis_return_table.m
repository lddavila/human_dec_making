function [return_table] = filt_based_on_indiv_meta_data_with_power_analysis_return_table(human_data_table,all_data,all_data_order,colors,version_name,threshold,what_percentage_must_be_significant,surrounding_directory,filter_to_use,perform_power_analysis,add_gender)

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


    function [significant_changes,var_significance_matrix,mean_significance_matrix,y_labels,p,pwrout_for_x,pwrout_for_y,pwrout_for_z,resized_lower_bound_table,resized_upper_bound_table] = check_for_significant_differences(lower_bound_table,upper_bound_table,unique_clusters,threshold,what_percentage_must_be_significant,the_threshold,preference_threshold,filter_to_use,perform_power_analysis,s)
        
        if perform_power_analysis
            if size(lower_bound_table,1) > size(upper_bound_table,1)
                n = size(upper_bound_table,1);
                resized_lower_bound_table = datasample(s,lower_bound_table,n,'Replace',false);
                resized_upper_bound_table = upper_bound_table;
                lower_bound_table = resized_lower_bound_table;
            elseif size(lower_bound_table,1) <= size(upper_bound_table,1)
                n=size(lower_bound_table,1);
                resized_upper_bound_table = datasample(s,upper_bound_table,n,'Replace',false);
                resized_lower_bound_table = lower_bound_table;
                upper_bound_table = resized_upper_bound_table;
            end
        else
            resized_lower_bound_table = lower_bound_table;
            resized_upper_bound_table = upper_bound_table;
        end


        lower_bound_cluster_counts = get_cluster_counts(lower_bound_table,unique_clusters);
        upper_bound_cluster_counts = get_cluster_counts(upper_bound_table,unique_clusters);
        [p,~] = chi2test([lower_bound_cluster_counts;upper_bound_cluster_counts]);

        significant_changes = false;
        if p<threshold
            significant_changes = true;
            % disp("Had Significant Change In Density")
            % disp(p);
            % disp(strcat("Found For Hunger Threshold:",string(hunger_threshold)," Tiredness Threshold:",string(tiredness_threshold)," Pain Threshold:",string(pain_threshold)));

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
            % significant_changes = true;
            disp(strcat("Found at least:",string(number_of_significances_to_beat)))
            disp(strcat("Actually Found:",string(number_of_significances_from_mean + number_of_significances_from_var)))
            disp(strcat("Number of Significances Found From Mean:",string(number_of_significances_from_mean)))
            disp(mean_significance_matrix);
            disp(strcat("Number of Significances Found From Variance:",string(number_of_significances_from_var)))
            disp(var_significance_matrix)
            disp(strcat("Found For ",filter_to_use," Threshold:",string(the_threshold)," Story Pref Threshold: ",string(preference_threshold)));
            disp("/////////////////////")
        end


        clc;
        disp("lower bound data")
        disp([resized_lower_bound_table.clusterX,resized_lower_bound_table.clusterY,resized_lower_bound_table.clusterZ])
        disp("upper bound data")
        disp([resized_upper_bound_table.clusterX,resized_upper_bound_table.clusterY,resized_upper_bound_table.clusterZ])

        var_of_entire_lower_threshold_data_set = var([resized_lower_bound_table.clusterX,resized_lower_bound_table.clusterY,resized_lower_bound_table.clusterZ],0,1);
        var_of_entire_upper_threshold_data_set = var([resized_upper_bound_table.clusterX,resized_upper_bound_table.clusterY,resized_upper_bound_table.clusterZ],0,1);

        clc;
        disp("Variances of lower threshold")
        disp(var_of_entire_lower_threshold_data_set)
        disp("variances of upper threshold")
        disp(var_of_entire_upper_threshold_data_set)
        if perform_power_analysis
            if var_of_entire_lower_threshold_data_set(1) == 0 || var_of_entire_upper_threshold_data_set(1) == 0
                pwrout_for_x = NaN;
            else
                pwrout_for_x = sampsizepwr('var',var_of_entire_lower_threshold_data_set(1),var_of_entire_upper_threshold_data_set(1),[],n);
            end
            if var_of_entire_lower_threshold_data_set(2) == 0 || var_of_entire_upper_threshold_data_set(2) == 0
                pwrout_for_y = NaN;
            else
                pwrout_for_y = sampsizepwr('var',var_of_entire_lower_threshold_data_set(2),var_of_entire_upper_threshold_data_set(2),[],n);
            end

            if var_of_entire_lower_threshold_data_set(3) == 0 || var_of_entire_upper_threshold_data_set(3) == 0
                pwrout_for_z= NaN;
            else
                pwrout_for_z = sampsizepwr('var',var_of_entire_lower_threshold_data_set(3),var_of_entire_upper_threshold_data_set(3),[],n);
            end
        else
            pwrout_for_x = NaN;
            pwrout_for_y = NaN;
            pwrout_for_z = NaN;
        end




        %pwrout = sampsizepwr(testtype,p0,p1,[],n) returns the power achieved for a sample size of n when the true parameter value is p1.
        %If testtype is 'var', then p0 is the variance under the null hypothesis.
        % If testtype is 'var', then p1 is the variance under the alternative hypothesis.

    end

    function [most_affected_cluster,net_increase_or_decrease] = determine_which_cluster_is_most_effected(lower_threshold_table,upper_threshold_table,unique_clusters)
        lower_threshold_proportions = get_cluster_counts(lower_threshold_table,unique_clusters) ./ size(lower_threshold_table,1);
        upper_threshold_proportions = get_cluster_counts(upper_threshold_table,unique_clusters) ./ size(upper_threshold_table,1);

        max_diff = 0;
        max_diff_index = NaN;
        net_increase_or_decrease = 0;
        for i=1:length(lower_threshold_proportions)
            diff = lower_threshold_proportions(i) - upper_threshold_proportions(i);
            if abs(diff) > max_diff
                max_diff = abs(diff);
                max_diff_index = unique_clusters(i);
                if diff < 0
                    net_increase_or_decrease = abs(diff);
                else
                    net_increase_or_decrease = diff *-1;
                end

            end
        end
        most_affected_cluster = max_diff_index;
    end
    function [highest_power_analysis_result,highest_dimension] = check_which_dimension_creates_highest_power_analysis(pwr_for_X,pwr_for_Y,pwr_for_Z,perform_power_analysis)
        highest_power_analysis_result = NaN;
        highest_dimension = "Power Analysis Not Performed";
        if perform_power_analysis
            highest_power_analysis_result = 0;
            if pwr_for_X > highest_power_analysis_result
                highest_power_analysis_result = pwr_for_X;
                highest_dimension= "Log(abs(max))";
            end
            if pwr_for_Y > highest_power_analysis_result
                highest_power_analysis_result = pwr_for_Y;
                highest_dimension = "Log(abs(shift))";
            end
            if pwr_for_Z > highest_power_analysis_result
                highest_power_analysis_result = pwr_for_Z;
                highest_dimension = "Log(abs(slope))";
            end
        else
            highest_power_analysis_result = NaN;
            highest_dimension = "Power Analysis Not Performed";
        end
    end

    function [return_table] = perform_analysis_without_gender(table_with_hunger,filter_to_use,unique_clusters,perform_power_analysis,human_data_table,threshold,what_percentage_must_be_significant,s)
        return_table = [];
        for the_threshold=0:10:100
            for preference_threshold=0:10:100
                table_of_upper_thresholds = table_with_hunger(table_with_hunger.(filter_to_use) >= the_threshold & table_with_hunger.story_prefs >= preference_threshold,:);
                table_of_lower_thresholds = table_with_hunger(table_with_hunger.(filter_to_use) < the_threshold & table_with_hunger.story_prefs >= preference_threshold,:);
                if size(table_of_upper_thresholds,1) <1 || size(table_of_lower_thresholds,1)<1
                    continue;
                end



                [found_significant_changes,var_significance_matrix,mean_significance_matrix,y_labels,p,pwrout_for_x,pwrout_for_y,pwrout_for_z,resized_lower_bound_table,resized_upper_bound_table] = check_for_significant_differences(table_of_lower_thresholds,table_of_upper_thresholds,unique(human_data_table.cluster_number),threshold,what_percentage_must_be_significant,the_threshold,preference_threshold,filter_to_use,perform_power_analysis,s);

                table_of_lower_thresholds = resized_lower_bound_table;
                table_of_upper_thresholds = resized_upper_bound_table;
                % dir_to_save_figs_to = strcat(current_gender," 3d Cluster Plots ",filter_to_use ," split at ",string(the_threshold)," Story Pref Min ", string(preference_threshold), "chi squared ",string(round(p,3)));
                %
                % power_string = strcat("From sampsizepwr we get X:",string(pwrout_for_x), " Y:",string(pwrout_for_y), " Z:",string(pwrout_for_z));
                % human_lower_bound_stats_map = get_human_data_table_stats(table_of_lower_thresholds);
                % % create3d_cluster_plot_for_human_data_with_power(table_of_lower_thresholds,colors,"Human","Lower Bound",dir_to_save_figs_to,human_lower_bound_stats_map,version_name,strcat(filter_to_use," <",string(the_threshold)," Story Prefs >=", string(preference_threshold)),unique(human_data_table.cluster_number),p,power_string);
                % human_upper_bound_stats_map = get_human_data_table_stats(table_of_upper_thresholds);
                % create3d_cluster_plot_for_human_data_with_power(table_of_upper_thresholds,colors,"Human","Upper Bound",dir_to_save_figs_to,human_upper_bound_stats_map,version_name,strcat(filter_to_use," >=",string(the_threshold), " Story Prefs >=", string(preference_threshold)),unique(human_data_table.cluster_number),p,power_string);
                [most_affected_cluster,net_increase_or_decrease] = determine_which_cluster_is_most_effected(table_of_lower_thresholds,table_of_upper_thresholds,unique_clusters);

                [highest_power_analysis_result,highest_dimension] = check_which_dimension_creates_highest_power_analysis(pwrout_for_x,pwrout_for_y,pwrout_for_z,perform_power_analysis);

                % filter_to_use, is_it_significant_or_not, cluster_proportions, chi_squared Result, power_analysis_result,number_of_data_points,p_value,most_affected_cluster,net_increase_or_decrease

                row_label = strcat(filter_to_use," ","Split At:",string(the_threshold)," Story Pref:",string(preference_threshold)," Male & Female ",create_row_label(perform_power_analysis,0,filter_to_use));
                return_table = [return_table;table(row_label,filter_to_use,the_threshold,preference_threshold,"Mixed",found_significant_changes,p,highest_power_analysis_result,highest_dimension,height(table_of_lower_thresholds),height(table_of_upper_thresholds),most_affected_cluster,strcat(string(round(net_increase_or_decrease,2)*100),"%"), ...
                    'VariableNames', ...
                    ["rowLabel","MetaData","splittingPoint","storyPref","gender","Significant","pValue","powerAnalysis","dimension","<SplitSize",">=SplitSize","mostAffectedCluster","changeInProportion"])];

                % create_heat_map_of_significant_changes(mean_significance_matrix,var_significance_matrix,y_labels,the_threshold,p,height(table_of_lower_thresholds),height(table_of_upper_thresholds),threshold,dir_to_save_figs_to,preference_threshold,filter_to_use);

                close all;


            end



        end
    end
    function [return_table] = perform_analysis_with_gender(table_with_hunger,filter_to_use,unique_clusters,perform_power_analysis,human_data_table,threshold,what_percentage_must_be_significant,s)
        unique_genders = unique(table_with_hunger.sex);
        return_table = [];
        for gender_counter=1:length(unique_genders)
            curr_gender = unique_genders(gender_counter);
            for the_threshold=0:10:100
                for preference_threshold=0:10:100
                    table_of_upper_thresholds = table_with_hunger(table_with_hunger.(filter_to_use) >= the_threshold & table_with_hunger.story_prefs >= preference_threshold & strcmpi(table_with_hunger.sex,curr_gender),:);
                    table_of_lower_thresholds = table_with_hunger(table_with_hunger.(filter_to_use) < the_threshold & table_with_hunger.story_prefs >= preference_threshold & strcmpi(table_with_hunger.sex,curr_gender),:);
                    if size(table_of_upper_thresholds,1) <1 || size(table_of_lower_thresholds,1)<1
                        continue;
                    end



                    [found_significant_changes,var_significance_matrix,mean_significance_matrix,y_labels,p,pwrout_for_x,pwrout_for_y,pwrout_for_z,resized_lower_bound_table,resized_upper_bound_table] = check_for_significant_differences(table_of_lower_thresholds,table_of_upper_thresholds,unique(human_data_table.cluster_number),threshold,what_percentage_must_be_significant,the_threshold,preference_threshold,filter_to_use,perform_power_analysis,s);

                    table_of_lower_thresholds = resized_lower_bound_table;
                    table_of_upper_thresholds = resized_upper_bound_table;
                    % dir_to_save_figs_to = strcat(current_gender," 3d Cluster Plots ",filter_to_use ," split at ",string(the_threshold)," Story Pref Min ", string(preference_threshold), "chi squared ",string(round(p,3)));
                    %
                    % power_string = strcat("From sampsizepwr we get X:",string(pwrout_for_x), " Y:",string(pwrout_for_y), " Z:",string(pwrout_for_z));
                    % human_lower_bound_stats_map = get_human_data_table_stats(table_of_lower_thresholds);
                    % % create3d_cluster_plot_for_human_data_with_power(table_of_lower_thresholds,colors,"Human","Lower Bound",dir_to_save_figs_to,human_lower_bound_stats_map,version_name,strcat(filter_to_use," <",string(the_threshold)," Story Prefs >=", string(preference_threshold)),unique(human_data_table.cluster_number),p,power_string);
                    % human_upper_bound_stats_map = get_human_data_table_stats(table_of_upper_thresholds);
                    % create3d_cluster_plot_for_human_data_with_power(table_of_upper_thresholds,colors,"Human","Upper Bound",dir_to_save_figs_to,human_upper_bound_stats_map,version_name,strcat(filter_to_use," >=",string(the_threshold), " Story Prefs >=", string(preference_threshold)),unique(human_data_table.cluster_number),p,power_string);
                    [most_affected_cluster,net_increase_or_decrease] = determine_which_cluster_is_most_effected(table_of_lower_thresholds,table_of_upper_thresholds,unique_clusters);

                    [highest_power_analysis_result,highest_dimension] = check_which_dimension_creates_highest_power_analysis(pwrout_for_x,pwrout_for_y,pwrout_for_z,perform_power_analysis);

                    % filter_to_use, is_it_significant_or_not, cluster_proportions, chi_squared Result, power_analysis_result,number_of_data_points,p_value,most_affected_cluster,net_increase_or_decrease

                    row_label = strcat(filter_to_use," Split At:",string(the_threshold)," Story Pref:",string(preference_threshold)," ",curr_gender," ",create_row_label(perform_power_analysis,1,filter_to_use));
                    return_table = [return_table;table(row_label,filter_to_use,the_threshold,preference_threshold,curr_gender,found_significant_changes,p,highest_power_analysis_result,highest_dimension,height(table_of_lower_thresholds),height(table_of_upper_thresholds),most_affected_cluster,strcat(string(round(net_increase_or_decrease,2)*100),"%"), ...
                        'VariableNames', ...
                        ["rowLabel","MetaData","splittingPoint","storyPref","gender","Significant","pValue","powerAnalysis","dimension","<SplitSize",">=SplitSize","mostAffectedCluster","changeInProportion"])];

                    % create_heat_map_of_significant_changes(mean_significance_matrix,var_significance_matrix,y_labels,the_threshold,p,height(table_of_lower_thresholds),height(table_of_upper_thresholds),threshold,dir_to_save_figs_to,preference_threshold,filter_to_use);

                    % close all;


                end



            end
        end
    end

    function [row_label] = create_row_label(perform_power_analysis,add_gender,meta_data)
        row_label = "";
        if perform_power_analysis
            row_label = strcat(row_label,"sampled data");
        else
            row_label = strcat(row_label, "all data");
        end
        % if add_gender
        %     row_label = strcat(row_label, " Split By Gender");
        % else
        %     row_label = strcat(row_label," Not Split By Gender");
        % end
    end
% surrounding_directory = create_a_file_if_it_doesnt_exist_and_ret_abs_path(surrounding_directory);
% home_dir = cd(surrounding_directory);
experiments = unique(human_data_table.experiment);
experiments = string(experiments);
unique_clusters = unique(human_data_table.cluster_number);

reformatted_data_table = reformat_human_data_table(human_data_table);
reformatted_all_data = reformat_all_data(all_data);

hunger_table = [];
for k=1:length(all_data_order)
    hunger_table =[hunger_table; get_average_hunger_by_cost(all_data{k},"","cost")];
end

table_with_hunger = join(reformatted_data_table,hunger_table,'Keys',{'clusterLabels','experiment'});
s = RandStream('mlfg6331_64');
if add_gender
    return_table = perform_analysis_with_gender(table_with_hunger,filter_to_use,unique_clusters,perform_power_analysis,human_data_table,threshold,what_percentage_must_be_significant,s);
else
    return_table =perform_analysis_without_gender(table_with_hunger,filter_to_use,unique_clusters,perform_power_analysis,human_data_table,threshold,what_percentage_must_be_significant,s);
end




% cd(home_dir);


end