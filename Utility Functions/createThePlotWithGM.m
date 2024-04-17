function [idx1,p1] = createThePlotWithGM(xVsY1,num_clusters,task_1,start_means,alt_means)

color = lines(2*num_clusters); % creates a rgb array for random colors

try
    gm1 = fitgmdist(xVsY1, num_clusters, 'Start',start_means); %create gaussian mixture model with start means
catch
    gm1 = fitgmdist(xVsY1, num_clusters-1, 'Start',alt_means); %create gaussian mizture model with alternate start means
end

idx1 = cluster(gm1, xVsY1); %ASK LARA for cluster function
                            %based on the line 18 I assume that idx1 is the groupings of each data point
p1 = get_probs(idx1);   %p1 is 
%                       %either a 3x1 array or a 4x1 where the array at position 1 will have the probability of cluster 1 appearinng
                        %position n will be the probability of cluster n appearing

figure
gscatter(xVsY1(:,1),xVsY1(:,2),idx1,color(1:4,:)); %plot things by group
title(task_1)
close

end

function ps = get_probs(idx)
%again working under the assumption that idx is an nx1 array where each row indicates which group the xVsY data belongs to 

tot = length(idx); %get the length of index (AKA the total number of data points)
unique_ids = sort(unique(idx)); %get only the unique indexes of idx and sort them 

ps = [];                        %the probabilities which will be returned
for i = 1:length(unique_ids)    %cycle through the unique ids
    n = unique_ids(i);          %get current unique_id
    num = sum(idx == n);        %count how many times this id appears in the idx array
    ps = [ps; num/tot];         %calculate the probabilities of ids 1:4 apearing in idx
end
end