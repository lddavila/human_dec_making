function [] = automize_psychometric_functions_only_reward_choice(subject_ids,dates,experiment,dir_to_save_things_to)

    function [theFormattedDate] = formatTheDate(theDate)
        theYear = string(theDate(3));
        theDay = string(theDate(2));
        theMonth = string(theDate(1));

        switch theMonth
            case '01'
                theMonth = "Jan";
            case '02'
                theMonth = "Feb";
            case '03'
                theMonth = "Mar";
            case '04'
                theMonth = "Apr";
            case '05'
                theMonth = "May";
            case '06'
                theMonth = "Jun";
            case '07'
                theMonth = "Jul";
            case '08'
                theMonth = "Aug";
            case '09'
                theMonth = "Sep";
            case '10'
                theMonth = "Oct";
            case '11'
                theMonth = "Nov";
            case '12'
                theMonth = "Dec";
        end
        theFormattedDate = strcat(theDay,"-",theMonth,"-",theYear);
    end
    function [xcoordinates,ycoordinates] = createRewardChoicePsychometricFunction(searchResults)
        local = searchResults;
        local2 = [str2double(local.approachavoid),str2double(local.feeder)];
        if sum(isnan(local2)) > 0
            display(local)
            display(isnan(table2array(local)))
            disp("NAN DETECTED")
            return
        end
        numberOfTotalRows = height(local);
        i = 1;
        %keeps track of how many times the rat approaches the
        %designated feeders
        feeder1Approaches = 0.00;
        feeder2Approaches = 0.00;
        feeder3Approaches = 0.00;
        feeder4Approaches = 0.00;

        %keeps track of how many times each feeder appears in tests
        feeder1Appearences = 0;
        feeder2Appearences = 0;
        feeder3Appearences = 0;
        feeder4Appearences = 0;

        while i <= numberOfTotalRows
            feederValue = string(local{i,3});
            %if the feeder value appears and it approaches then the
            %feeder1/2/3/4 approaches variable is incremented
            if str2double(string(local{i,4})) == 1
                switch feederValue
                    case '1'
                        feeder1Approaches = feeder1Approaches+1;
                    case '2'
                        feeder2Approaches = feeder2Approaches+1;
                    case '3'
                        feeder3Approaches = feeder3Approaches+1;
                    case '4'
                        feeder4Approaches = feeder4Approaches+1;
                end

            end

            %if the feederValue appears the feeder1/2/3/4 Appearences
            %variables are incremented
            switch feederValue
                case '1'
                    feeder1Appearences = feeder1Appearences + 1;
                case '2'
                    feeder2Appearences = feeder2Appearences + 1;
                case '3'
                    feeder3Appearences = feeder3Appearences + 1;
                case '4'
                    feeder4Appearences = feeder4Appearences + 1;
            end
            i = i+1;
        end

        approaches = [feeder1Approaches,feeder2Approaches,feeder3Approaches,feeder4Approaches];
        %display(approaches)
        appearences = [feeder1Appearences, feeder2Appearences,feeder3Appearences,feeder4Appearences];
        %display(appearences)

        if feeder1Appearences == 0
            ME = MException("MATLAB:notEnoughInputs","Feeder 1 had no appearences");
            throw(ME)
        end
        if feeder2Appearences == 0
            ME = MException("MATLAB:notEnoughInputs","Feeder 2 had no appearences");
            throw(ME)
        end
        if feeder3Appearences == 0
            ME = MException("MATLAB:notEnoughInputs","Feeder 3 had no appearences");
            throw(ME)
        end
        if feeder4Appearences == 0
            ME = MException("MATLAB:notEnoughInputs","Feeder 4 had no appearences");
            throw(ME)
        end

        %feeder[1,2,3,4]ApproachPercentage = number of times rat approached / number of times the feeder appeared
        feeder1ApproachPercentage = feeder1Approaches / feeder1Appearences;
        feeder2ApproachPercentage = feeder2Approaches / feeder2Appearences;
        feeder3ApproachPercentage =feeder3Approaches / feeder3Appearences;
        feeder4ApproachPercentage =feeder4Approaches / feeder4Appearences;

        %feeder[1,2,3,4]Percentage is the percent concentration stored in the table included in any
        feeder1Percentage = str2double(regexprep(string(local{1,5}),'%','')) / 100;
        feeder2Percentage = str2double(regexprep(string(local{1,6}),'%',''))/100;
        feeder3Percentage = str2double(regexprep(string(local{1,7}),'%',''))/100;
        feeder4Percentage = str2double(regexprep(string(local{1,8}),'%',''))/100;

        ycoordinates = [feeder1ApproachPercentage, feeder2ApproachPercentage, feeder3ApproachPercentage, feeder4ApproachPercentage ];
        xcoordinates = [feeder1Percentage, feeder2Percentage, feeder3Percentage, feeder4Percentage];


        %         display(xcoordinates)
        %         display(ycoordinates)
    end

    function [updated_search_results] = rewrite_search_results_for_correct_data(search_results)
        for search_results_row=1:size(search_results,1)
            if contains(search_results{search_results_row,3},'diagonal','IgnoreCase',true)
                search_results{search_results_row,3} = 1;
            elseif contains(search_results{search_results_row,3},'grid','IgnoreCase',true)
                search_results{search_results_row,3} = 2;
            elseif contains(search_results{search_results_row,3},'horizontal','IgnoreCase',true)
                search_results{search_results_row,3} = 3;
            elseif contains(search_results{search_results_row,3},'radial','IgnoreCase',true)
                search_results{search_results_row,3} = 4;
            end
        end
        updated_search_results = search_results;
    end

    function rewardChoiceLoop(subject_ids,dates,conn,experiment,dir_to_save_things_to)
        counter =1;
        psychometric_function_table = table([],[],[],[],[],[],[],[],[],[],'VariableNames', ["subjectid","date","x1","x2","x3","x4","y1","y2","y3","y4"]);
        while counter <=size(subject_ids,1)
            disp(strcat("Reward Choice: ",string(counter),"/",string(size(subject_ids,1))))
            try
                try

                    query = strcat("SELECT subjectid, referencetime, feeder, approachavoid,rewardconcentration1,rewardconcentration2," + ...
                        "rewardconcentration3,rewardconcentration4,trialcontrolsettings FROM live_table" + ...
                        " WHERE referencetime LIKE '",dates(counter),"%' AND subjectid = '", subject_ids(counter),"';");

                    %         disp(query);


                    searchResults = fetch(conn,query);
                    searchResults = rewrite_search_results_for_correct_data(searchResults);
                    %display(searchResults)
                    searchResults2 = rmmissing(searchResults, 'DataVariables',["feeder","approachavoid"]);
                    %display(searchResults)
                    if height(searchResults) == 0
                        display(searchResults)
                        disp("The following query resulted in NaNs")
                        disp(query)
                        counter = counter+1;
                        continue
                    end
                    %creates the psychomatical function
                    [xcoordinates,ycoordinates] = createRewardChoicePsychometricFunction(searchResults2);
                    data = table(subject_ids(counter),dates(counter),...
                        xcoordinates(1),xcoordinates(2),xcoordinates(3),xcoordinates(4),...
                        ycoordinates(1),ycoordinates(2),ycoordinates(3),ycoordinates(4),...
                        'VariableNames', ["subjectid","date","x1","x2","x3","x4","y1","y2","y3","y4"]);
                    psychometric_function_table = [psychometric_function_table;data];

                catch e
                    disp("Error occured for the following query")
                    disp(query)
                    fprintf(1,'The identifier was:\n%s',e.identifier);
                    fprintf(1,'The message was:\n%s',e.message)
                    disp("_________________________________________________")
                    counter = counter+1;
                end
                counter = counter+1;
            catch e
                fprintf(1,'The identifier was:\n%s',e.identifier);
                fprintf(1,'The message was:\n%s',e.message)
                disp("_________________________________________________")
                counter = counter+1;
                %                 somethingWrongCounter = somethingWrongCounter+1;
            end


        end
        writetable(psychometric_function_table,strcat(dir_to_save_things_to,"\",experiment," reward_choice psychometric functions table.xlsx"));
    end

dir_to_save_things_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_things_to);

datasource = 'live_database'; %ENTER YOUR DATASOURCE NAME HERE, default should be "live_database"
username = 'postgres'; %ENTER YOUR USERNAME HERE, default should be "postgres"
password = '1234'; %ENTER YOUR PASSWORD HERE, default should be "1234"


conn = database(datasource,username,password); %creates the database connection
rewardChoiceLoop(subject_ids,dates,conn,experiment,dir_to_save_things_to)
close(conn)



end
