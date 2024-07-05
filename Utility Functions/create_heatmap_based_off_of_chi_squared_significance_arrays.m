function [] = create_heatmap_based_off_of_chi_squared_significance_arrays(array_of_containers,dir_to_save_figs_to,only_do_ones_with_power_analysis)
    function [everything_okay] = make_the_heat_map(the_title_to_use,current_matrix,dir_to_save_figs_to,only_do_ones_with_power_analysis)

        everything_okay = 1;
        if size(current_matrix,1) ~=0
            if only_do_ones_with_power_analysis
                if contains(the_title_to_use,"Without Cut To Fit Smaller")
                    everything_okay=false;
                    return;
                end
            end
            figure('units','normalized','outerposition',[0 0 1 1])
            the_color_map_to_use =  generatecolormapthreshold([0 5 6 100],[0 0.5 1;0 0.7 1;1 1 1]);
            split_title = split(the_title_to_use," ");
            meta_data = split_title(1);
            y_labels = strcat(meta_data,":",string(0:10:100));
            x_labels = strcat("Story Pref:", string(0:10:100));

            heatmap(x_labels,y_labels,current_matrix,'Colormap',the_color_map_to_use,'ColorLimits',[0,1])
            % colormap(flip(sky));
            title([meta_data,the_title_to_use])
            saveas(gcf,strcat(dir_to_save_figs_to,"\",the_title_to_use,".fig"),"fig")
            saveas(gcf,strcat(dir_to_save_figs_to,"\",the_title_to_use,".svg"),"svg")
        end
    end
dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);
for i=1:length(array_of_containers)
    current_container = array_of_containers{i};
    list_of_keys =keys(current_container).';
    for j=1:length(list_of_keys)
        current_key = string(list_of_keys{j});
        % if contains(current_key," With Significance")
        %     continue;
        % end
        current_matrix = current_container(current_key);
        make_the_heat_map(current_key,current_matrix,dir_to_save_figs_to,only_do_ones_with_power_analysis)
    end
end
end