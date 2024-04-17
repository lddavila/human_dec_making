function [] =get_average_xyz_per_human_experiment(story_types, home_dir_name, C)
figure
hs = [];
for s=1:length(story_types)
    story_type = story_types(s);
    disp(story_type)
    dirName = home_dir_name + story_type + "\Sigmoid Data"; % get the directory where human sigmoid data for the current story is located in
    current_table = stoppingPointsSigmoidClustering(1, dirName); %get the sigmoid data and put it into a table
    % current_table = [current_table,table(repelem(story_type,height(current_table),1),'VariableNames',{'experiment'})];
    current_table.E = string(current_table.E);
    data_to_examine = log(abs([current_table.A,current_table.B,current_table.C]));
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

    
    hs = [hs; h];
end
legend(hs,story_types)
end