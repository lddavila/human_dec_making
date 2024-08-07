%% add the Utility functions to my path
cd("Utility Functions\")
addpath(pwd)
cd("..")
data_dir = "C:\Users\ldd77\OneDrive\Desktop\human_dec_making\session_cost_clustering";
do_the_copying = 0;
do_the_fcm = 0;
do_the_chi_squared_graph =1;
do_the_average_xyz = 0;
%% copy only the data which meets the threshold
for i=0:10:100
    threshold = i;
    % if threshold ~= 40
    %     continue;
    % end
    version_name = strcat(" session_cost_clustering_",string(threshold),"_threshold");
    if do_the_copying
        % copy the data which meets the current threshold to new folder
        story_types = ["approach_avoid", "social", "probability", "moral"];
        make_thresh_psych_folder(clean_approach_data, subject_prefs,threshold,data_dir,story_types,version_name);
    end
    %get directory with newly thresholded data
    name_of_dir_with_newly_thresholded_data = strcat("psych_dir_thresh_",string(threshold));
    %get all sub directories with
    table_of_human_dir = get_dirs_with_data(name_of_dir_with_newly_thresholded_data);
    if do_the_fcm
        %specify centers to be used for fcm clustering
        centers = [-8.4228 -2.9848e-06 -13.7845;
            -6.252 1.14615 0.136439;
            4.50766 5.22001 0.740335;
            3.57903, -16.7105, 1.37222;
            13.1213 9.77206 -1.31392];
        %run fcm
        call_FCM_for_all_human_data(table_of_human_dir,centers, strcat("Cluster Table For ",version_name,"figures created on ",string(datetime("today",'Format','MM-d-yyyy'))))
    end
    %get the human data table
    human_data_table = return_given_cluster_table("all human data.xlsx",strcat("Cluster Table For ",version_name,"figures created on 05-21-2024"));
    human_stats_map = get_human_data_table_stats(human_data_table);

    if do_the_average_xyz
        C = ['r','g','b','c'];
        get_average_xyz_per_human_experiment_using_spectral_table(human_data_table,C,"average xyz plot all data",human_stats_map,version_name)
    end
    if do_the_chi_squared_graph
        create_heat_maps_for_chi_squared_significance(human_data_table,"chi squared heat maps incremented by 10",0,0.052,human_stats_map,version_name)
    end
end


%% 
concatenate_many_plots_updated("chi squared heat maps incremented by 10","chi squared heat maps incremented by 10.pdf","ALL PDFS");
concatenate_many_plots_updated("average xyz plots incremented by 10","average xyz plots incremented by 10.pdf","ALL PDFS");
