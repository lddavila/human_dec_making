function [] = create_heatmap_for_male_vs_female_tiredness(male_upper_vs_lower,female_upper_vs_lower,dir_to_save_figs_to,only_do_ones_with_power_analysis)
    function [everything_okay] = make_the_heat_map(the_title_to_use_male,the_title_to_use_female,current_matrix_male,current_matrix_female,dir_to_save_figs_to,only_do_ones_with_power_analysis)

        everything_okay = 1;
        if size(current_matrix_male,1) ~=0 && size(current_matrix_female,1) ~=0
            if only_do_ones_with_power_analysis
                if contains(the_title_to_use_male,"Without Cut To Fit Smaller") || contains(the_title_to_use_female,"Without Cut To Fit Smaller")
                    everything_okay=false;
                    return;
                end
            end
            figure('units','normalized','outerposition',[0 0 1 1])
            the_color_map_to_use =  generatecolormapthreshold([0 5 6 100],[0 0.5 1;0 0.7 1;1 1 1]);
            split_title = split(the_title_to_use_female," ");
            meta_data = split_title(1);
            y_labels = strcat(meta_data,":",string(0:10:100));
            x_labels = {"Male","Female"};

            heatmap(x_labels,y_labels,[current_matrix_male(:,1),current_matrix_female(:,1)],'Colormap',the_color_map_to_use,'ColorLimits',[0,1])
            % colormap(flip(sky));
            title([meta_data,the_title_to_use_male,the_title_to_use_female])
            saveas(gcf,strcat(dir_to_save_figs_to,"\",meta_data," Male Vs Female.fig"),"fig")
            saveas(gcf,strcat(dir_to_save_figs_to,"\",meta_data," Male Vs Female.svg"),"svg")
        end
    end
dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);


list_of_keys_male =keys(male_upper_vs_lower).';
list_of_keys_female = keys(female_upper_vs_lower).';
for j=1:length(list_of_keys_male)
    current_key_male = string(list_of_keys_male{j});
    current_matrix_male = male_upper_vs_lower(current_key_male);
    current_key_female = string(list_of_keys_female{j});
    current_matrix_female = female_upper_vs_lower(current_key_female);
    make_the_heat_map(current_key_male,current_key_female,current_matrix_male,current_matrix_female,dir_to_save_figs_to,only_do_ones_with_power_analysis)

end
end