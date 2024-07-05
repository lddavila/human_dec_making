function [] = create_and_save_specified_example(label,key_used,table_with_hunger,dir_to_save_figs_to,version_name)


    function [cut_down_lower_threshold_table,cut_down_upper_threshold_table,p,pwrout_for_x,pwrout_for_y,pwrout_for_z] = perform_chi_squared_analysis(lower_threshold_table,upper_threshold_table,perform_power_analysis,s,unique_clusters)
        if perform_power_analysis
            if size(lower_threshold_table,1) > size(upper_threshold_table,1)
                n = size(upper_threshold_table,1);
                cut_down_lower_threshold_table = datasample(s,lower_threshold_table,n,'Replace',false);
                cut_down_upper_threshold_table = upper_threshold_table;
                lower_threshold_table = cut_down_lower_threshold_table;
            elseif size(upper_threshold_table,1) > size(lower_threshold_table,1)
                n = size(lower_threshold_table,1);
                cut_down_upper_threshold_table = datasample(s,upper_threshold_table,n,'Replace',false);
                cut_down_lower_threshold_table = lower_threshold_table;
                upper_threshold_table = cut_down_upper_threshold_table;
            else
                n = size(upper_threshold_table,1);
                cut_down_lower_threshold_table = lower_threshold_table;
                cut_down_upper_threshold_table = upper_threshold_table;
            end
        else
            n = size(upper_threshold_table,1);
            cut_down_lower_threshold_table = lower_threshold_table;
            cut_down_upper_threshold_table = upper_threshold_table;
        end

        lower_bound_cluster_counts = get_cluster_counts(lower_threshold_table,unique_clusters);
        upper_bound_cluster_counts = get_cluster_counts(upper_threshold_table,unique_clusters);
        [p,~] = chi2test([lower_bound_cluster_counts;upper_bound_cluster_counts]);


        var_of_entire_lower_threshold_data_set = var([cut_down_lower_threshold_table.clusterX,cut_down_lower_threshold_table.clusterY,cut_down_lower_threshold_table.clusterZ],0,1);
        var_of_entire_upper_threshold_data_set = var([cut_down_upper_threshold_table.clusterX,cut_down_upper_threshold_table.clusterY,cut_down_upper_threshold_table.clusterZ],0,1);


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
    function [] = create_and_save_examples_dont_split_by_gender(dir_to_save_figs_to,meta_data,split_point,min_pref,perform_power_analysis,s,table_with_hunger,key_used,version_name)
        for the_threshold=0:10:100
            for pref_threshold=0:10:100
                upper_threshold_table = table_with_hunger(table_with_hunger.(meta_data) >= the_threshold & table_with_hunger.story_prefs >=pref_threshold,:);
                lower_threshold_table = table_with_hunger(table_with_hunger.(meta_data) < the_threshold & table_with_hunger.story_prefs >= pref_threshold,:);


                [cut_down_lower_threshold_table,cut_down_upper_threshold_table,p,pwrout_for_x,pwrout_for_y,pwrout_for_z] = perform_chi_squared_analysis(lower_threshold_table,upper_threshold_table,perform_power_analysis,s,unique(table_with_hunger.cluster_number));
                if the_threshold == split_point && pref_threshold ==min_pref
                    lower_threshold_table = cut_down_lower_threshold_table;
                    upper_threshold_table = cut_down_upper_threshold_table;

                    if perform_power_analysis
                        power_string = strcat("From sampsizepwr we get X:",num2str(pwrout_for_x), " Y:",num2str(pwrout_for_y), " Z:",num2str(pwrout_for_z));
                    else
                        power_string = "Power Analysis Wasnt Performed";
                    end
                    colors = distinguishable_colors(30);
                    human_lower_bound_stats_map = get_human_data_table_stats(lower_threshold_table);
                    create3d_cluster_plot_for_human_data_with_power(lower_threshold_table,colors,"Male and Female Human",strcat(key_used," M&F Upper Bound"),dir_to_save_figs_to,human_lower_bound_stats_map,version_name,strcat(meta_data," <",string(split_point)," Story Prefs >=", string(min_pref)),unique(table_with_hunger.cluster_number),num2str(p),power_string);

                    human_upper_bound_stats_map = get_human_data_table_stats(upper_threshold_table);
                    create3d_cluster_plot_for_human_data_with_power(upper_threshold_table,colors,"Male and Female Human",strcat(key_used," M&F Upper Bound"),dir_to_save_figs_to,human_upper_bound_stats_map,version_name,strcat(meta_data," >=",string(split_point), " Story Prefs >=", string(min_pref)),unique(table_with_hunger.cluster_number),num2str(p),power_string);
                end
            end
        end
    end
% dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);
label_info = split(label);
meta_data = label_info(1);
split_point_info = split(label_info(3),":");
split_point = str2double(split_point_info(2));
min_pref_info = split(label_info(5),":");
min_pref = str2double(min_pref_info(2));


s = RandStream('mlfg6331_64');
if contains(key_used," With Power Analysis ")
    perform_power_analysis = true;
elseif contains(key_used," Without Power Analysis")
    perform_power_analysis = false;
end

if contains(key_used," With Gender ")
    split_by_gender = true;
elseif contains(key_used," Without Gender ")
    split_by_gender = false;
end


if ~split_by_gender
    create_and_save_examples_dont_split_by_gender(dir_to_save_figs_to,meta_data,split_point,min_pref,perform_power_analysis,s,table_with_hunger,key_used,version_name);
end



end