function [best_mpc,all_scatter_objects,all_marker_objects] = create_a_plot_updated_3(fig_handle,xVsY,labels,xAxis,yAxis,feature,experiment,folder_where_cluster_tables_should_be_saved,called_by,folder_where_figures_should_be_saved)
%% format underscores
% experiment = strrep(experiment,"_","\_");
called_by = strrep(called_by,"_","\_");


%% run fcm multiple times to find which one gives best mpc thus giving us ideal number of clusters
if strcmpi(xAxis,"max") && strcmpi(yAxis,"shift")
    [centers,U] = fcm(xVsY,4);
    best_mpc = calculate_mpc(U);
    number_of_clusters=size(centers,1);

elseif strcmpi(xAxis,"max") && strcmpi(yAxis,"steepness")
    [centers,U] = fcm(xVsY);
    best_mpc = calculate_mpc(U);
    number_of_clusters = size(centers,1);

elseif strcmpi(xAxis,"shift") && strcmpi(yAxis,"steepness")
    [centers,U] = fcm(xVsY);
    best_mpc = calculate_mpc(U);
    number_of_clusters = size(centers,1);

end


%% plot the results
maxU = max(U);
hold on;
all_scatter_objects = {};
all_marker_objects = {};
letter = "";

switch feature
    case "rotation_points_method_4"
        letter = "RP4";
    case "rotation_points_method_1"
        letter = "RP1";
    case "reward_choice"
        letter = "M";
    case "entry_time"
        letter = "ET";
    case "distance_traveled"
        letter = "DT";
    case "stopping_points"
        letter = "SP";
end
number_of_data_points = size(xVsY,1);

for i =1:number_of_clusters
    indexes = find(U(i,:)==maxU);
    scatter(xVsY(indexes,1),xVsY(indexes,2))
    hold on;
    plot(centers(i,1),centers(i,2),"xk",MarkerSize=15,LineWidth=3);


    %% add the labels to each data point which tells us the name and date of the rats
    all_scatter_objects{end+1} = scatter(xVsY(indexes,1),xVsY(indexes,2));
    s = all_scatter_objects{i};
    s.DataTipTemplate.DataTipRows(end+1) = dataTipTextRow("Session_Label:",labels(indexes,1));
    all_marker_objects{end+1} = plot(centers(i,1),centers(i,2),'xk','MarkerSize',15,'LineWidth',3);

    %% add The Cluster Size, Number, and Size of Data Set to the Cluster Centers
    a = all_marker_objects{i};
    a.DataTipTemplate.DataTipRows(end+1) = dataTipTextRow("Cluster:", i);
    clusterTable = getClusterTable(xVsY,labels,indexes);
    a.DataTipTemplate.DataTipRows(end+1) = dataTipTextRow("Cluster Size:", height(clusterTable));
    a.DataTipTemplate.DataTipRows(end+1) = dataTipTextRow("Data Set Size",number_of_data_points);

    %% write each data point's (x,y) and label to a table
    if strcmpi(xAxis,"max") && strcmpi(yAxis,"shift") && ~strcmpi(folder_where_cluster_tables_should_be_saved,"")
        writetable(clusterTable,strcat(folder_where_cluster_tables_should_be_saved,"\",experiment," ",string(letter),"_",string(i),".xlsx"))
    end

end



%% label the current figure
hold on;
xlabel(xAxis);
ylabel(yAxis);
subtitle(strcat("Created By create\_a\_plot.m, called by ", called_by))
xlim([-20,20]);
ylim([-20,20])

%% save the figure
home_dir = cd(folder_where_figures_should_be_saved);
% saveas(fig_handle,strcat(folder_where_figures_should_be_saved,"\",experiment," ", feature, " ", xAxis, " vs. ", yAxis, " MPC ",string(best_mpc),".fig"), "fig")
cd(home_dir);
% close(fig_handle)
end