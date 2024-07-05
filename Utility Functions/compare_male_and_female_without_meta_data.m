function [] = compare_male_and_female_without_meta_data(human_data_table,all_data,all_data_order,perform_power_analysis,split_by_task,dir_to_save_figs_to)

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

   

    function [significant_changes,p,pwrout_for_x,pwrout_for_y,pwrout_for_z,resized_male_table,resized_female_table] = check_for_significant_differences(male_table,female_table,unique_clusters,perform_power_analysis,s)
        
        if perform_power_analysis
            if size(male_table,1) > size(female_table,1)
                n = size(female_table,1);
                resized_male_table = datasample(s,male_table,n,'Replace',false);
                resized_female_table = female_table;
                male_table = resized_male_table;
            elseif size(male_table,1) <= size(female_table,1)
                n=size(male_table,1);
                resized_female_table = datasample(s,female_table,n,'Replace',false);
                resized_male_table = male_table;
                female_table = resized_female_table;
            end
        else
            resized_male_table = male_table;
            resized_female_table = female_table;
        end



        lower_bound_cluster_counts = get_cluster_counts(resized_male_table,unique_clusters);
        upper_bound_cluster_counts = get_cluster_counts(resized_female_table,unique_clusters);
        [p,~] = chi2test([lower_bound_cluster_counts;upper_bound_cluster_counts]);

        significant_changes = false;
        if p<0.054
            significant_changes = true;
        end


        var_of_entire_lower_threshold_data_set = var([resized_male_table.clusterX,resized_male_table.clusterY,resized_male_table.clusterZ],0,1);
        var_of_entire_upper_threshold_data_set = var([resized_female_table.clusterX,resized_female_table.clusterY,resized_female_table.clusterZ],0,1);

       
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

    end

    function [array_of_diff] = measure_effect_of_changes_between_lower_and_upper_threshold(lower_threshold_table,upper_threshold_table,unique_clusters)
        lower_threshold_proportions = get_cluster_counts(lower_threshold_table,unique_clusters) ./ size(lower_threshold_table,1);
        upper_threshold_proportions = get_cluster_counts(upper_threshold_table,unique_clusters) ./ size(upper_threshold_table,1);
        array_of_diff = upper_threshold_proportions -lower_threshold_proportions;
    end
   
    function [x_labels,y_labels,array_of_p_values] = analyze_by_gender_and_task(table_with_hunger,unique_clusters,perform_power_analysis,s)
        y_labels = {'Male Vs Female p values From Chi Squared'};
        unique_experiments = unique(table_with_hunger.experiment);
        array_of_p_values = zeros(1,length(unique_experiments));
        x_labels = cell(1,length(unique_experiments));
        for i=1:length(unique_experiments)
            x_labels{i} = char(unique_experiments(i));
            current_experiment = table_with_hunger(strcmpi(table_with_hunger.experiment,unique_experiments(i)),:);
            male_table = current_experiment(strcmpi(current_experiment.sex,"male"),:);
            female_table = current_experiment(strcmpi(current_experiment.sex,"female"),:);
            [~,p,~,~,~,~,~] = check_for_significant_differences(male_table,female_table,unique_clusters,perform_power_analysis,s);
            array_of_p_values(i) = p;
        end
    end

    function [] = analyze_by_gender(table_with_hunger,unique_clusters,perform_power_analysis,s,dir_to_save_figs_to)

        male_table = table_with_hunger(strcmpi(table_with_hunger.sex,"male"),:);
        female_table = table_with_hunger(strcmpi(table_with_hunger.sex,"female"),:);

        [~,p,pwrout_for_x,pwrout_for_y,pwrout_for_z,resized_male_table,resized_female_table] = check_for_significant_differences(male_table,female_table,unique_clusters,perform_power_analysis,s);

        if perform_power_analysis
            power_string = "Power For x:" + string(pwrout_for_x)+ " Power For y:" + string(pwrout_for_y)+ "Power For z:" + string(pwrout_for_z);
        else
            power_string = "Data Was Not Cut for power analysis";
        end

        male_stats_map = get_human_data_table_stats(resized_male_table);
        colors = distinguishable_colors(30);

        if perform_power_analysis
            add_to_title = " Cut To Match Smaller";
        else
            add_to_title = " Not Cut To Match Smaller";
        end
        create3d_cluster_plot_for_human_data_with_power(male_table,colors,"Male Human","Male" + add_to_title,dir_to_save_figs_to,male_stats_map,"","",unique(table_with_hunger.cluster_number),num2str(p),power_string);

        female_stats_map = get_human_data_table_stats(resized_female_table);
        create3d_cluster_plot_for_human_data_with_power(female_table,colors,"Female Human","Female" + add_to_title,dir_to_save_figs_to,female_stats_map,"","",unique(table_with_hunger.cluster_number),num2str(p),power_string);




    end

    function [] = create_heat_map_for_data_split_by_gender_and_task(x_labels,y_labels,array_of_p_values,dir_to_save_figs_to,performed_power_analysis)
        dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);
        if size(array_of_p_values,1) ~=0
            figure('units','normalized','outerposition',[0 0 1 1])
            the_color_map_to_use =  generatecolormapthreshold([0 5 6 100],[0 0.5 1;0 0.7 1;1 1 1]);
            heatmap(x_labels,y_labels,array_of_p_values,'Colormap',the_color_map_to_use,'ColorLimits',[0,1])
            % colormap(flip(sky));
            the_title = "Significance Determined By Chi-Squared Test Male Vs Female";
            
            if performed_power_analysis
                the_title = the_title + ", Cut To Match Smaller Data Set";
            else
                the_title = the_title + ", Not cut To Match Smaller Data Set";
            end
            title(the_title);
            saveas(gcf,strcat(dir_to_save_figs_to,"\",the_title,".fig"),"fig")
            saveas(gcf,strcat(dir_to_save_figs_to,"\",the_title,".svg"),"svg")
        end
    end

unique_clusters = unique(human_data_table.cluster_number);

reformatted_data_table = reformat_human_data_table(human_data_table);


hunger_table = [];
for k=1:length(all_data_order)
    hunger_table =[hunger_table; get_average_hunger_by_cost(all_data{k},"","cost")];
end

table_with_hunger = join(reformatted_data_table,hunger_table,'Keys',{'clusterLabels','experiment'});
s = RandStream('mlfg6331_64');
% surrounding_directory = create_a_file_if_it_doesnt_exist_and_ret_abs_path(surrounding_directory);
% home_dir = cd(surrounding_directory);
if split_by_task
    [x_labels,y_labels,array_of_p_values] = analyze_by_gender_and_task(table_with_hunger,unique_clusters,perform_power_analysis,s);
    create_heat_map_for_data_split_by_gender_and_task(x_labels,y_labels,array_of_p_values,dir_to_save_figs_to,perform_power_analysis);
else
    analyze_by_gender(table_with_hunger,unique_clusters,perform_power_analysis,s,dir_to_save_figs_to)
end
% cd(home_dir);


end