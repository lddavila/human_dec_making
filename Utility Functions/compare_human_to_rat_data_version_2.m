function compare_human_to_rat_data_version_2(table_of_human_data,table_of_rat_data,rat_struct_object)
clc;
for i=1:height(table_of_rat_data)
    rat_data = getTable(table_of_rat_data{i,2});
    rat_max_shift_steepness = log(abs([rat_data.A,rat_data.B,rat_data.C]));

    for j=1:height(table_of_human_data)
        human_data = getTable(table_of_human_data{j,2});
        human_max_shift_steepness = log(abs([human_data.A,human_data.B,human_data.C]));

        % all_data_together = [rat_max_shift_steepness;human_max_shift_steepness];
        % figure;
        % scatter3(human_max_shift_steepness(:,1),human_max_shift_steepness(:,2),human_max_shift_steepness(:,3),'.');
        % options = statset('Display','final');
        % gm_for_humans = fitgmdist(human_max_shift_steepness,4);
        % idx_for_humans = cluster(gm_for_humans,human_max_shift_steepness);
        
        % figure;
        % scatter3(rat_max_shift_steepness(:,1),rat_max_shift_steepness(:,2),rat_max_shift_steepness(:,3),'x');
        % options = statset('Display','final');


        gm_for_rats=fitgmdist(rat_max_shift_steepness,4,'Start',rat_struct_object);
        
        idx_for_rats = cluster(gm_for_rats,rat_max_shift_steepness);
        close all;

        figure;
        for k=1:4
            scatter3(rat_max_shift_steepness(idx_for_rats==k,1),rat_max_shift_steepness(idx_for_rats==k,2),rat_max_shift_steepness(idx_for_rats==k,3),"x")
            hold on;
        end
        % for k=1:4
        %     scatter3(human_max_shift_steepness(idx_for_humans==k,1),human_max_shift_steepness(idx_for_humans==k,2),human_max_shift_steepness(idx_for_humans==k,3),"o")
        %     hold on;
        % end
        % 
        % 
        % legend("x = rat", "o=human")


        % display(gm_for_rats)
        % gm_human_PDF = @(x,y,z) arrayfun(@(x0,y0,z0) pdf(gm_for_humans,[x0,y0,z0]),x,y,z);

        % gm_rat_PDF = @(x,y,z) arrayfun(@(x0,y0,z0) pdf(gm_for_rats,[x0 y0 z0]),x,y,z);
        % 
        % hold on;
        % contour3(rat_max_shift_steepness)
        % h = contour3(gm_rat_PDF,[-20 20]);

        % Z = bhattacharyyaDistance(human_max_shift_steepness,rat_max_shift_steepness);
        

        
    end
end
end