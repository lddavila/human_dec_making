function [] = create_random_sampling_3d_average_plots(proportions_to_match,experiments,human_data_table,C)
hs = [];
figure;
for i=1:length(experiments)
    curr_exp = experiments(i);
    proportion_to_match_to = proportions_to_match(i,:);

    all_means_from_random_sampling = [];
    all_std_from_random_sampling = [];
    all_std_error_from_random_sampling = [];
    for j=1:1000
        random_sample_table = match_proportions_and_return_updated_table_2(human_data_table,proportion_to_match_to);
        data_to_examine = [random_sample_table.clusterX,random_sample_table.clusterY,random_sample_table.clusterZ];
        xyz_mean = mean(data_to_examine);
        xyz_std = std(data_to_examine);
        xyz_std_error = xyz_std / sqrt(size(data_to_examine,1));
        % disp("Mean")
        % disp(xyz_mean);
        % disp("std")
        % disp(xyz_std)
        % disp("std error")
        % disp(xyz_std_error)

        all_means_from_random_sampling = [all_means_from_random_sampling;xyz_mean];
        all_std_from_random_sampling = [all_std_error_from_random_sampling;xyz_std];
        all_std_error_from_random_sampling = [all_std_error_from_random_sampling;xyz_std_error];

    end
    x = mean(all_means_from_random_sampling(:,1));
    y = mean(all_means_from_random_sampling(:,2));
    z = mean(all_means_from_random_sampling(:,3));

    mean_std_error_x = mean(all_std_error_from_random_sampling(:,1));
    mean_std_error_y = mean(all_std_error_from_random_sampling(:,2));
    mean_std_error_z = mean(all_std_error_from_random_sampling(:,3));


    

    h = scatter3(x,y,z,'o',C(i));
    hold on;
    plot3([x,x]',[y,y]',[-mean_std_error_z,mean_std_error_z]'+z',C(i))
    plot3([x,x]',[-mean_std_error_y,mean_std_error_y]'+y',[z,z]',C(i))
    plot3([-mean_std_error_x,mean_std_error_x]'+x',[y,y]',[z,z]',C(i))

    hs = [hs;h];

end
xlim([1.5,3])
ylim([3,6.4])
zlim([-1.8,-0.4])
title("Recreated from 1000 random samplings")
legend(hs,experiments)
end