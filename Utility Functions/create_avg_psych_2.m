function create_avg_psych_2(type, same_scale, save_to,data_table,raw_data)
% format the raw data
raw_data.subjectid = string(raw_data.subjectid);
raw_data.date = string(raw_data.date);

single_col = strcat(raw_data.subjectid,repelem(" ",height(raw_data),1),raw_data.date,repelem(".mat",height(raw_data),1));

raw_data = table(strrep(single_col,"/","-"),raw_data.x1,raw_data.x2,raw_data.x3,raw_data.x4, ...
    raw_data.y1,raw_data.y2,raw_data.y3,raw_data.y4, ...
    'VariableNames',{'clusterLabels','x1','x2','x3','x4','y1','y2','y3','y4'});

% format the data_table
data_table.clusterLabels = string(data_table.clusterLabels);

clusters = unique(data_table.cluster_number);
num_clusters = length(clusters);

ax = zeros(num_clusters,1);
y_min = 100;
y_max = 0;
for i = 1 : num_clusters
    cluster = clusters(i);
    disp(strcat("Cluster ",string(cluster)))
    data_table_curr_clust = data_table(data_table.cluster_number == cluster,:);

    table_with_required_info = join(data_table_curr_clust,raw_data,'key','clusterLabels');

    mean_lvl_1 = mean(table_with_required_info.y1, 'omitnan');
    mean_lvl_2 = mean(table_with_required_info.y2, 'omitnan');
    mean_lvl_3 = mean(table_with_required_info.y3, 'omitnan');
    mean_lvl_4 = mean(table_with_required_info.y4, 'omitnan');

    x = [0.09 0.05 0.02 0.005];
    y = [mean_lvl_1, mean_lvl_2, mean_lvl_3, mean_lvl_4];

    ax(i) = subplot(1,num_clusters,i);

    if  ~anynan(x) && ~anynan(y)
        fit_sigmoid(x,y);
    end
    yl = get(gca, 'YLim');
    curr_y_min = yl(1);
    curr_y_max = yl(2);
    if curr_y_min < y_min 
        y_min = curr_y_min;
    end
    if curr_y_max > y_max
        y_max = curr_y_max;
    end
    title("cluster " + string(i))

end
figname = save_to + "/" + strrep(type," ", "_") + ".fig";
if same_scale
    set(ax, 'YLim', [y_min y_max])
    figname = save_to + "/" + strrep(type," ", "_") + "_same_scale.fig";
end
sgtitle("average sigmoid per cluster for " + type)
savefig(figname)
close all 
end