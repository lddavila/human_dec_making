function [] = create_heat_maps_for_variance(data_table,dir_to_save_figs_to,do_the_simplifcation_or_dont)

    function [cell_array_of_variances] = get_2d_array_of_variances(data_table,unique_clusters,unique_experiments)
        cell_array_of_variances = cell(length(unique_experiments),length(unique_clusters));
        for i=1:length(unique_experiments)
            cur_exp = unique_experiments(i);
            for j=1:length(unique_clusters)
                cur_clust = unique_clusters(j);
                only_current_cluster_and_experiment = data_table(strcmpi(data_table.experiment,cur_exp) & data_table.cluster_number==cur_clust,:);
                data_array = [only_current_cluster_and_experiment.clusterX,only_current_cluster_and_experiment.clusterY,only_current_cluster_and_experiment.clusterZ];
                cell_array_of_variances{i,j} = var(data_array);
            end
        end
    end
    function [map_of_signifance,map_of_h_values] = get_map_of_signifance(data_table,unique_clusters,unique_experiments)
        map_of_signifance = containers.Map('KeyType','char','ValueType','any');
        map_of_h_values = containers.Map('KeyType','char','ValueType','any');
        for i=1:length(unique_clusters)
            curr_cluster = unique_clusters(i);
            only_current_cluster_data = data_table(data_table.cluster_number == curr_cluster,:);
            for j=1:length(unique_experiments)
                curr_exp = unique_experiments(j);
                only_cur_exp = only_current_cluster_data(strcmpi(only_current_cluster_data.experiment,curr_exp),:);
                only_current_xyz = [only_cur_exp.clusterX,only_cur_exp.clusterY,only_cur_exp.clusterZ];
                for k=1:length(unique_experiments)
                    curr_exp_2 = unique_experiments(k);
                    only_curr_exp_2 = only_current_cluster_data(strcmpi(only_current_cluster_data.experiment,curr_exp_2),:);
                    only_curr_xyz_2 = [only_curr_exp_2.clusterX,only_curr_exp_2.clusterY,only_curr_exp_2.clusterZ];
                    [h,p] = vartest2(only_current_xyz,only_curr_xyz_2);
                    map_of_signifance(sprintf("Cluster %d %s vs %s",curr_cluster,string(curr_exp),string(curr_exp_2))) = p;
                    map_of_h_values(sprintf("Cluster %d %s vs %s",curr_cluster,string(curr_exp),string(curr_exp_2))) = h;
                end
            end

        end
    end
    function [updated_array] = make_diagonal_nan(the_array)
        updated_array = zeros(size(the_array,1),size(the_array,2));
        for i=1:size(the_array,1)
            for j=1:size(the_array,2)
                if i==j
                    updated_array(i,j) = nan;
                else
                    updated_array(i,j) = the_array(i,j);
                end
            end
        end
    end
    function [updated_array] = make_non_significant_values_zero(the_array)
        updated_array = zeros(size(the_array,1),size(the_array,2));
        for i=1:size(the_array,1)
            for j=1:size(the_array,2)
                if the_array(i,j) > 0.05
                    updated_array(i,j) = 0;
                else
                    updated_array(i,j) = the_array(i,j);
                end
            
            end
        end
    end
    function [series_of_simple_array] = turn_map_into_simple_arrays(map_of_significance,unique_experiments,unique_clusters,which_dimension)
        series_of_simple_array = cell(1,length(unique_clusters));
        for k=1:length(unique_clusters)
            curr_cluster=unique_clusters(k);
            simple_array = ones(length(unique_experiments),length(unique_experiments));
            for i=1:length(unique_experiments)
                curr_exp_1 = unique_experiments(i);
                for j=1:length(unique_experiments)
                    curr_exp_2 = unique_experiments(j);
                    significances_for_curr_exp = map_of_significance(strrep(sprintf("Cluster %d %s vs %s",curr_cluster,string(curr_exp_1),string(curr_exp_2)),"\_","_"));
                    significances_for_curr_exp = significances_for_curr_exp(which_dimension);
                    simple_array(i,j) = significances_for_curr_exp;


                end

            end
            series_of_simple_array{k} = simple_array;
        end

    end
    function [formatted_labels] = turn_labels_into_char_cell_array(labels)
        formatted_labels = cell(1,length(labels));
        for i=1:length(labels)
            formatted_labels{i} = char(labels(i));
        end
    end
    function [] = create_the_plot(simple_array_cell,cell_array_of_variances,unique_clusters,unique_experiments,which_dimension,do_the_simplifcation_or_dont,dir_to_save_figs_to)
        for k=1:length(unique_clusters)
            simple_array_of_variances = zeros(1,length(unique_experiments));
            for i=1:length(unique_experiments)
                current_var_data = cell_array_of_variances{i,k};
                simple_array_of_variances(i) = current_var_data(which_dimension);
            end

            dimensions_array = ["log(abs(max))","log(abs(shift))","log(abs(slope))"];
            figure('units','normalized','outerposition',[0 0 1 1])
            subplot(1,2,1);
            bar(unique_experiments,simple_array_of_variances);
            xlabel("Experiment");
            ylabel("Variance");
            title(strcat("Variances of Experiments ", dimensions_array(which_dimension)," Cluster ",string(k)))
            set(gcf,'renderer','Painters');

            subplot(1,2,2)
            if do_the_simplifcation_or_dont
                updated_array = make_non_significant_values_zero(simple_array_cell{k});
                updated_array = make_diagonal_nan(updated_array);
                heatmap(unique_experiments,unique_experiments,updated_array);
            else
                heatmap(unique_experiments,unique_experiments,make_diagonal_nan(simple_array_cell{k}));
            end
            
            if do_the_simplifcation_or_dont
                title([strcat("Significant change in variance or not Cluster ",string(k)," Across All Experiments For ", dimensions_array(which_dimension)),"Significance determined by 2 sample F test", "0: Not Significant"])
            else
                title([strcat("Sig. From Comparing Variance for Cluster ",string(k)," Across All Experiments For", dimensions_array(which_dimension)),"Significance determined by 2 sample F test"])
            end
            xlabel("experiment")
            ylabel("experiment")
            


            set(gcf,'renderer','Painters');

            sgtitle(strcat("Cluster",string(k)))

            saveas(gcf,strcat(dir_to_save_figs_to,"\Cluster ",string(k)," ",dimensions_array(which_dimension),".fig"),"fig")
            

            
        end



    end
dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);
unique_clusters = unique(data_table.cluster_number);
unique_experiments = unique(data_table.experiment);

cell_array_of_variances = get_2d_array_of_variances(data_table,unique_clusters,unique_experiments);
%each row of the vell_array_of_variances is an experiment
%each column is a cluster
%the first value of the each item in cell_array_of_variances is the variance of the z values
%the second value of each item in cell_array_of_variances is the variance of the y values
%the third value of each item in cell_array_of_variances is the variance of the z values

[map_of_signifance,map_of_h_values] = get_map_of_signifance(data_table,unique_clusters,unique_experiments);

simple_array_cell =turn_map_into_simple_arrays(map_of_signifance,unique_experiments,unique_clusters,1);

for something=1:length(unique_experiments)
    unique_experiments{something} = char(strrep(unique_experiments{something},"_","\_"));
end
create_the_plot(simple_array_cell,cell_array_of_variances,unique_clusters,unique_experiments,1,do_the_simplifcation_or_dont,dir_to_save_figs_to)
simple_array_cell = turn_map_into_simple_arrays(map_of_signifance,unique_experiments,unique_clusters,2);
create_the_plot(simple_array_cell,cell_array_of_variances,unique_clusters,unique_experiments,2,do_the_simplifcation_or_dont,dir_to_save_figs_to)
simple_array_cell = turn_map_into_simple_arrays(map_of_signifance,unique_experiments,unique_clusters,3);
create_the_plot(simple_array_cell,cell_array_of_variances,unique_clusters,unique_experiments,3,do_the_simplifcation_or_dont,dir_to_save_figs_to)

end