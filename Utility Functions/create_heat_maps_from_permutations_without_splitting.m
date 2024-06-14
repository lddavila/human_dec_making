function [] = create_heat_maps_from_permutations_without_splitting(the_permutations,dir_to_save_figs_to,version_name,human_data_table,the_title,stats_map)

    function [heat_map_matrix,labels_to_use] = construct_matrix_to_turn_into_heat_map(unique_clusters,which_dimension,the_permutations)
        labels_to_use = cell(1,length(unique_clusters));
        heat_map_matrix = zeros(length(unique_clusters),length(unique_clusters));
        for i=1:length(unique_clusters)
            cluster_1 = unique_clusters(i);
            labels_to_use{cluster_1} = char(strcat("cluster ",string(cluster_1)));
            for j=1:length(unique_clusters)
                cluster_2 = unique_clusters(j);
                the_key_to_use = char(strcat("cluster ",string(cluster_1)," vs cluster ", string(cluster_2)));
                % disp(the_key_to_use)
                info_from_permutations = the_permutations(the_key_to_use);
                heat_map_matrix(cluster_1,cluster_2) = info_from_permutations(which_dimension);
            end
        end

    end
    function [] = create_the_heat_map(heat_map_matrix,labels_to_use,the_title,dir_to_save_figs_to,version_name,which_dimension,stats_map)
        figure;
        dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);
        heatmap(labels_to_use,labels_to_use,heat_map_matrix);
        if strcmpi(the_title,"bhat distance")
            clim([0,1])
            significance_determined_by = "bhat distance";
        end
        if strcmpi(the_title,"mean") 
            colormap(flip(sky));
            significance_determined_by = " ttest2";
        end
        if strcmpi(the_title,"variance")
            colormap(flip(sky));
            significance_determined_by = "vartest2";
        end
        
        if which_dimension==1
            add_to_title = "Log(abs(max))";
        elseif which_dimension ==2
            add_to_title = "Log(abs(shift))";
        elseif which_dimension == 3
            add_to_title = "Log(abs(slope))";
        end

        title([strcat(the_title," ", add_to_title), ...
            strcat("Significance Determined By: ",significance_determined_by),...
            version_name, ...
            strcat("# of data points: ",string(stats_map('Number of Sessions in all human data'))," Number of subjects:",string(stats_map('Number of Unique Subjects in all human data'))),...
            strcat("Date Created: ",string(datetime("today",'Format','MM-d-yyyy'))),...
            strcat("created by create\_heat\_maps\_from\_permutations\_without\_splitting.m")]);
        saveas(gcf,strcat(dir_to_save_figs_to,"\",the_title," ",add_to_title," ",version_name))

    end
unique_clusters = unique(human_data_table.cluster_number);

[heat_map_matrix,labels_to_use] = construct_matrix_to_turn_into_heat_map(unique_clusters,1,the_permutations);
create_the_heat_map(heat_map_matrix,labels_to_use,the_title,dir_to_save_figs_to,version_name,1,stats_map);

[heat_map_matrix,labels_to_use] = construct_matrix_to_turn_into_heat_map(unique_clusters,2,the_permutations);
create_the_heat_map(heat_map_matrix,labels_to_use,the_title,dir_to_save_figs_to,version_name,2,stats_map);

[heat_map_matrix,labels_to_use] = construct_matrix_to_turn_into_heat_map(unique_clusters,3,the_permutations);
create_the_heat_map(heat_map_matrix,labels_to_use,the_title,dir_to_save_figs_to,version_name,3,stats_map);



end