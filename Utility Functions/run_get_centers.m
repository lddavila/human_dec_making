function[centers] =  run_get_centers(table_of_file_paths_with_sigmoid_data)
for i=1:height(table_of_file_paths_with_sigmoid_data)
    current_file_path = table_of_file_paths_with_sigmoid_data{i,2};
    current_experiment = table_of_file_paths_with_sigmoid_data{i,1};
    current_table_of_data = getTable(current_file_path);

    max_vs_shift = [log(abs(current_table_of_data.A)),log(abs(current_table_of_data.B))];

    max_vs_steepness = [log(abs(current_table_of_data.A)),log(abs(current_table_of_data.C))];
    shift_vs_steepness = [log(abs(current_table_of_data.B)),log(abs(current_table_of_data.C))];

    x_titles = ["Max","Max","shift"];
    y_titles = ["Shift","Steepness","Steepness"];

    all_info = {max_vs_shift,max_vs_steepness,shift_vs_steepness};

    labels = [current_table_of_data.D,current_table_of_data.D];
    centers = cell(1,3);
    for j=1:3
        figure;
        hold on;
        x_Vs_y = all_info{j};
        x_label = x_titles(j);
        y_label = y_titles(j);
        

        centers{j} = get_centers(x_Vs_y,labels,x_label,y_label,"reward_choice",current_experiment,"run_get_centers.m");


    end
end
end