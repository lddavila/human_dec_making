function [] = create_3d_bar_plots_for_mean(data_table,dir_to_save_figs_to,do_the_simplifcation_or_dont)

    function [cell_array_of_variances] = get_2d_array_of_variances(data_table,unique_clusters,unique_experiments)
        cell_array_of_variances = cell(length(unique_experiments),length(unique_clusters));
        for i=1:length(unique_experiments)
            cur_exp = unique_experiments(i);
            for j=1:length(unique_clusters)
                cur_clust = unique_clusters(j);
                only_current_cluster_and_experiment = data_table(strcmpi(data_table.experiment,cur_exp) & data_table.cluster_number==cur_clust,:);
                data_array = [only_current_cluster_and_experiment.clusterX,only_current_cluster_and_experiment.clusterY,only_current_cluster_and_experiment.clusterZ];
                cell_array_of_variances{i,j} = mean(data_array);
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
                    [h,p] = ttest2(only_current_xyz,only_curr_xyz_2);
                    map_of_signifance(sprintf("Cluster %d %s vs %s",curr_cluster,string(curr_exp),string(curr_exp_2))) = p;
                    map_of_h_values(sprintf("Cluster %d %s vs %s",curr_cluster,string(curr_exp),string(curr_exp_2))) = h;
                end
            end

        end
    end
    function [updated_array] = make_non_significant_values_negative(the_array)
        updated_array = zeros(size(the_array,1),size(the_array,2));
        for i=1:size(the_array,1)
            for j=1:size(the_array,2)
                if the_array(i,j) > 0.05
                    updated_array(i,j) = -1;
                elseif the_array(i,j) <= 0.05
                    updated_array(i,j) = 1;
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
                    significances_for_curr_exp = map_of_significance(sprintf("Cluster %d %s vs %s",curr_cluster,string(curr_exp_1),string(curr_exp_2)));
                    significances_for_curr_exp = significances_for_curr_exp(which_dimension);
                    simple_array(i,j) = significances_for_curr_exp;


                end

            end
            series_of_simple_array{k} = simple_array;
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
            ylabel("Mean");
            title(strcat("Means of Experiments ", dimensions_array(which_dimension)," Cluster ",string(k)))
            set(gcf,'renderer','Painters');

            subplot(1,2,2)
            if do_the_simplifcation_or_dont
                updated_array = make_non_significant_values_negative(simple_array_cell{k});
                b = bar3(updated_array);
            else
                b= bar3(simple_array_cell{k});
            end
            colorbar;
            for p=1:length(b)
                zdata = b(p).ZData;
                b(p).CData = zdata;
                b(p).FaceColor = 'interp';
            end

            patch([0 0 4.5 4.5], [0 4.5 4.5 0], [0.04,0.04,0.04,0.04], [1 1 -1 -1])
            set(gca,'children',flipud(get(gca,'children')))

            

            title(strcat("Sig. From Comparing Mean for Cluster ",string(k)," Across All Experiments For", dimensions_array(which_dimension)))
            subtitle("Significance determined by 2 sample t test")
            xlabel("experiment")
            ylabel("experiment")
            


            set(gca,'XTickLabel',unique_experiments)
            set(gca,'YTickLabel',unique_experiments)
            % view(gca,[18.6015   19.2830    9.5008])
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


create_the_plot(simple_array_cell,cell_array_of_variances,unique_clusters,unique_experiments,1,do_the_simplifcation_or_dont,dir_to_save_figs_to)
create_the_plot(simple_array_cell,cell_array_of_variances,unique_clusters,unique_experiments,2,do_the_simplifcation_or_dont,dir_to_save_figs_to)
create_the_plot(simple_array_cell,cell_array_of_variances,unique_clusters,unique_experiments,3,do_the_simplifcation_or_dont,dir_to_save_figs_to)

end