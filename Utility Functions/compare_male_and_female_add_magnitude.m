function [diff_table,array_of_significance_based_on_gender_upper,array_of_significance_based_on_gender_lower,array_of_significance_based_on_upper_and_lower,array_of_significance_for_male,array_of_significance_for_female,table_with_hunger] = compare_male_and_female_add_magnitude(human_data_table,all_data,all_data_order,colors,version_name,threshold,what_percentage_must_be_significant,surrounding_directory,filter_to_use,perform_power_analysis,add_gender,get_histograms,only_do_significant_differences,make_example_plots)

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

        % if strcmpi("pain",filter_to_use) && preference_threshold ==50 && the_threshold ==30
        %     disp("Stop");
        % end


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

    function [array_of_diff] = measure_effect_of_changes_between_lower_and_upper_threshold(lower_threshold_table,upper_threshold_table,unique_clusters)
        lower_threshold_proportions = get_cluster_counts(lower_threshold_table,unique_clusters) ./ size(lower_threshold_table,1);
        upper_threshold_proportions = get_cluster_counts(upper_threshold_table,unique_clusters) ./ size(upper_threshold_table,1);
        array_of_diff = upper_threshold_proportions -lower_threshold_proportions;
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

    function [] = create_histograms_to_show_affect_of_differences(array_of_diff_between_lower_and_upper,add_gender,current_gender,unique_clusters,filter_to_use,perform_power_analysis)
        figure('units','normalized','outerposition',[0 0 1 1])
        [min_value,max_value] = bounds(array_of_diff_between_lower_and_upper,"all");
        subplot(1,length(unique_clusters),1);

        for i=1:length(unique_clusters)
            data_to_use = array_of_diff_between_lower_and_upper(:,unique_clusters(i));
            [h,p] = kstest(data_to_use);
            if i~=1
                subplot(1,length(unique_clusters),i);
            end
            histogram(data_to_use,'Normalization','probability','BinEdges',linspace(-1,1,50));
            hold on;
            xline(0,'-','Increase/Decrease Boundary');
            title([strcat("Cluster ",string(unique_clusters(i))), ...
                strcat("kstest p:",string(p)," h:",string(h)), ...
                strcat("#Dpts:",string(size(data_to_use,1)))]);
            xlim([min_value,max_value])
            ylim([0,1])

        end


        if perform_power_analysis
            add_to_title = " cut to match";
        else
            add_to_title = " Not cut";
        end
        sgtitle(strcat("Distribution of Increases and Decreases Between Cluster Proportions based on ",string(strrep(filter_to_use,"_","\_")),add_to_title));
        saveas(gcf,strcat("Distribution of Increases and Decreases Between Cluster Proportions based on ",filter_to_use,add_to_title,".fig"),"fig")

        

    end

    function [] = create_histograms_to_show_male_and_female_affect_differences(array_of_diff_between_lower_and_upper_male,array_of_diff_between_lower_and_upper_female,add_gender,current_gender,unique_clusters,filter_to_use,perform_power_analysis,only_do_significant_differences)
        figure('units','normalized','outerposition',[0 0 1 1])
        [min_value,max_value] = bounds([array_of_diff_between_lower_and_upper_male;array_of_diff_between_lower_and_upper_female],"all");
        subplot(1,length(unique_clusters),1);

        for i=1:length(unique_clusters)
            if i~=1
                subplot(1,length(unique_clusters),i);
            end
            male_data = array_of_diff_between_lower_and_upper_male(:,unique_clusters(i));
            histogram(male_data,'Normalization','probability','BinEdges',linspace(-1,1,50));
            hold on;
            
            female_data = array_of_diff_between_lower_and_upper_female(:,unique_clusters(i));
            histogram(female_data,'Normalization','probability','BinEdges',linspace(-1,1,50));
            xline(0,'-','Increase/Decrease Boundary');
            [h,p] = kstest2(male_data,female_data);
            title([strcat("Cluster ",string(unique_clusters(i)), " Male Vs Female"), ...
                strcat("From ks2test H: ",string(h)," p:",string(p)), ...
                strcat("# of M DPts:",string(size(male_data,1))," # of F DPts:", string(size(female_data,1)))]);
            % xlim([min_value,max_value])
            ylim([0,1])
            legend("Male","Female")
        end
        if perform_power_analysis
            add_to_title = " cut once";
        else
            add_to_title = " Not cut";
        end

        if only_do_significant_differences
            add_to_title = strcat(add_to_title," Values which are significant When Comparing same Halves, different genders");
        else
            add_to_title = strcat(add_to_title, " All Values");
        end
        sgtitle(strcat("Distribution of Increases and Decreases Between Cluster Proportions based on ",string(strrep(filter_to_use,"_","\_")),add_to_title));

        saveas(gcf,strcat("Distribution of Increases and Decreases Between Cluster Proportions based on ",filter_to_use,add_to_title,".fig"),"fig")
        % saveas(gcf,strcat("Distribution of Increases and Decreases Between Cluster Proportions based on ",filter_to_use,add_to_title,".svg"),"svg")


        

    end
    function [diff_table,array_of_significance_based_on_upper_and_lower] = perform_analysis_without_gender(table_with_hunger,filter_to_use,unique_clusters,perform_power_analysis,human_data_table,threshold,what_percentage_must_be_significant,s,colors,only_do_significant_differences,make_example_plots)
        diff_table = [];
        array_of_diff_between_lower_and_upper = [];
        array_of_significance_based_on_upper_and_lower = zeros(length(0:10:100),length(0:10:100));
        array_of_significance_based_on_upper_and_lower(:,:) = NaN;
        meta_data_counter = 1;
        for the_threshold=0:10:100
            preference_counter =1;
            for preference_threshold=0:10:100
                table_of_upper_thresholds = table_with_hunger(table_with_hunger.(filter_to_use) >= the_threshold & table_with_hunger.story_prefs >= preference_threshold,:);
                table_of_lower_thresholds = table_with_hunger(table_with_hunger.(filter_to_use) < the_threshold & table_with_hunger.story_prefs >= preference_threshold,:);
                if size(table_of_upper_thresholds,1) <1 || size(table_of_lower_thresholds,1)<1
                    continue;
                end
                [found_significant_changes,~,~,~,p,pwrout_for_x,pwrout_for_y,pwrout_for_z,resized_lower_bound_table,resized_upper_bound_table] = check_for_significant_differences(table_of_lower_thresholds,table_of_upper_thresholds,unique(human_data_table.cluster_number),threshold,what_percentage_must_be_significant,the_threshold,preference_threshold,filter_to_use,perform_power_analysis,s);

                table_of_lower_thresholds = resized_lower_bound_table;
                table_of_upper_thresholds = resized_upper_bound_table;
                difference_between_upper_and_lower_bound = measure_effect_of_changes_between_lower_and_upper_threshold(table_of_lower_thresholds,table_of_upper_thresholds,unique_clusters);
                if only_do_significant_differences && found_significant_changes
                    array_of_diff_between_lower_and_upper = [array_of_diff_between_lower_and_upper;difference_between_upper_and_lower_bound];
                elseif ~only_do_significant_differences
                    array_of_diff_between_lower_and_upper = [array_of_diff_between_lower_and_upper;difference_between_upper_and_lower_bound];
                end
                if found_significant_changes && make_example_plots
                    dir_to_save_figs_to = strcat("Male and Female"," 3d Cluster Plots ",filter_to_use ," split at ",string(the_threshold)," Story Pref Min ", string(preference_threshold), "chi squared ",string(round(p,3)));
                    power_string = strcat("From sampsizepwr we get X:",num2str(pwrout_for_x), " Y:",num2str(pwrout_for_y), " Z:",num2str(pwrout_for_z));
                    human_lower_bound_stats_map = get_human_data_table_stats(table_of_lower_thresholds);
                    create3d_cluster_plot_for_human_data_with_power(table_of_lower_thresholds,colors,"Male and Female Human","Male and Female Lower Bound",dir_to_save_figs_to,human_lower_bound_stats_map,version_name,strcat(filter_to_use," <",string(the_threshold)," Story Prefs >=", string(preference_threshold)),unique(human_data_table.cluster_number),num2str(p),power_string);
                    human_upper_bound_stats_map = get_human_data_table_stats(table_of_upper_thresholds);
                    create3d_cluster_plot_for_human_data_with_power(table_of_upper_thresholds,colors,"Male and Female Human","Male and Female Upper Bound",dir_to_save_figs_to,human_upper_bound_stats_map,version_name,strcat(filter_to_use," >=",string(the_threshold), " Story Prefs >=", string(preference_threshold)),unique(human_data_table.cluster_number),num2str(p),power_string);
                    
                end
                close all;
                row_label = strcat(filter_to_use," Split at:",string(the_threshold)," Pref Min:",string(preference_threshold));


                diff_table = [diff_table;table(row_label,difference_between_upper_and_lower_bound,p,height(table_of_lower_thresholds),height(table_of_upper_thresholds),'VariableNames',["Label","diff_in_proportion","chi_squared_p_value","#_of_DP_in_lower_half","#_of_DP_in_upper_half"])];

                array_of_significance_based_on_upper_and_lower(meta_data_counter, preference_counter) =p;

                preference_counter = preference_counter+1;
            end
             close all;
             meta_data_counter = meta_data_counter +1;
        end
        create_histograms_to_show_affect_of_differences(array_of_diff_between_lower_and_upper,0,"",unique_clusters,filter_to_use,perform_power_analysis)
        close all;
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

                    close all;


                end



            end
        end
    end

    function [significant_changes,cut_down_threshold_male,cut_down_threshold_female,p] = check_for_sig_changes_betw_diff_gender_same_split_point(threshold_male,threshold_female,unique_clusters,perform_power_analysis,s)
        if perform_power_analysis
            if size(threshold_male,1) > size(threshold_female,1)
                cut_down_threshold_female = threshold_female;
                cut_down_threshold_male = datasample(s,threshold_male,size(threshold_female,1),'Replace',false);
                

            elseif size(threshold_male,1) < size(threshold_female,1)
                cut_down_threshold_male = threshold_male;
                cut_down_threshold_female = datasample(s,threshold_female,size(threshold_male,1),'Replace',false);
            else
                cut_down_threshold_male = threshold_male;
                cut_down_threshold_female = threshold_female;
            end
        else
            cut_down_threshold_male = threshold_male;
            cut_down_threshold_female = threshold_female;
        end
        male_cluster_counts = get_cluster_counts(cut_down_threshold_male,unique_clusters);
        female_cluster_counts = get_cluster_counts(cut_down_threshold_female,unique_clusters);

        [p,~] = chi2test([male_cluster_counts;female_cluster_counts]);

        if p<0.05
            significant_changes=true;
        else
            significant_changes=false;
        end
    end
    function [table_of_differences,array_of_significance_based_on_gender_upper,array_of_significance_based_on_gender_lower,array_of_significance_for_male,array_of_significance_for_female] = perform_analysis_with_gender_ver_2(table_with_hunger,filter_to_use,unique_clusters,perform_power_analysis,human_data_table,threshold,what_percentage_must_be_significant,s,only_do_significant_differences,version_name,colors,make_example_plots)
        table_of_differences = []; 
        unique_genders = ["male","female"];
        male_differences = [];
        female_differences = [];
        array_of_significance_based_on_gender_upper = zeros(length(0:10:100),length(0:10:100));
        array_of_significance_based_on_gender_upper(:,:) = NaN;
        array_of_significance_based_on_gender_lower = zeros(length(0:10:100),length(0:10:100)) + 1;
        array_of_significance_based_on_gender_lower(:,:) = NaN;

        array_of_significance_for_male = zeros(length(0:10:100),length(0:10:100));
        array_of_significance_for_male(:,:) = NaN;
        array_of_significance_for_female = zeros(length(0:10:100),length(0:10:100));
        array_of_significance_for_female(:,:) = NaN;
        meta_data_counter = 1;
        
        for the_threshold=0:10:100
            story_pref_counter =1;
            for preference_threshold=0:10:100
                table_of_upper_thresholds_male = table_with_hunger(table_with_hunger.(filter_to_use) >= the_threshold & table_with_hunger.story_prefs >= preference_threshold & strcmpi(table_with_hunger.sex,unique_genders(1)),:);
                table_of_lower_thresholds_male = table_with_hunger(table_with_hunger.(filter_to_use) < the_threshold & table_with_hunger.story_prefs >= preference_threshold & strcmpi(table_with_hunger.sex,unique_genders(1)),:);

                table_of_upper_thresholds_female = table_with_hunger(table_with_hunger.(filter_to_use) >= the_threshold & table_with_hunger.story_prefs >= preference_threshold & strcmpi(table_with_hunger.sex,unique_genders(2)),:);
                table_of_lower_thresholds_female = table_with_hunger(table_with_hunger.(filter_to_use) < the_threshold & table_with_hunger.story_prefs >= preference_threshold & strcmpi(table_with_hunger.sex,unique_genders(2)),:);


                [found_significant_changes_male,~,~,~,p_male,pwrout_for_x_male,pwrout_for_y_male,pwrout_for_z_male,resized_lower_bound_table_male,resized_upper_bound_table_male] = check_for_significant_differences(table_of_lower_thresholds_male,table_of_upper_thresholds_male,unique(human_data_table.cluster_number),threshold,what_percentage_must_be_significant,the_threshold,preference_threshold,filter_to_use,perform_power_analysis,s);

                array_of_significance_for_male(meta_data_counter,story_pref_counter) = p_male;
                
                table_of_lower_thresholds_male = resized_lower_bound_table_male;
                table_of_upper_thresholds_male = resized_upper_bound_table_male;


                [found_significant_changes_female,~,~,~,p_female,pwrout_for_x_female,pwrout_for_y_female,pwrout_for_z_female,resized_lower_bound_table_female,resized_upper_bound_table_female] = check_for_significant_differences(table_of_lower_thresholds_female,table_of_upper_thresholds_female,unique(human_data_table.cluster_number),threshold,what_percentage_must_be_significant,the_threshold,preference_threshold,filter_to_use,perform_power_analysis,s);


                array_of_significance_for_female(meta_data_counter,story_pref_counter) = p_female;
                table_of_lower_thresholds_female = resized_lower_bound_table_female;
                table_of_upper_thresholds_female = resized_upper_bound_table_female;




                male_difference_in_proportions = measure_effect_of_changes_between_lower_and_upper_threshold(table_of_lower_thresholds_male,table_of_upper_thresholds_male,unique_clusters);
                female_difference_in_propotions = measure_effect_of_changes_between_lower_and_upper_threshold(table_of_lower_thresholds_female,table_of_upper_thresholds_female,unique_clusters);
                [significant_changes_upper,~,~,p_upper] = check_for_sig_changes_betw_diff_gender_same_split_point(table_of_upper_thresholds_male,table_of_upper_thresholds_female,unique_clusters,0,s);
                [significant_changes_lower,~,~,p_lower] = check_for_sig_changes_betw_diff_gender_same_split_point(table_of_lower_thresholds_male,table_of_lower_thresholds_female,unique_clusters,0,s);
                
                if only_do_significant_differences
                    if size(table_of_upper_thresholds_male,1) < 1 || size(table_of_upper_thresholds_female,1) <1
                        significant_changes_upper = false;
                    end
                    if size(table_of_lower_thresholds_male,1) <1 || size(table_of_lower_thresholds_female,1) <1
                        significant_changes_lower = false;
                    end

                    if  significant_changes_lower || significant_changes_upper
                        male_differences = [male_differences;male_difference_in_proportions];
                        female_differences = [female_differences;female_difference_in_propotions];
                    end
                    close all;
                else
                    male_differences = [male_differences;male_difference_in_proportions];
                    female_differences = [female_differences;female_difference_in_propotions];
                end



                if size(table_of_lower_thresholds_male,1) <1 || size(table_of_upper_thresholds_male,1) < 1
                    found_significant_changes_male = false;
                end

                if size(table_of_lower_thresholds_female,1) <1 || size(table_of_upper_thresholds_female,1) <1
                    found_significant_changes_female = false;
                end

                if (found_significant_changes_female || found_significant_changes_male) && make_example_plots
                    display(the_threshold)
                    display(filter_to_use)
                    display(preference_threshold)
                    dir_to_save_figs_to = strcat(filter_to_use," Split At",string(the_threshold)," Min Pref ",string(preference_threshold),"p male ",num2str(p_male)," p female",num2str(p_female));
                    
                    display(dir_to_save_figs_to)
                    clc;

                    power_string_male = strcat("From sampsizepwr we get X:",string(pwrout_for_x_male), " Y:",string(pwrout_for_y_male), " Z:",string(pwrout_for_z_male));
                    human_lower_bound_stats_map_male = get_human_data_table_stats(table_of_lower_thresholds_male);
                    create3d_cluster_plot_for_human_data_with_power(table_of_lower_thresholds_male,colors,"Human Male","Male Lower Bound",dir_to_save_figs_to,human_lower_bound_stats_map_male,version_name,strcat(filter_to_use," <",string(the_threshold)," Story Prefs >=", string(preference_threshold)),unique(human_data_table.cluster_number),p_male,power_string_male);
                    human_upper_bound_stats_map_male = get_human_data_table_stats(table_of_upper_thresholds_male);
                    create3d_cluster_plot_for_human_data_with_power(table_of_upper_thresholds_male,colors,"Human Male","Male Upper Bound",dir_to_save_figs_to,human_upper_bound_stats_map_male,version_name,strcat(filter_to_use," >=",string(the_threshold), " Story Prefs >=", string(preference_threshold)),unique(human_data_table.cluster_number),p_male,power_string_male);


                    power_string_female = strcat("From sampsizepwr we get X:",string(pwrout_for_x_female), " Y:",string(pwrout_for_y_female), " Z:",string(pwrout_for_z_female));
                    human_lower_bound_stats_map_female = get_human_data_table_stats(table_of_lower_thresholds_female);
                    create3d_cluster_plot_for_human_data_with_power(table_of_lower_thresholds_female,colors,"Human female","female Lower Bound",dir_to_save_figs_to,human_lower_bound_stats_map_female,version_name,strcat(filter_to_use," <",string(the_threshold)," Story Prefs >=", string(preference_threshold)),unique(human_data_table.cluster_number),p_female,power_string_female);
                    human_upper_bound_stats_map_female = get_human_data_table_stats(table_of_upper_thresholds_female);
                    create3d_cluster_plot_for_human_data_with_power(table_of_upper_thresholds_female,colors,"Human Female","Female Upper Bound",dir_to_save_figs_to,human_upper_bound_stats_map_female,version_name,strcat(filter_to_use," >=",string(the_threshold), " Story Prefs >=", string(preference_threshold)),unique(human_data_table.cluster_number),p_female,power_string_female);

                end

                row_label = strcat(filter_to_use," Split at:",string(the_threshold)," Pref Threshold",string(preference_threshold));

                table_of_differences = [table_of_differences;table(row_label,male_difference_in_proportions,p_male,height(table_of_lower_thresholds_male),height(table_of_upper_thresholds_male),female_difference_in_propotions,p_female,height(table_of_lower_thresholds_female),height(table_of_upper_thresholds_female),'VariableNames',["Label","male_diff_in_prop","chi_squared_p_value_male","number_of_male_DPs_lower_half","number_of_male_DPs_upper_half", "fem_diff_in_prop","chi_squared_p_value_female","number_of_female_DPs_lower_half","number_of_female_DPs_upper_half"])];

                close all;

                array_of_significance_based_on_gender_upper(meta_data_counter,story_pref_counter) = p_upper;
                array_of_significance_based_on_gender_lower(meta_data_counter,story_pref_counter) = p_lower;

                story_pref_counter = story_pref_counter + 1;
            end
            meta_data_counter = meta_data_counter+1;

            close all;

        end
        create_histograms_to_show_male_and_female_affect_differences(male_differences,female_differences,1,"",unique_clusters,filter_to_use,perform_power_analysis,only_do_significant_differences)
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
% experiments = unique(human_data_table.experiment);

unique_clusters = unique(human_data_table.cluster_number);

reformatted_data_table = reformat_human_data_table(human_data_table);


hunger_table = [];
for k=1:length(all_data_order)
    hunger_table =[hunger_table; get_average_hunger_by_cost(all_data{k},"","cost")];
end

table_with_hunger = join(reformatted_data_table,hunger_table,'Keys',{'clusterLabels','experiment'});
s = RandStream('mlfg6331_64');
surrounding_directory = create_a_file_if_it_doesnt_exist_and_ret_abs_path(surrounding_directory);
home_dir = cd(surrounding_directory);

diff_table = [];
array_of_significance_based_on_gender_upper = [];
array_of_significance_based_on_gender_lower = [];
array_of_significance_based_on_upper_and_lower = [];
array_of_significance_for_male = [];
array_of_significance_for_female = [];
if add_gender && ~get_histograms
    [diff_table] = perform_analysis_with_gender(table_with_hunger,filter_to_use,unique_clusters,perform_power_analysis,human_data_table,threshold,what_percentage_must_be_significant,s);
elseif add_gender && get_histograms
    [diff_table,array_of_significance_based_on_gender_upper,array_of_significance_based_on_gender_lower,array_of_significance_for_male,array_of_significance_for_female] = perform_analysis_with_gender_ver_2(table_with_hunger,filter_to_use,unique_clusters,perform_power_analysis,human_data_table,threshold,what_percentage_must_be_significant,s,only_do_significant_differences,version_name,colors,make_example_plots);
elseif ~add_gender && get_histograms
    [diff_table,array_of_significance_based_on_upper_and_lower] =perform_analysis_without_gender(table_with_hunger,filter_to_use,unique_clusters,perform_power_analysis,human_data_table,threshold,what_percentage_must_be_significant,s,colors,only_do_significant_differences,make_example_plots);
end




cd(home_dir);


end