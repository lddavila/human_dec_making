function [] = mask_given_data_and_create_heat_map(mask_options,original_matrix,dir_to_save_figs_to,x_y_ticks,the_title,cell_label_format,human_stats_map,version_name)
    function [masked_matrix] = loop_through_matrix(original_matrix,mask_option)
        masked_matrix = zeros(size(original_matrix,1),size(original_matrix,2));
        for i=1:size(original_matrix,1)
            did_a_break = false;
            for j=1:size(original_matrix,2)
                original_value = original_matrix(i,j);
                if ~isnan(original_value)
                    if strcmpi(mask_option,"log")
                        masked_matrix(i,j) = log(original_value);
                    elseif strcmpi(mask_option,"zero")
                        masked_matrix(i,j) = implement_zero_mask(original_value,i,j);
                    elseif strcmpi("opposite",mask_option)
                        masked_matrix(i,j) = implement_opposite_mask(original_value,i,j);
                    elseif strcmpi("by_cluster",mask_option)
                        masked_matrix(i,j) = implement_cluster_mask(original_value,i,j);
                    elseif strcmpi("rescale",mask_option)
                        masked_matrix = rescale(original_matrix);
                        did_a_break = true;
                        break;
                    elseif strcmpi("binary",mask_option)
                        masked_matrix(i,j) = implement_binary_mask(original_value,i,j);
                    end
                else
                    masked_matrix(i,j) = original_matrix(i,j);
                end
            end
            if did_a_break
                break;
            end
        end
    end

    function [updated_value] = implement_zero_mask(original_value,i,j)
        place_in_matrix = ((i-1)*24)+j;
        if mod(abs(i-j),6) ==0
            updated_value =original_value;
        else
            if isnan(original_value)
                updated_value = NaN;
            else
                updated_value = -5;
            end

        end
    end

    function [updated_value] = implement_opposite_mask(original_value,i,j)
        place_in_matrix = ((i-1)*24)+j;
        if ~(mod(abs(i-j),6)==0)
            updated_value =original_value;
        else
            if isnan(original_value)
                updated_value = NaN;
            else
                updated_value = -100;
            end

        end
    end

    function [updated_value] =implement_cluster_mask(original_value,i,j)
        if i >=1 && i <=6 && j >=1 && j<=6
            updated_value =original_value;
        elseif i >=7 && i <=12 && j >=7 && j<=12
            updated_value =original_value;
        elseif i >=13 && i <=18 && j >=13 && j<=18
            updated_value =original_value;
        elseif i >=19 && i <=24 && j >=19 && j<=24
            updated_value =original_value;
        else
            if isnan(original_value)
                updated_value = NaN;
            else
                updated_value = -.5;
            end

        end
    end
    
    function [updated_value] = implement_binary_mask(originl_value,i,j)
        if originl_value < 0.05
            updated_value = 1;
        else
            updated_value = 0;
        end
    end

    function [] = create_the_fig(dir_to_save_figs_to,masked_matrix,mask_option,x_y_ticks,the_title,cell_label_format,human_stats_map)
        dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);
        figure;
        heatmap(x_y_ticks,x_y_ticks,masked_matrix,'CellLabelFormat',cell_label_format)
        clim([0,1])
        if ~isempty(mask_option)
            title([strcat(strjoin(mask_option)," ", the_title),...
                strcat("Date Created:",string(datetime("today",'Format','MM-d-yyyy'))), ...
                strcat("Number Of Sessions:",      string(human_stats_map(strcat("Number of Sessions in all human data")))), ...
                "Created By mask\_given\_data\_and\_create\_heat\_map.m", ...
                version_name]);
            saveas(gcf,strcat(dir_to_save_figs_to,"\",strjoin(mask_option)," ",the_title," ",version_name,".fig"),"fig")
        else
            title([strcat(the_title),...
                strcat("Number Of Sessions:",      string(human_stats_map(strcat("Number of Sessions in all human data")))), ...
                strcat("Number Of approach avoid sessions:",      string(human_stats_map(strcat("approach_avoid Number of Data Points")))), ...
                strcat("Number Of moral sessions:",      string(human_stats_map(strcat("moral Number of Data Points")))), ...
                strcat("Number Of probability sessions:",      string(human_stats_map(strcat("probability Number of Data Points")))), ...
                strcat("Number Of social sessions:",      string(human_stats_map(strcat("social Number of Data Points")))), ...
                strcat("Date Created:",string(datetime("today",'Format','MM-d-yyyy'))), ...
            "Created By mask\_given\_data\_and\_create\_heat\_map.m", ...
            version_name]);
            saveas(gcf,strcat(dir_to_save_figs_to,"\",the_title," ",version_name,".fig"),"fig")

        end
    end

if ~isempty(mask_options)
    for k=1:length(mask_options)
        current_mask = mask_options(k);
        if k==1
            masked_matrix = loop_through_matrix(original_matrix,current_mask);
        else
            masked_matrix = loop_through_matrix(masked_matrix,current_mask);
        end
    end

    create_the_fig(dir_to_save_figs_to,masked_matrix,mask_options,x_y_ticks,the_title,cell_label_format,human_stats_map)


else
    create_the_fig(dir_to_save_figs_to,original_matrix,mask_options,x_y_ticks,the_title,cell_label_format,human_stats_map)
end


end