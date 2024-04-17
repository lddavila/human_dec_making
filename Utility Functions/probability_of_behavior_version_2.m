function probability_of_behavior_version_2(home_dir_name)

max_v_shift_start_means = create_start_means([7.26274 9.11074; 0.0561693 9.37614; -0.0850574 2.51279; -8.95759 -0.338087]); %create start means for max v shift
max_v_shift_alt_means =  create_start_means([7.26274 9.11074; 0.0561693 9.37614; -0.0850574 2.51279]);           %create alternate means for max v shift
                                            %the input matrix is average (x,y) data point of each cluster
                                            %the cluster which might disappear should be the last row 

max_v_slope_start_means = create_start_means([7.24134 2.86843;-0.0697846 4.56702; -9.33581 -6.61376]);    %create start meas for max v slope
max_v_slope_alt_means = create_start_means([7.24134 2.86843;-0.0697846 4.56702; -9.33581 -6.61376]);             %create start means for max v slope

shift_v_slope_start_means = create_start_means([9.22541 3.31441; 2.53516 4.23907; -0.308906 -5.65529]);  %create start means for shift v slope
shift_v_slope_alt_means = create_start_means([9.22541 3.31441; 2.53516 4.23907; -0.308906 -5.65529]);               %create alternate start means for shift v slope

%what the heck are start means?
%what is the significance of the initial values?

%it seems that create_start_means returns a struct with fields 'mu' and 'sigma'
%mu is just the array specified above
%sigma is a 3d double array where the array located at (:,:,1:3) = [1 1; 1 2];
%in the case that the given array has a length of  4 then (:,:,4) = [0. 0.5; 0.5 1], which doesn't happen in the case of alternates
%suspect the above is for fitting
%ASK LARA TO CONFIRM above

story_types = ["Baseline"];
xlabels = ["max","max","shift"];
ylabels = ["shift","slope","slope"];

for s = 1:length(story_types)
    story_type = story_types(s);
    new_name = home_dir_name + story_type; 
    dirName = pwd + new_name + "\" ; %edited to run on my local machine
    
    humanTable = getTable("C:\Users\ldd77\OneDrive\Desktop\Lara Analysis\reward_choice Sigmoid Data"); %missing this function, ASK LARA FOR IT, but I assume it's a simple fetch of human data or something similar

    sigmoidMax = log(abs(humanTable.A));        %normalize the sigmoid max
    horizShift = log(abs(humanTable.B));        %normalize the sigmoid shift
    sigmoidSteepness = log(abs(humanTable.C));  %normalize the sigmoid steepness

    for l = 1:3 %cycle through all combinations of max,shift,and slope
        x_label = xlabels(l);
        y_label = ylabels(l);
                
        if (isequal(x_label, 'max') && isequal(y_label, 'shift'))   %case for max vs shift
            data = [sigmoidMax, horizShift];                        %put the data into single n_rowx2_col array named data
            start_means = max_v_shift_start_means;                  %set the start_means for max_v_shift which were designated above
            alt_means = max_v_shift_alt_means;                      %set the alt means for max_v_shift which were designated above

            [idx,~] = createThePlotWithGM(data,4,story_type,start_means,alt_means); 
            %idx is an nx1 array where each row of idx tells you which cluster each row of data belongs to

            max_v_shift_max = max(idx);     %get the max value from idx (AKA the largest cluster)
            humanTable.max_v_shift = idx;   %adds a column named "max_v_shift" and sets it equal to the idx variable
                                            %alternatively replaces an existing max_v_shift column with idx
                                            %column "max_v_shift" may already be populated or not, either way it is being replaced 

        elseif isequal(x_label, 'max') && isequal(y_label, 'slope') %case for max vs slope
            data = [sigmoidMax,sigmoidSteepness];
            start_means = max_v_slope_start_means;
            alt_means = max_v_slope_alt_means;

            [idx,~] = createThePlotWithGM(data,3,story_type,start_means,alt_means);

            max_v_slope_max = max(idx);
            humanTable.max_v_slope = idx;

        elseif isequal(x_label, 'shift') && isequal(y_label, 'slope') %case for shift vs slope 
            data = [horizShift,sigmoidSteepness];
            start_means = shift_v_slope_start_means;
            alt_means = shift_v_slope_alt_means;
            
            [idx,~] = createThePlotWithGM(data,3,story_type,start_means,alt_means);

            shift_v_slope_max = max(idx);
            humanTable.shift_v_slope = idx;
        end
       
    end

    % plotting all possible combinations
    for a1 = 1:4 %cycle through clusters 1 to 4 or alternatively 1 to 3 
        for a2 = 1:4 %cycle through clusters 1 to 4 or alteratively 1 to 3
            for a3 = 1:4 %cycle through clusters 1 to 4 or alternatively 1 to 4
                scatter3(a1,a2,a3,10,'b') %create 3d scatter of the clusters that are being cycled through
                                          %ASK LARA what the point of this is cause it seems like you're just plotting 1-4
                                          %maybe it's just to plot dots along the line
                                          %i vaguely recall this from her figers
                hold on
            end
        end
    end
    hold on

    % plotting the actual combinations
    %below seems to plot the actual data stored in human table
    triplets = humanTable(:, 5:7);  %human table columns 6:8 are as follows
                                    %6- max vs shift indexes
                                    %7 - max vs slope indexes
                                    %8 - shift vs slope indexes

    pattern_table = groupcounts(triplets,["max_v_shift","max_v_slope","shift_v_slope"]);
    %pattern table is a table which contains the number of elements in each group, and percentages represented by each group count
    %a group is defined as any row in triplets which have the same combination
    %for example 1 1 1 if all data points are in cluster 1 for all 3 columns of triplets then it will be a unique group
    %i suppose there are 27-256 possible combinations

    pattern_table.pattern = string(pattern_table.max_v_shift) + ", " + string(pattern_table.max_v_slope) + ", " + string(pattern_table.shift_v_slope);
    %adds column "pattern" to pattern_table, where each row is a string representing the unique combination of the groups

    max_v_shift_cluster = pattern_table.max_v_shift; %get the max vs shift cluster id
    max_v_slope_cluster = pattern_table.max_v_slope; %get the max v slope cluster ids
    shift_v_slope_cluster = pattern_table.shift_v_slope; %get the shift v slope cluster ids
    count = pattern_table.Percent; %get the percentage of each group's appearence 
                                   %ask lara if it was supposed to be the groupcount column and not percentage?
    
    scatter3(max_v_shift_cluster, max_v_slope_cluster, shift_v_slope_cluster, count*10, 'r', 'filled'); %ASK LARA why is count being multiplied by 10 here? 
    title(story_type + " probability of cluster patterns ")

    %{
    histogram('Categories',pattern_table.pattern,'BinCounts',pattern_table.Percent)
    ylabel("percent")
    xlabel("cluster patterns")
    title("% of pts in given cluster pattern for " + story_type)
    %}

    xlabel('Max V Shift Cluster')
    ylabel('Max V Slope Cluster')
    zlabel('Shift V Slope Cluster')
    figname = strcat(dirName,"/",story_type,"_prob_of_pattern.fig");
    fighandle = gcf;
    set(gcf,'renderer','Painters') 
    % saveas(fighandle,figname)
    % close all
end
end