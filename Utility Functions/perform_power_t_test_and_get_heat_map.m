function [] = perform_power_t_test_and_get_heat_map(human_data_table,dir_to_save_figs_to)

    function [array_of_means,array_of_std_dvns,array_of_sizes,unique_experiments] = get_mean_and_std_dvns(human_data_table)

        unique_experiments = unique(human_data_table.experiment);
        unique_experiments = string(unique_experiments);

        array_of_means = [];
        array_of_std_dvns = [];
        array_of_sizes = [];

        for i=1:length(unique_experiments)
            curr_exp = unique_experiments(i);
            current_rows = human_data_table(strcmpi(human_data_table.experiment,curr_exp),:);
            data = [current_rows.clusterX,current_rows.clusterY,current_rows.clusterZ];
            array_of_means = [array_of_means;mean(data)];
            array_of_std_dvns = [array_of_std_dvns;((std(data))/sqrt(size(data,1)))]
            array_of_sizes = [array_of_sizes;size(data,1);];
        end
    end

    function [array_of_power_analysis_X,array_of_power_analysis_Y,array_of_power_analysis_Z] = perform_power_analysis_t_test_permutations(array_of_means,array_of_std_dvns,array_of_sizes,unique_experiments)
        array_dimensions = (length(unique_experiments)*(length(unique_experiments)-1))/2;
        array_of_power_analysis_X = zeros(array_dimensions,array_dimensions);
        array_of_power_analysis_Y = zeros(array_dimensions,array_dimensions);
        array_of_power_analysis_Z = zeros(array_dimensions,array_dimensions);
        for exp_1_counter=1:length(unique_experiments)
            exp_1 = unique_experiments(exp_1_counter);
            exp_1_means = array_of_means(exp_1_counter,:);
            exp_1_std_dvn = array_of_std_dvns(exp_1_counter,:);
            exp_1_size = array_of_sizes(exp_1_counter);
            for exp_2_counter=exp_1_counter+1:length(unique_experiments)
                exp_2 = unique_experiments(exp_2_counter);
                exp_2_means = array_of_means(exp_2_counter,:);
                exp_2_std_dvn = array_of_std_dvns(exp_2_counter,:);
                exp_2_size = array_of_sizes(exp_2_counter);
                for dimension=1:size(array_of_means,2)
                    pwr = sampsizepwr('t2',[exp_1_means(dimension) exp_1_std_dvn(dimension)],exp_2_means(dimension),[],exp_2_size);
                    disp(pwr)
                    if dimension==1
                        array_of_power_analysis_X(exp_1_counter,exp_2_counter) = pwr;
                    elseif dimension==2
                        array_of_power_analysis_Y(exp_1_counter,exp_2_counter) = pwr;
                    elseif dimension==3
                        array_of_power_analysis_Z(exp_1_counter,exp_2_counter) = pwr;
                    end
                end

            end
        end
    end

    [array_of_means,array_of_std_dvns,array_of_sizes,unique_experiments] = get_mean_and_std_dvns(human_data_table);

     [array_of_power_analysis_X,array_of_power_analysis_Y,array_of_power_analysis_Z] = perform_power_analysis_t_test_permutations(array_of_means,array_of_std_dvns,array_of_sizes,unique_experiments);

     figure;
     labels = { 'AA -> M','AA->P','AA->S','M->P','M->S','P->S'}
    heatmap(labels,labels,array_of_power_analysis_X)
    title("Power Log(abs(max))")

    figure;
    heatmap(labels,labels,array_of_power_analysis_Y)
    title("Power Log(abs(shift))")

    figure;
    heatmap(labels,labels,array_of_power_analysis_Z)
    title("Power Log(abs(slope))")
end