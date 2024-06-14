%% get food dep data
clc;

query = "SELECT DISTINCT date,subjectid FROM live_table where LOWER(health) LIKE '%pre%';";

disp(query)

conn = database("live_database","postgres","1234");
result = fetch(conn,query);
result.subjectid = string(result.subjectid);
result.date = string(result.date);
disp(result)
%% get the psychometric functions of pre feeding data
automize_psychometric_functions_only_reward_choice(result.subjectid,result.date,"pre feeding ",strcat("pre feeding psych functions created ",string(datetime("today",'Format','MM-dd-yyyy'))));

%% fit the psychometric functions with sigmoids 
table_of_psychometric_functions = readtable(strcat(pwd,"\pre feeding psych functions created ",string(datetime("today",'Format','MM-dd-yyyy')),"\pre feeding  reward_choice psychometric functions table.xlsx"));
subject_id_col = string(table_of_psychometric_functions.subjectid);
date_col = string(table_of_psychometric_functions.date);
table_of_psychometric_functions = table(strcat(subject_id_col,repelem(" ",size(subject_id_col,1),1),date_col), ...
    table_of_psychometric_functions.x1,table_of_psychometric_functions.x2,table_of_psychometric_functions.x3,table_of_psychometric_functions.x4, ...
    table_of_psychometric_functions.y1,table_of_psychometric_functions.y2,table_of_psychometric_functions.y3,table_of_psychometric_functions.y4,...
    'VariableNames',["label","x1","x2","x3","x4","y1","y2","y3","y4"]);


sigmoid_analysis_updated(table_of_psychometric_functions,"pre feeding reward choice",strcat("pre feeding rat sigmoid data created ",string(datetime("today",'Format','MM-dd-yyyy'))));
