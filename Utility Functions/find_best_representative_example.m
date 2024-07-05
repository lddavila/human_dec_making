function [label_to_use,key_used] = find_best_representative_example(key_used,table_to_use,which_cluster_to_look_at,what_effect,split_by_gender_or_not,min_num_dps,male_or_female)

    function [label_to_use] = look_for_biggest_affect_for_specified_cluster(table_to_use,which_cluster_to_look_at,increase_or_decrease,min_num_dps)
        biggest_affect = 0;
        label_to_use = "";
        for i=1:height(table_to_use)
            current_diff_in_proportion = table_to_use{i,2};
            current_label = table_to_use{i,1};
            p_value_from_chi_squared = table_to_use{i,3};   
            cluster_affect = current_diff_in_proportion(which_cluster_to_look_at);
            number_of_dps_in_lower_half = table_to_use.("#_of_DP_in_lower_half");
            number_of_dps_in_lower_half = number_of_dps_in_lower_half(i);
            number_of_dps_in_upper_half = table_to_use.("#_of_DP_in_upper_half");
            number_of_dps_in_upper_half = number_of_dps_in_upper_half(i);
            if ~increase_or_decrease %% means you are looking for the biggest decrease
                cluster_affect = cluster_affect *-1; %makes the increases the smallest and the decreases the biggest 
            end
            if cluster_affect >= biggest_affect && p_value_from_chi_squared  < 0.054 && number_of_dps_in_lower_half >=min_num_dps && number_of_dps_in_upper_half>= min_num_dps
                biggest_affect = cluster_affect;
                label_to_use = current_label;
            end

        end
    end

    function [label_to_use] = look_for_smallest_affect_for_specified_cluster(table_to_use,which_cluster_to_look_at,min_num_dps)
        smallest_affect = 99999999;
        label_to_use = "";
        for i=1:height(table_to_use)
            current_diff_in_proportion = table_to_use{i,2};
            current_label = table_to_use{i,1};
            cluster_affect = current_diff_in_proportion(which_cluster_to_look_at);
            cluster_affect = abs(cluster_affect);
            p_value_from_chi_squared = table_to_use{i,3};  
             number_of_dps_in_lower_half = table_to_use.("#_of_DP_in_lower_half");
            number_of_dps_in_lower_half = number_of_dps_in_lower_half(i);
            number_of_dps_in_upper_half = table_to_use.("#_of_DP_in_upper_half");
            number_of_dps_in_upper_half = number_of_dps_in_upper_half(i);
            if cluster_affect <= smallest_affect && p_value_from_chi_squared > 0.054 && number_of_dps_in_lower_half >=min_num_dps && number_of_dps_in_upper_half>= min_num_dps
                smallest_affect = cluster_affect;
                label_to_use = current_label;
            end

        end
    end

    function [label_to_use] = look_for_biggest_affect_split_by_gender(table_to_use,min_num_dps,male_or_female)
        biggest_change = 0;
        label_to_use = "";

        if male_or_female %true indicates male
            col_of_differences =table_to_use.male_diff_in_prop;
            col_of_chi_squared = table_to_use.chi_squared_p_value_male;
            col_of_lower_half_size = table_to_use.number_of_male_DPs_lower_half ;
            col_of_upper_half_size = table_to_use.number_of_male_DPs_upper_half;
        else
            col_of_differences =table_to_use.fem_diff_in_prop;
            col_of_chi_squared = table_to_use.chi_squared_p_value_female;
            col_of_lower_half_size = table_to_use.number_of_female_DPs_lower_half;
            col_of_upper_half_size = table_to_use.number_of_female_DPs_upper_half;
        end

        cols_of_labels = table_to_use.Label;
        for i=1:height(table_to_use)
            current_differences =  col_of_differences(i,:);
            current_chi_squared = col_of_chi_squared(i);
            lower_half_num_pts = col_of_lower_half_size(i);
            upper_half_num_pts = col_of_upper_half_size(i);

            mean_of_differences = mean(abs(current_differences));
            
            if isnan(mean_of_differences)
                continue;
            end

            if mean_of_differences > biggest_change && current_chi_squared < 0.054 && lower_half_num_pts >=min_num_dps && upper_half_num_pts >= min_num_dps
                biggest_change = mean_of_differences;
                label_to_use = cols_of_labels(i);
            end

        end
    end
    function [label_to_use] = look_for_smallest_affect_split_by_gender(table_to_use,min_num_dps,male_or_female)
    end
label_to_use = "";
if strcmpi(what_effect,"increase") && ~split_by_gender_or_not
    label_to_use = look_for_biggest_affect_for_specified_cluster(table_to_use,which_cluster_to_look_at,1,min_num_dps);
elseif strcmpi(what_effect,"decrease") && ~split_by_gender_or_not
     label_to_use = look_for_biggest_affect_for_specified_cluster(table_to_use,which_cluster_to_look_at,0,min_num_dps);
elseif strcmpi(what_effect,"neither") && ~split_by_gender_or_not
     label_to_use = look_for_smallest_affect_for_specified_cluster(table_to_use,which_cluster_to_look_at,min_num_dps);
elseif strcmpi(what_effect,"increase") && split_by_gender_or_not
    look_for_biggest_affect_split_by_gender(table_to_use,which_cluster_to_look_at,1,min_num_dps,male_or_female)
elseif strcmpi(what_effect,"decrease") && split_by_gender_or_not
    look_for_biggest_affect_split_by_gender(table_to_use,min_num_dps,male_or_female)
elseif strcmpi(what_effect,"neither") && split_by_gender_or_not
    

end
end