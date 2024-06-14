%% add the Utility functions to my path
cd("Utility Functions\")
addpath(pwd)
cd("..")
data_dir = "C:\Users\ldd77\OneDrive\Desktop\human_dec_making\session_clustering";
do_the_copying = 0;
do_the_fcm = 0;
do_the_chi_squared_graph =0;
do_the_average_xyz = 1;
%% copy only the data which meets the threshold
for i=0:10:100
    threshold = i;
    % if threshold ~= 40
    %     continue;
    % end
    version_name = strcat(" session_clustering_",string(threshold),"_threshold");
    if do_the_copying
        % copy the data which meets the current threshold to new folder
        story_types = ["approach_avoid", "social", "probability", "moral"];
        make_thresh_psych_folder(clean_approach_data, subject_prefs,threshold,data_dir,story_types,version_name);
    end
    %get directory with newly thresholded data
    name_of_dir_with_newly_thresholded_data = strcat("psych_dir_thresh_",string(threshold),"_",version_name);
    %get all sub directories with
    table_of_human_dir = get_dirs_with_data(name_of_dir_with_newly_thresholded_data);
    if do_the_fcm
        %specify centers to be used for fcm clustering
        centers = [-7.98729 -0.202509 -13.3994;
            3.89845 10.485 2.3794;
            4.15937 2.56953 0.296347;
            3.30371 -16.7736 1.38552;
            14.3091 10.7168 -1.7927];
        %run fcm
        call_FCM_for_all_human_data(table_of_human_dir,centers, strcat("Cluster Table For ",version_name,"figures created on ",string(datetime("today",'Format','MM-d-yyyy'))))
    end
    %get the human data table
    human_data_table = return_given_cluster_table("all human data.xlsx",strcat("Cluster Table For ",version_name,"figures created on 06-2-2024"));
    human_stats_map = get_human_data_table_stats(human_data_table);

    if do_the_average_xyz
        C = ['r','g','b','c'];
        get_average_xyz_per_human_experiment_using_spectral_table(human_data_table,C,"average xyz plot all data for session clustering",human_stats_map,version_name)
    end
    if do_the_chi_squared_graph
        create_heat_maps_for_chi_squared_significance(human_data_table,"chi squared heat maps incremented by 10 for session clustering",0,0.052,human_stats_map,version_name)
    end
end


%% 
% concatenate_many_plots_updated("3d cluster plots for session data","3d cluster plots for session data.pdf","ALL PDFS");
% concatenate_many_plots_updated("chi squared heat maps incremented by 10 for session clustering","chi squared heat maps incremented by 10 for session clustering.pdf","ALL PDFS")
concatenate_many_plots_updated("average xyz plot all data for session clustering","average xyz plots incremented by 10 for session clustering.pdf","ALL PDFS");