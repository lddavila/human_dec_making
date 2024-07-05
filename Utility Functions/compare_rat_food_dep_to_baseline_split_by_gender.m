function [] = compare_rat_food_dep_to_baseline_split_by_gender(baseline_rat_data,food_dep_rat_data,dir_to_save_fig_to,perform_the_power_analysis,version_name)
    function [formatted_rat_table] = format_the_rat_data(rat_data_table)
        the_labels = string(rat_data_table.clusterLabels);
        the_names = split(the_labels," ");
        the_names = the_names(:,1);
        rat_data_table.("name") = the_names;
        formatted_rat_table = rat_data_table;
    end

 function [power_string,p_value,shortened_female_table,shortened_male_table] = perform_power_analysis_along_dimensions_and_chi_squared(table_of_only_females,table_of_only_males,table_with_gender,perform_the_power_analysis,s)
        if perform_the_power_analysis
            if size(table_of_only_males,1) > size(table_of_only_females,1)
                shortened_male_table = datasample(s,table_of_only_males,size(table_of_only_females,1),'Replace',false);
                shortened_female_table = table_of_only_females;
            elseif size(table_of_only_males,1) < size(table_of_only_females,1)
                shortened_female_table = datasample(s,table_of_only_females,size(table_of_only_males,1),'Replace',false);
                shortened_male_table = table_of_only_males;
            else
                shortened_female_table = table_of_only_females;
                shortened_male_table = table_of_only_males;
            end
        else
            shortened_female_table = table_of_only_females;
            shortened_male_table = table_of_only_males;
        end
        male_data = [shortened_male_table.clusterX,shortened_male_table.clusterY,shortened_male_table.clusterZ];
        female_data = [shortened_female_table.clusterX,shortened_female_table.clusterY,shortened_female_table.clusterZ];

        male_var = var(male_data);
        female_var = var(female_data);

        female_cluster_counts = get_cluster_counts(shortened_female_table,unique(table_with_gender.cluster_number));
        male_cluster_counts = get_cluster_counts(shortened_male_table,unique(table_with_gender.cluster_number));


        [p_value,~] = chi2test([female_cluster_counts;male_cluster_counts]);
        n= size(shortened_male_table,1);

        if perform_the_power_analysis
            pwrout_for_x = sampsizepwr('var',male_var(1),female_var(1),[],n);
            pwrout_for_y =sampsizepwr('var',male_var(2),female_var(2),[],n);
            pwrout_for_z = sampsizepwr('var',male_var(3),female_var(3),[],n);
            power_string = strcat("Power For X:",string(pwrout_for_x), " Y:",string(pwrout_for_y), " Z:",string(pwrout_for_z));
        else
            power_string = "Power Analysis was not performed";
        end
        %pwrout = sampsizepwr(testtype,p0,p1,[],n) returns the power achieved for a sample size of n when the true parameter value is p1.
        %If testtype is 'var', then p0 is the variance under the null hypothesis.
        % If testtype is 'var', then p1 is the variance under the alternative hypothesis.



    end


if perform_the_power_analysis
    add_string = "Cut To Match";
else
    add_string = "Not Cut";
end
query = "SELECT name,gender FROM rattable;";
conn = database("live_database","postgres","1234");
gender_from_database = fetch(conn,query);
gender_from_database.gender = string(gender_from_database.gender);

baseline_rat_data_table = format_the_rat_data(baseline_rat_data);
food_dep_rat_data_table = format_the_rat_data(food_dep_rat_data);

baseline_table_with_gender = join(baseline_rat_data_table,gender_from_database);
food_dep_table_with_gender = join(food_dep_rat_data_table,gender_from_database);

baseline_table_of_only_males = baseline_table_with_gender(strcmpi(baseline_table_with_gender.gender,"male"),:);
baseline_table_of_only_females = baseline_table_with_gender(strcmpi(baseline_table_with_gender.gender,"female"),:);

food_dep_table_of_only_males = food_dep_table_with_gender(strcmpi(food_dep_table_with_gender.gender,"male"),:);
food_dep_table_of_only_females = food_dep_table_with_gender(strcmpi(food_dep_table_with_gender.gender,"female"),:);
s = RandStream('mlfg6331_64');
[power_string_male,p_value_male,baseline_shortened_male_table,food_dep_shortened_male_table] = perform_power_analysis_along_dimensions_and_chi_squared(baseline_table_of_only_males,food_dep_table_of_only_males,baseline_table_with_gender,perform_the_power_analysis,s);
dir_to_save_fig_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_fig_to);
create3d_cluster_plot_for_human_data_with_power(baseline_shortened_male_table,distinguishable_colors(30),strcat("Male Rat Baseline ",add_string), strcat("Male Rats ",add_string),dir_to_save_fig_to,get_rat_data_table_stats(baseline_shortened_male_table),version_name,"",unique(baseline_table_with_gender.cluster_number),p_value_male,power_string_male);
create3d_cluster_plot_for_human_data_with_power(food_dep_shortened_male_table,distinguishable_colors(30),strcat("Male Rat Food Deprivation ",add_string), strcat("Male Rats Food Deprivation ",add_string),dir_to_save_fig_to,get_rat_data_table_stats(food_dep_shortened_male_table),version_name,"",unique(baseline_table_with_gender.cluster_number),p_value_male,power_string_male);



[power_string_female,p_value_female,baseline_shortened_female_table,food_dep_shortened_female_table] = perform_power_analysis_along_dimensions_and_chi_squared(baseline_table_of_only_females,food_dep_table_of_only_females,baseline_table_with_gender,perform_the_power_analysis,s);
dir_to_save_fig_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_fig_to);
create3d_cluster_plot_for_human_data_with_power(baseline_shortened_female_table,distinguishable_colors(30),strcat("Female Rat Baseline ",add_string), strcat("Female Rats ",add_string),dir_to_save_fig_to,get_rat_data_table_stats(baseline_shortened_female_table),version_name,"",unique(baseline_table_with_gender.cluster_number),p_value_female,power_string_female);
create3d_cluster_plot_for_human_data_with_power(food_dep_shortened_male_table,distinguishable_colors(30),strcat("Female Rat Food Deprivation ",add_string), strcat("Female Rats Food Deprivation ",add_string),dir_to_save_fig_to,get_rat_data_table_stats(food_dep_shortened_female_table),version_name,"",unique(baseline_table_with_gender.cluster_number),p_value_female,power_string_female);

end