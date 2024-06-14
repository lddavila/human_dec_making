function [] = create_fig_mapping_rat_to_human_plots(human_data_table,rat_data_table,dir_to_save_figs_to,normalize_or_dont,colors,version_name,threshold_set)
    function [largest_number] = get_largest_number_of_cols(rat_clusters_to_map)
        largest_number=0;
        for p=1:length(rat_clusters_to_map)
            if size(rat_clusters_to_map{p},2) > largest_number
                largest_number = size(rat_clusters_to_map{p},2);
            end
        end
    end
    function [normalized_data] = normalize_the_data(data_table)
        data_xyz = [data_table.clusterX,data_table.clusterY,data_table.clusterZ];
        data_xyz = normalize(data_xyz,"range");
        data_table.clusterX = data_xyz(:,1);
        data_table.clusterY = data_xyz(:,2);
        data_table.clusterZ = data_xyz(:,3);
        normalized_data = data_table;
    end
    function [human_clusters_to_map,rat_clusters_to_map,which_dimension_theyre_related_by] = determine_which_human_and_rat_clusters_are_connected(human_data_table,rat_data_table,threshold_set)
        human_clusters = unique(human_data_table.cluster_number);
        rat_clusters = unique(rat_data_table.cluster_number);

        human_clusters_to_map = cell(1,length(human_clusters));
        rat_clusters_to_map = cell(1,length(human_clusters));
        which_dimension_theyre_related_by = cell(1,length(human_clusters));

        for k=1:length(human_clusters)
            curr_hum_clust = human_clusters(k);
            human_clusters_to_map{curr_hum_clust} = {curr_hum_clust};
            hum_curr_clust = human_data_table(human_data_table.cluster_number == curr_hum_clust,:);
            human_xyz_curr_clust = [hum_curr_clust.clusterX,hum_curr_clust.clusterY,hum_curr_clust.clusterZ];
            human_labels = logical(zeros(height(hum_curr_clust),1));
            for c=1:length(rat_clusters)
                curr_rat_clust = rat_clusters(c);
                
                rat_curr_clust = rat_data_table(rat_data_table.cluster_number == curr_rat_clust,:);
                rat_xyz_curr_clust = [rat_curr_clust.clusterX,rat_curr_clust.clusterY,rat_curr_clust.clusterZ];
                rat_labels = logical(zeros(height(rat_curr_clust),1) +1);
                bhaat_dist_from_curr_human_clust_to_curr_rat_clust = bhattacharyyaDistance([human_xyz_curr_clust;rat_xyz_curr_clust],[human_labels;rat_labels]);
                related_by = '';
                if any(mean(bhaat_dist_from_curr_human_clust_to_curr_rat_clust)< threshold_set)
                    for q=1:length(bhaat_dist_from_curr_human_clust_to_curr_rat_clust)
                        if bhaat_dist_from_curr_human_clust_to_curr_rat_clust(q) <threshold_set
                            if q==1
                                the_addition = "max";
                            elseif q==2
                                the_addition= "shift";
                            elseif q==3
                                the_addition = "slope";
                            end

                            if(isempty(related_by))
                                related_by= the_addition;
                            else
                                related_by = strcat(related_by,",",the_addition);
                            end

                        end
                    end
                    related_by = strcat(related_by," ",strjoin(string(round(bhaat_dist_from_curr_human_clust_to_curr_rat_clust,2))));
                    if isempty(rat_clusters_to_map{k}) 
                        rat_clusters_to_map{k} = {curr_rat_clust};
                        which_dimension_theyre_related_by{k} = {related_by};
                    else
                        rat_clusters_to_map{k}{end+1} = curr_rat_clust;
                        which_dimension_theyre_related_by{k}{end+1} = related_by;
                    end
                end

            end
        end
    end

dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);
figure('units','normalized','outerposition',[0 0 1 1])

if normalize_or_dont
    human_data_table = normalize_the_data(human_data_table);
    rat_data_table = normalize_the_data(rat_data_table);
end

[human_clusters_to_map,rat_clusters_to_map,which_dimension_theyre_related_by] = determine_which_human_and_rat_clusters_are_connected(human_data_table,rat_data_table,threshold_set);
number_of_rows = length(unique(human_data_table.cluster_number));
number_of_cols = get_largest_number_of_cols(rat_clusters_to_map)+1;
tiledlayout(number_of_rows,number_of_cols);

rat_cluster_proportions = get_cluster_counts(rat_data_table,unique(rat_data_table.cluster_number)) ./ height(rat_data_table);
human_clusters_proportions = get_cluster_counts(human_data_table,unique(human_data_table.cluster_number)) ./ height(human_data_table);




for i=1:size(human_clusters_to_map,2)
    ax = nexttile();
    human_color = colors(1,:);
    rat_color = colors(2,:);
    current_human_clusters = cell2mat(human_clusters_to_map{i});
    current_rat_clusters = cell2mat(rat_clusters_to_map{i});

    current_human_cluster = current_human_clusters(1);
    current_human_data = human_data_table(human_data_table.cluster_number == current_human_cluster,:);

    human_xyz = [current_human_data.clusterX,current_human_data.clusterY,current_human_data.clusterZ];

    scatter3(ax,human_xyz(:,1),human_xyz(:,2),human_xyz(:,3),'MarkerFaceColor',human_color,'MarkerEdgeColor',human_color);
    title([strcat("Human Cluster: ",string(current_human_cluster)), ...
        strcat("Contains ", string(round(human_clusters_proportions(current_human_cluster)*100)),"% of Human AA Data")])
    legend(char(strcat("Human Cluster ",string(i))),'Location','best')
    % hold on;

    for j=1:size(current_rat_clusters,2)
        ax = nexttile();
        current_rat_cluster = current_rat_clusters(j);
        current_rat_data = rat_data_table(rat_data_table.cluster_number == current_rat_cluster,:);
        rat_xyz = [current_rat_data.clusterX,current_rat_data.clusterY,current_rat_data.clusterZ];
        scatter3(ax,human_xyz(:,1),human_xyz(:,2),human_xyz(:,3),'MarkerFaceColor',human_color,'MarkerEdgeColor',human_color);
        hold on;
        scatter3(ax,rat_xyz(:,1),rat_xyz(:,2),rat_xyz(:,3), 'MarkerFaceColor',rat_color,'MarkerEdgeColor',rat_color);
        title([strcat("Hu. Cl.: ",string(current_human_cluster)," ", string(round(human_clusters_proportions(current_human_cluster)* 100)),"%"), ...
            strcat("Rat Cl.: ",string(current_rat_cluster), " Contains ", string(round(rat_cluster_proportions(current_rat_cluster)*100)), "% of Rat Data"), ...
            ]);
        legend(char(strcat("Human Cluster ", string(current_human_cluster))), char(strcat("Rat Cluster ", string(current_rat_cluster))),'Location','best')
        hold off;

    end
    if isempty(j)
        j=1;
        ax = nexttile();
    end
    while j<number_of_cols-1
        ax = nexttile();
        j=j+1;
    end

end
if normalize_or_dont
    sgtitle(["Normalized", ...
        strrep(version_name,"_","\_"), ...
        strcat("Related is defined as mean bhaat. distance <",string(threshold_set)),...
        strcat("Created by create\_fig\_mapping\_rat\_to\_human\_plots.m"), ...
        strcat("Date Created:",string(datetime("today",'Format','MM-d-yyyy'))) ...
        ])
else
    sgtitle(["Not Normalized", ...
        strrep(version_name,"_","\_"), ...
        strcat("Related is defined as mean bhaat. distance <",string(threshold_set)),...
        strcat("Created by create\_fig\_mapping\_rat\_to\_human\_plots.m"), ...
        strcat("Date Created:",string(datetime("today",'Format','MM-d-yyyy'))) ...
        ])
end
set(gcf,'renderer','Painters');
end
