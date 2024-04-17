function story_features = story_comparison_by_subj_3d_3(story_types, home_dir_name, C, sigmoid_type, save,human_data_table_array)

%use this loop to format all the tables
for i=1:length(human_data_table_array)
    human_data_table = human_data_table_array{i};
    human_data_table.clusterLabels = string(human_data_table.clusterLabels);
    human_data_table.experiment = string(human_data_table.experiment);
    human_data_table = renamevars(human_data_table,"clusterLabels","E");
    human_data_table_array{i} = human_data_table;
end

% use this loop to get the story data as tables into a single array
story_data_array = cell(1,length(story_types));
for s=1:length(story_types)
    story_type = story_types(s);
    dirName = home_dir_name + story_type + "\Sigmoid Data"; % get the directory where human sigmoid data for the current story is located in
    current_table = stoppingPointsSigmoidClustering(1, dirName); %get the sigmoid data and put it into a table
    current_table = [current_table,table(repelem(story_type,height(current_table),1),'VariableNames',{'experiment'})];
    current_table.E = string(current_table.E);
    story_data_array{s} = current_table;
end

%use this loop to create the tables as above, but exclude the story_type
story_data_exclusion_array = cell(1,length(story_types));
for s=1:length(story_types)
    story_to_exclude = story_types(s);
    current_exclusion_table =[];
    for p=1:length(story_types)
        current_story = story_types(p);
        if strcmpi(story_to_exclude,current_story)
            continue;
        end
        current_exclusion_table = [current_exclusion_table;story_data_array{p}];
    end
    story_data_exclusion_array{s} = current_exclusion_table;
end

clc;
hs = [];

slope = cell(1,4);
max = cell(1,4);
shift = cell(1,4);

max_bars = [];
max_errbars = [];
slope_bars = [];
slope_errbars = [];
shift_bars = [];
shift_errbars = [];

total_subjects = [];


figure
for s = 1:length(story_types)
    story_type = story_types(s);

    humanTable = story_data_exclusion_array{s};
    humanTable.E = string(humanTable.E); % get the labels as strings

    ids = rowfun(@get_id,humanTable,"InputVariables","E","OutputVariableNames","id"); %extract the columns of just the ids
    newTable = [humanTable ids]; %add a new column to human table where its just the ids

    human_table = human_data_table_array{s};

    newTable = join(human_table,newTable,'Keys',["experiment","E"]);


    mean_maxes = [];
    mean_slopes = [];
    mean_shifts = [];
    unique_ids= unique(newTable.id);
    total_subjects = [total_subjects ; unique_ids];

    for i = 1:length(unique_ids) %cycle through each subject in the newTable
        id = unique_ids(i); %look only at the current subject
        idTable = newTable(newTable.id == id, :); %get a table of only the current subject's data

        sigmoidMax = log(abs(idTable.A)); %log(abs(max))
        horizShift = log(abs(idTable.B)); %log(abs(shift))
        sigmoidSteepness = log(abs(idTable.C)); %log(abs(slope))


        curr_mean_max =  mean(sigmoidMax, 'omitnan'); %find the mean max
        curr_mean_shift = mean(horizShift, 'omitnan'); %find the mean shift
        curr_mean_slope = mean(sigmoidSteepness, 'omitnan'); %find the mean slope

        mean_maxes = [mean_maxes; curr_mean_max]; %store the mean max of the current subject
        mean_shifts = [mean_shifts; curr_mean_shift];  %store the mean shift of the curernt subject
        mean_slopes = [mean_slopes; curr_mean_slope]; %store the mean slope of the current subject

    end

    max{s} = mean_maxes'; %store array of the mean maxes
    shift{s} = mean_shifts'; % store array of mean shifts
    slope{s} = mean_slopes'; % store array of mean slopes

    mean_max = mean(mean_maxes,'omitnan'); %take the mean of the means of max by subject
    mean_shift = mean(mean_shifts, 'omitnan'); %take the means of the means of shift by subject
    mean_slope = mean(mean_slopes, 'omitnan'); %take the means of the means of slope by subject

    max_std_error = std(mean_maxes, 'omitnan')/length(mean_maxes); %calculate the std deviation then divided by the # of items in mean_maxes
    shift_std_error = std(mean_shifts, 'omitnan')/length(mean_shifts); %calculate the std deviation of mean_shifts and divide it by the # of items in mean_shifts
    slope_std_error =  std(mean_slopes, 'omitnan')/length(mean_slopes); %calculate the std deviation of mean_slopes and divide it by the #of items in mean slopes

    h = scatter3(mean_max, mean_shift, mean_slope, 1, C(s), 'filled'); %plot the mean max,shift,and slope for the current story on a 3d scatter
    hold on
    plot3([mean_max,mean_max]', [mean_shift,mean_shift]', [-slope_std_error,slope_std_error]'+mean_slope', C(s))  %plot the slope std error bar
    hold on
    plot3([mean_max,mean_max]', [-shift_std_error,shift_std_error]'+mean_shift', [mean_slope,mean_slope]', C(s))  %plot the shift std error bar
    hold on
    plot3([-max_std_error,max_std_error]'+mean_max, [mean_shift,mean_shift]', [mean_slope,mean_slope]', C(s))  %plot the max standard erorr bar
    hold on
    legend(story_type)
    hold on
    hs = [hs; h];

    max_bars = [max_bars; mean_max];
    max_errbars = [max_errbars; max_std_error];

    shift_bars = [shift_bars; mean_shift];
    shift_errbars = [shift_errbars; shift_std_error];

    slope_bars = [slope_bars; mean_slope];
    slope_errbars = [slope_errbars; slope_std_error];
end

legend(hs, story_types)
xlabel('Max')
ylabel('Shift')
zlabel('Slope')
titstr = "Number of " + sigmoid_type + " : " + string(length(unique(total_subjects)));
xlim([1.6 2.3])
ylim([2.7 3.6])
zlim([-2.2 -.8])
fighandle = gcf;
set(gcf,'renderer','Painters')
title(titstr)
figname = home_dir_name + "3d_comparison_by_subj.fig";
if save
    saveas(fighandle, figname);
end
%
% create_bar_plot(max_bars, max_errbars, hs, 'sigmoid max', story_types, titstr, home_dir_name, save)
% create_bar_plot(slope_bars, slope_errbars, hs, 'sigmoid slope', story_types, titstr, home_dir_name, save)
% create_bar_plot(shift_bars, shift_errbars, hs, 'sigmoid shift', story_types, titstr, home_dir_name, save)
%
% create_scatter_plots(max, hs, 'sigmoid max', story_types, titstr, home_dir_name, save)
% create_scatter_plots(shift,hs, 'sigmoid shift', story_types, titstr, home_dir_name, save)
% create_scatter_plots(slope, hs, 'sigmoid slope', story_types, titstr, home_dir_name, save)

end


function create_bar_plot(bars, errbars, handles, y_label, story_types, titstr, dirName, save)
figure
barhandle = bar([1,2,3,4],bars);
hold on
errorbar([1,2,3,4], bars, errbars, errbars)
xticklabels(story_types)
ylabel(y_label);
legend(handles, story_types)
title(titstr)
fighandle = gcf;
figname = dirName+y_label+"_feat_across_tasks_by_subj.fig";
set(gcf,'renderer','Painters')
if save
    saveas(fighandle, figname)
end

end

function create_scatter_plots(ys, handles, y_label, story_types, titstr, dirName, save)
figure
y1 = ys{1};
y2 = ys{2};
y3 = ys{3};
y4 = ys{4};
scatter(ones(1,length(y1)),y1)
hold on
scatter(ones(1,length(y2))*2, y2)
hold on
scatter(ones(1,length(y3))*3, y3)
hold on
scatter(ones(1,length(y4))*4, y4)
xticks([1 2 3 4])
xticklabels(story_types)
ylabel(y_label);
legend(handles, story_types)
title(titstr)
fighandle = gcf;
figname = dirName+y_label+"_feat_across_tasks_scatter_by_subj.fig";
set(gcf,'renderer','Painters')
if save
    saveas(fighandle, figname)
end

end

function id = get_id(E)

list = strsplit(E,"_");
id = list(1);

end