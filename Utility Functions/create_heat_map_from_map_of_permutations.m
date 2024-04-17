function [matrix_to_turn_into_heat_map,x_y_ticks] = create_heat_map_from_map_of_permutations(data_table,map_of_permutations,dir_to_save_things_to,which_dimension,mask_or_dont,the_title,mask_level,human_stats_map)

    function [matrix_to_turn_into_heat_map] = populate_matrix(matrix_length_and_width,table_from_map,which_dimension)
        matrix_to_turn_into_heat_map = zeros(matrix_length_and_width,matrix_length_and_width);
        for i=1:matrix_length_and_width
            for j=1:matrix_length_and_width
                table_index = ((i-1)*matrix_length_and_width)+j; % tells you which row of in the table corresponds to the current row and column of the matrix
                if i~=j % if you're not in the diagonal
                    desired_data = table_from_map{table_index,2};
                    if ~isnan(which_dimension) %if there is a desired dimension
                        matrix_to_turn_into_heat_map(i,j) = desired_data(which_dimension);
                    else %if there's no desired dimension take the mean of all dimensions
                        matrix_to_turn_into_heat_map(i,j) = mean(desired_data);
                    end
                    if isinf(matrix_to_turn_into_heat_map(i,j)) %% if we get infinity turn it into nan
                        matrix_to_turn_into_heat_map(i,j)=NaN;
                    end

                else %get rid of the diagonal since it will always be useless info
                    matrix_to_turn_into_heat_map(i,j) = NaN;
                end
            end
        end


    end

    function [all_potential_ticks] = get_x_y_ticks(table_from_map)
        all_potential_ticks = table_from_map.Permutation;
        all_potential_ticks = split(all_potential_ticks," vs");
        all_potential_ticks = unique(all_potential_ticks(:,1:2));
        all_potential_ticks = split(all_potential_ticks," cluster ");
        all_potential_ticks = strtrim(strcat(all_potential_ticks(:,1),repelem(" ",size(all_potential_ticks,1),1),all_potential_ticks(:,2)));

        all_potential_ticks = strrep(all_potential_ticks,"approach_avoid","AA");
        all_potential_ticks = strrep(all_potential_ticks,"moral","M");
        all_potential_ticks = strrep(all_potential_ticks,"probability","P");
        all_potential_ticks = strrep(all_potential_ticks,"social","s");

        all_potential_ticks = unique(all_potential_ticks);
    end

    function [] = create_heat_map(matrix_of_data, x_and_y_ticks,mask_or_dont,the_title,which_dimension,dir_to_save_things_to,mask_level,human_stats_map)
        dimension_labels = ["log(abs(max))","log(abs(shift))","log(abs(slope))"];
        dir_to_save_things_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_things_to);


        if mask_or_dont %make all less than significant values 0
            matrix_of_data = mask_the_data(matrix_of_data,mask_level);
        end
        figure;
        heatmap(x_and_y_ticks,x_and_y_ticks,matrix_of_data)

        if ~isnan(which_dimension)
            if mask_or_dont
                title([strcat(the_title, " ", ...
                    dimension_labels(which_dimension)), ...
                    strcat("0: indicates Signficance Level >",string(mask_level)), ...
                    strcat("Number of Data Sessions:",string(human_stats_map('Number of Unique Subjects in all human data'))),...
                    strcat("Date Created:",string(datetime("today",'Format','MM-d-yyyy'))), ...
                    "Created By create\_heat\_map\_from\_map\_of\_permutations.m"]);
            else
                title([strcat(the_title, " ",dimension_labels(which_dimension)), ...
                    strcat("Number of Data Sessions:",string(human_stats_map('Number of Unique Subjects in all human data'))),...
                    strcat("Date Created:",string(datetime("today",'Format','MM-d-yyyy'))), ...
                    "Created By create\_heat\_map\_from\_map\_of\_permutations.m"]);
            end
        else

            title([strcat(the_title, " means"), ...
                strcat("Number of Data Sessions:",string(human_stats_map('Number of Unique Subjects in all human data'))),...
                strcat("Date Created:",string(datetime("today",'Format','MM-d-yyyy'))), ...
            "Created By create\_heat\_map\_from\_map\_of\_permutations.m"]);
        end

        xlabel("experiment and cluster")
        ylabel("experiment and cluster")

        if ~isnan(which_dimension)
            saveas(gcf,strcat(dir_to_save_things_to,"\",the_title," ",dimension_labels(which_dimension)),"fig")
        else
            saveas(gcf,strcat(dir_to_save_things_to,"\",the_title," Means"),"fig")
        end




    end

    function [masked_matrix] = mask_the_data(original_matrix,mask_level)
        masked_matrix = zeros(size(original_matrix,1),size(original_matrix,2));
        for current_row=1:size(original_matrix,1)
            for current_col=1:size(original_matrix,2)
                if original_matrix(current_row,current_col) > mask_level
                    masked_matrix(current_row,current_col) = 0;
                else
                    masked_matrix(current_row,current_col) = original_matrix(current_row,current_col);
                end
            end
        end
    end

unique_clusters = unique(data_table.cluster_number);
unique_experiments = unique(data_table.experiment);

matrix_length_and_width = length(unique_experiments) * length(unique_clusters);



table_from_map = table(string(keys(map_of_permutations).'),cell2mat(values(map_of_permutations).'),'VariableNames',["Permutation","Data"]);


matrix_to_turn_into_heat_map = populate_matrix(matrix_length_and_width,table_from_map,which_dimension);

x_y_ticks = get_x_y_ticks(table_from_map);


create_heat_map(matrix_to_turn_into_heat_map,get_x_y_ticks(table_from_map),mask_or_dont,the_title,which_dimension,dir_to_save_things_to,mask_level,human_stats_map)



end