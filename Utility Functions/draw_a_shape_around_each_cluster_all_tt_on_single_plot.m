function [] = draw_a_shape_around_each_cluster_all_tt_on_single_plot(data_table,stats_map,human_or_rat,what_data,dir_to_save_figs_to,draw_lines_or_dont,colors)
% figure;
unique_clusters = unique(data_table.cluster_number);
unique_experiments =unique(data_table.experiment);
legend_strings = cell(1,length(unique_clusters));
plot_objects = cell(1,length(unique_clusters));

for j=1:length(unique_experiments)
    
    exp_1 = unique_experiments(j);
    exp_1_table = data_table(strcmpi(string(data_table.experiment),exp_1),:);


    exp_1_color = colors(1,:);
    for k=j+1:length(unique_experiments)
        figure;
        exp_2 = unique_experiments(k);
        disp(strcat(exp_1, " vs ",exp_2))
        exp_2_table = data_table(strcmpi(string(data_table.experiment),exp_2),:);
        exp_2_color = colors(2,:);

        for i=1:length(unique_clusters)
            current_cluster = unique_clusters(i);
            curr_clust_exp_1 = exp_1_table(exp_1_table.cluster_number==current_cluster,:);
            curr_clust_exp_2 = exp_2_table(exp_2_table.cluster_number==current_cluster,:);


            curr_clust_xyz_and_exp_1= [curr_clust_exp_1.clusterX,curr_clust_exp_1.clusterY,curr_clust_exp_1.clusterZ];
            curr_clust_xyz_and_exp_2 = [curr_clust_exp_2.clusterX,curr_clust_exp_2.clusterY,curr_clust_exp_2.clusterZ];


            k1 = boundary(curr_clust_xyz_and_exp_1(:,1),curr_clust_xyz_and_exp_1(:,2),curr_clust_xyz_and_exp_1(:,3));
            trisurf(k1,curr_clust_xyz_and_exp_1(:,1),curr_clust_xyz_and_exp_1(:,2),curr_clust_xyz_and_exp_1(:,3),'Facecolor',exp_1_color);
            hold on;

            k2 = boundary(curr_clust_xyz_and_exp_2(:,1),curr_clust_xyz_and_exp_2(:,2),curr_clust_xyz_and_exp_2(:,3));
            trisurf(k2,curr_clust_xyz_and_exp_2(:,1),curr_clust_xyz_and_exp_2(:,2),curr_clust_xyz_and_exp_2(:,3),'Facecolor',exp_2_color);


            % [d,Z] = procrustes(curr_clust_exp_1,curr_clust_exp_2);
            % disp(strcat("Procrustes Distance Between Cluster",string(current_cluster)," ",exp_1, " vs ", exp_2 ))
            % disp(d)
            % disp(Z);

        end

        title([strcat(exp_1, " vs ", exp_2)]);
        hold off;
        legend({char(exp_1),char(exp_2)})

    end
end




% title([strcat(what_data)]);
legend(legend_strings);
xlabel("log(abs(max))")
ylabel("log(abs(shift))")
zlabel("log(abs(slope))")

end