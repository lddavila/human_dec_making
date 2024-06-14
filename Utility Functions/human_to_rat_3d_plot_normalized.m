function [] = human_to_rat_3d_plot_normalized(human_data_table,rat_data_table,what_data,colors,dir_to_save_figs_to)
figure;
dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);
data_table = human_data_table;
unique_clusters = unique(data_table.cluster_number);
legend_strings = cell(1,length(unique_clusters)+length(unique(rat_data_table.cluster_number)));
plot_objects = cell(1,length(unique_clusters));

cell_array_of_xyz = cell(1,length(unique(human_data_table.cluster_number))+length(unique(rat_data_table.cluster_number)));

data_table = human_data_table;
data_from_data_table = [data_table.clusterX,data_table.clusterY,data_table.clusterZ];
data_from_data_table = normalize(data_from_data_table,"range",[0,1]);
data_table.clusterX = data_from_data_table(:,1);
data_table.clusterY = data_from_data_table(:,2);
data_table.clusterZ = data_from_data_table(:,3);
human_data_table = data_table;

data_table = rat_data_table;
data_from_data_table = [data_table.clusterX,data_table.clusterY,data_table.clusterZ];
data_from_data_table = normalize(data_from_data_table,"range",[0,1]);
data_table.clusterX = data_from_data_table(:,1);
data_table.clusterY = data_from_data_table(:,2);
data_table.clusterZ = data_from_data_table(:,3);
rat_data_table = data_table;


data_table = human_data_table;
for i=1:length(unique_clusters)
    curr_clust = unique_clusters(i);
    curr_color = colors(1,:);
    data_table_of_current_clust = data_table(data_table.cluster_number==curr_clust,:);
    curr_clust_xyz = [data_table_of_current_clust.clusterX,data_table_of_current_clust.clusterY,data_table_of_current_clust.clusterZ];
    random_sample_array = [];
    for k=1:1100
        random_sample_array = [random_sample_array;datasample(curr_clust_xyz,1)];
    end
    cell_array_of_xyz{i} = random_sample_array;
    scatter3(curr_clust_xyz(:,1),curr_clust_xyz(:,2),curr_clust_xyz(:,3),'MarkerFaceColor',curr_color,'MarkerEdgeColor',curr_color);
    % plot_objects{i} = boundary(curr_clust_xyz(:,1),curr_clust_xyz(:,2),curr_clust_xyz(:,3),1);
    legend_strings{i} = char(strcat("Human Cluster ", string(i)));
    % plot_objects{i} = trisurf(plot_objects{i},curr_clust_xyz(:,1),curr_clust_xyz(:,2),curr_clust_xyz(:,3),'Facecolor',curr_color);
    hold on;
end


data_table = rat_data_table;
unique_clusters = unique(data_table.cluster_number);
for i=1:length(unique_clusters)
    curr_clust = unique_clusters(i);
    curr_color = colors(2,:);
    data_table_of_current_clust = data_table(data_table.cluster_number==curr_clust,:);
    curr_clust_xyz = [data_table_of_current_clust.clusterX,data_table_of_current_clust.clusterY,data_table_of_current_clust.clusterZ];
    scatter3(curr_clust_xyz(:,1),curr_clust_xyz(:,2),curr_clust_xyz(:,3),'MarkerFaceColor',curr_color,'MarkerEdgeColor',curr_color);
    random_sample_array = [];
    for k=1:1100
        random_sample_array = [random_sample_array;datasample(curr_clust_xyz,1)];
    end
    cell_array_of_xyz{i + length(unique(human_data_table.cluster_number))} = random_sample_array;
    % plot_objects{i} = boundary(curr_clust_xyz(:,1),curr_clust_xyz(:,2),curr_clust_xyz(:,3),1);
    legend_strings{i + length(unique(human_data_table.cluster_number))} = char(strcat("Rat Cluster ", string(i)));
    % plot_objects{i} = trisurf(plot_objects{i},curr_clust_xyz(:,1),curr_clust_xyz(:,2),curr_clust_xyz(:,3),'Facecolor',curr_color);
    hold on;
end
legend(legend_strings);
xlabel("log(abs(max))")
ylabel("log(abs(shift))")
zlabel("log(abs(slope))")


for i=1:length(cell_array_of_xyz)
    cluster_i = cell_array_of_xyz{i};
    for k=i+1:length(cell_array_of_xyz)
        if i <= length(unique(human_data_table.cluster_number))
            disp(strcat("Human Cluster ",string(i)));
            cluster_i_title = strcat("Human Cluster ",string(i));
        else
            disp(strcat("Rat Cluster ",string(i - length(unique(human_data_table.cluster_number)))));
            cluster_i_title = strcat("Rat Cluster ",string(i - length(unique(human_data_table.cluster_number))));
        end
        if k <= length(unique(human_data_table.cluster_number))
            disp(strcat("Human Cluster ",string(k)));
            cluster_k_title = strcat("Human Cluster ",string(k));
        else
            disp(strcat("Rat Cluster",string(k - length(unique(human_data_table.cluster_number)))));
            cluster_k_title = strcat("Rat Cluster ",string(k - length(unique(human_data_table.cluster_number))));
        end

        if i < length(unique(human_data_table.cluster_number)) && k > length(unique(human_data_table.cluster_number))



            cluster_k = cell_array_of_xyz{k};

            [Ricp, Ticp, ER, t] = icp(transpose(cluster_i),transpose(cluster_k));
            Dicp = Ricp * transpose(cluster_k) + repmat(Ticp, 1, height(cluster_k));
            figure('units','normalized','outerposition',[0 0 1 1]);

            subplot(1,2,1);
            k_1 = boundary(cluster_i);

            % trisurf(k_1,cluster_i(:,1),cluster_i(:,2),cluster_i(:,3),'Facecolor','red','FaceAlpha',0.1)
            hold on;
            k_2 = boundary(cluster_k);
            % trisurf(k_2,cluster_k(:,1),cluster_k(:,2),cluster_k(:,3),'Facecolor','blue','FaceAlpha',0.1)
            % plot3(cluster_i(:,1),cluster_i(:,2),cluster_i(:,3),'bo',cluster_k(:,1),cluster_k(:,2),cluster_k(:,3),'ro');
            axis equal;
            xlabel('x'); ylabel('y'); zlabel('z');
            legend({char(cluster_i_title),char(cluster_k_title)});

            xlabel("log(abs(max))")
            ylabel("log(abs(shift))")
            zlabel("log(abs(slope))")


            % Plot the results
            subplot(1,2,2);
            plot3(cluster_i(:,1),cluster_i(:,2),cluster_i(:,3),'bo',Dicp(1,:),Dicp(2,:),Dicp(3,:),'r.');
            k_1 = boundary(cluster_i);
            hold on
            % trisurf(k_1,cluster_i(:,1),cluster_i(:,2),cluster_i(:,3),'Facecolor','red','FaceAlpha',0.1)
            k_2 = boundary(transpose(Dicp));
            % trisurf(k_2,Dicp(1,:),Dicp(2,:),Dicp(3,:),'Facecolor','blue','FaceAlpha',0.1)
            axis equal;
            xlabel('x'); ylabel('y'); zlabel('z');
            title('ICP result');
            legend({char(cluster_i_title),char(cluster_k_title)});



            % plot3(cluster_i(1,:),cluster_i(2,:),cluster_i(3,:),'bo',cluster_k(1,:),cluster_k(2,:),cluster_k(3,:),'r.');
            % axis equal;
            % xlabel('x'); ylabel('y'); zlabel('z');
            sgtitle([strcat(cluster_i_title, " Transformed To Match ", cluster_k_title), ...
                ]);

            xlabel("log(abs(max))")
            ylabel("log(abs(shift))")
            zlabel("log(abs(slope))")
            axis equal;

            saveas(gcf,strcat(dir_to_save_figs_to,"\",strcat(cluster_i_title, " Transformed To Match ", cluster_k_title),".fig"),"fig")
            close(gcf);
        else
            % close(gcf)
            continue;

        end
    
    end
end
% title([strcat(what_data)]);



end