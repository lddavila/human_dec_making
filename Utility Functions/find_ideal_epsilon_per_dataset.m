function estimated_epsilons = find_ideal_epsilon_per_dataset(table_of_dir)
estimated_epsilons = cell(1,height(table_of_dir));
for i=1:height(table_of_dir)
    table_of_data_for_current_task = getTable(table_of_dir{i,2});
    xVsYVsZ = log(abs([table_of_data_for_current_task.A,table_of_data_for_current_task.B,table_of_data_for_current_task.C]));
    estimated_epsilons{i} = clusterDBSCAN.estimateEpsilon(xVsYVsZ,6,15);
    
end

end