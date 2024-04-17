function [] =get_average_xyz_per_human_experiment_using_spectral_table(human_data_table, C,dir_to_save_figs_to,human_stats_map)
dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);

hs = [];
story_types = unique(human_data_table.experiment);
figure('units','normalized','outerposition',[0 0 1 1])
title_strings = [];
for s=1:length(story_types)
    story_type = story_types(s);
    disp(story_type)
    
    current_table = human_data_table(strcmpi(human_data_table.experiment,story_type),:); %get the sigmoid data and put it into a table
    % current_table = [current_table,table(repelem(story_type,height(current_table),1),'VariableNames',{'experiment'})];
    % current_table.E = string(current_table.E);
    data_to_examine = [current_table.clusterX,current_table.clusterY,current_table.clusterZ];
    disp("Mean")
    xyz_mean = mean(data_to_examine);
    disp(xyz_mean);
    xyz_std = std(data_to_examine);
    disp("std")
    disp(xyz_std)
    xyz_std_error = xyz_std / sqrt(size(data_to_examine,1));
    disp("std error")
    disp(xyz_std_error)
    h = scatter3(xyz_mean(1),xyz_mean(2),xyz_mean(3),'o', C(s));
    hold on;
    plot3([xyz_mean(1),xyz_mean(1)]',[xyz_mean(2),xyz_mean(2)]',[-(xyz_std_error(3)),xyz_std_error(3)]'+xyz_mean(3)',C(s));
    plot3([-xyz_std_error(1),xyz_std_error(1)]'+xyz_mean(1)',[xyz_mean(2),xyz_mean(2)]',[xyz_mean(3),xyz_mean(3)]',C(s));
    plot3([xyz_mean(1),xyz_mean(1)]',[-xyz_std_error(2),xyz_std_error(2)]'+xyz_mean(2),[xyz_mean(3),xyz_mean(3)]',C(s));

    title_strings = [title_strings, strcat(strrep(story_type,"_","\_"), " Number of Data Points",string(height(current_table)), " Number Of Subjects:", string(human_stats_map(strcat(string(story_type)," Number Of Unique Subjects"))))];

    
    hs = [hs; h];
end
legend(hs,story_types)
title([title_strings, ...
    strcat("Date Created:",string(datetime("today",'Format','MM-d-yyyy'))), ...
    "Created By get\_average\_xyz\_per\_human\_experiment\_using\_spectral\_table.m"]);
saveas(gcf,strcat(dir_to_save_figs_to,"\All Human Data Average XYZ.fig"),"fig")
end