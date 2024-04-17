function [totals,humanTables] = setup_for_avgs(data,story_types,want_totals,not_spectral)

n = length(story_types);
home_dir_name = "final_run/sessions/";
totals = cell(1,n);
humanTables = cell(1,n);
for i = 1:n
    story_type = story_types(i);
    
    if not_spectral
        new_name = home_dir_name + story_type;
        dirName = "C:\Users\lrako\OneDrive\Documents\RECORD\Stopping Points\human_dec_making\" + new_name + "\" ;
        
        human_dir = dirName + 'Sigmoid Data';
        humanTable = stoppingPointsSigmoidClustering(1, human_dir);
        humanTables{i} = humanTable; 
    end
    
    if want_totals
        story_data = data{i};
        story_total = [];
        for j = 1:length(story_data)
            sesh = story_data{j};
            story_total = [story_total; sesh];
        end
        totals{i} = story_total;
    end
end
