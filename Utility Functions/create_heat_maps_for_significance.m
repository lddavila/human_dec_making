function [] = create_heat_maps_for_significance(map_of_significances,the_title,unique_experiments,unique_clusters,dir_to_save_figs_to,human_stats_map,version_name)
    function [matrix_to_be_turned_into_heat_map] = populate_array(x_ticks,updated_x_ticks,y_ticks,map_of_significances,which_dimension)
        matrix_to_be_turned_into_heat_map = zeros(size(y_ticks,2),size(updated_x_ticks,2));
        for cluster_count=1:length(y_ticks)
            current_cluster = y_ticks{cluster_count};
            for i=1:length(x_ticks)
                exp_1 = x_ticks{i};
                for j=i+1:length(x_ticks)
                    exp_2 = x_ticks{j};
                    clc;
                    disp(sprintf('%s %s vs %s %s ',exp_1,current_cluster,exp_2,current_cluster))
                    the_values = map_of_significances(sprintf('%s %s vs %s %s ',exp_1,current_cluster,exp_2,current_cluster));
                    relevant_signifance = the_values(which_dimension);

                    %use the exp 1 and exp 2 to find the column position this significance belongs to

                    string_to_match_to = strcat(exp_1,"->",exp_2);
                    for k=1:length(updated_x_ticks)
                        if strcmpi(string(string_to_match_to),string(updated_x_ticks{k}))
                            break;
                        end
                    end
                    
                    col_position = k;
                    matrix_to_be_turned_into_heat_map(cluster_count,col_position) = relevant_signifance;
                end
            end
        end
    end

   
    function [] = create_heat_map(the_title,dir_to_save_figs_to,which_dimension,updated_array,updated_x_ticks,y_ticks,human_stats_map)
        figure('units','normalized','outerposition',[0 0 1 1]);
        dimensions_label = ["log(abs(max))","log(abs(shift))","log(abs(slope))"];
        current_dimension = dimensions_label(which_dimension);

        heatmap(updated_x_ticks,y_ticks,updated_array,'ColorMap', flip(sky),'CellLabelFormat','%.3f');

        title([strcat(the_title," ", current_dimension),...
            strcat("# of approach avoid sessions",string(human_stats_map("approach_avoid Number of Data Points"))),...
            strcat("# of moral sessions",string(human_stats_map("moral Number of Data Points"))),...
            strcat("# of probability sessions",string(human_stats_map("probability Number of Data Points"))),...
            strcat("# of social sessions",string(human_stats_map("social Number of Data Points"))),...
            strcat("Date Created:",string(datetime("today",'Format','MM-d-yyyy'))), ...
             "Created By create\_heat\_maps\_for\_significance.m", ...
             version_name]);
        dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);

        saveas(gcf,strcat(dir_to_save_figs_to,"\",the_title," ", current_dimension," ",version_name,".fig"),"fig")
        
    end

    function [updated_y_ticks] = create_updated_y_ticks(unique_experiments)
        updated_y_ticks = {};
        for i=1:length(unique_experiments)
            exp_1 = unique_experiments(i);
            for j=i+1:length(unique_experiments)
                exp_2 = unique_experiments(j);
                updated_y_ticks{end+1} = char(strcat(string(exp_1),"->",string(exp_2)));

            end
        end
    end

    function [y_ticks] = create_cell_array_of_cluster_labels(unique_clusters)
        y_ticks = cell(1,length(unique_clusters));
        for i=1:length(unique_clusters)
            y_ticks{i} = char(strcat("cluster ",string(unique_clusters(i))));
        end
    end

x_ticks = unique_experiments;
y_ticks = create_cell_array_of_cluster_labels(unique_clusters);

updated_x_ticks = create_updated_y_ticks(unique_experiments);

matrix_to_be_turned_into_heat_map_x = populate_array(x_ticks,updated_x_ticks,y_ticks,map_of_significances,1);
matrix_to_be_turned_into_heat_map_y = populate_array(x_ticks,updated_x_ticks,y_ticks,map_of_significances,2);
matrix_to_be_turned_into_heat_map_z = populate_array(x_ticks,updated_x_ticks,y_ticks,map_of_significances,3);


create_heat_map(the_title,dir_to_save_figs_to,1,matrix_to_be_turned_into_heat_map_x,updated_x_ticks,y_ticks,human_stats_map);
create_heat_map(the_title,dir_to_save_figs_to,2,matrix_to_be_turned_into_heat_map_y,updated_x_ticks,y_ticks,human_stats_map);
create_heat_map(the_title,dir_to_save_figs_to,3,matrix_to_be_turned_into_heat_map_z,updated_x_ticks,y_ticks,human_stats_map);



end

