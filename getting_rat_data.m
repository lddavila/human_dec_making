%% get control data
clc;
% all_possible_baseline = {
% 'NA'
% 'Baseline 1'
% 'Baseline 3'
% 'Baseline 10'
% 'Baseline 8'
% 'No injection'
% 'Baseline 2'
% 'No Injection'
% 'Baseline 6'
% 'Baseline 4'
% '(Control)'
% 'No Injection (Control)'
% 'Baseline 9'};

all_possible_baseline = {
'NA'
'No injection'
'(Control)'
'No Injection (Control)'};

expected_number_of_sessions = "SELECT count(distinct(subjectid,date)) FROM live_table where notes is null and (health='N/A';";
query = "SELECT DISTINCT date,subjectid from live_table where notes is null and (health='N/A'";
for i=1:length(all_possible_baseline)
    query = query + " OR health = '"+ all_possible_baseline{i}+ "'";
end
query = query +") ORDER BY DATE;";

disp(query)

conn = database("live_database","postgres","1234");
result = fetch(conn,query);
result.subjectid = string(result.subjectid);
result.date = string(result.date);
disp(result)
%% get the psychometric functions of control data
automize_psychometric_functions_only_reward_choice(result.subjectid,result.date,"baseline",strcat("psych functions created ",string(datetime("today",'Format','MM-dd-yyyy'))));

%% fit the psychometric functions with sigmoids 
table_of_psychometric_functions = readtable(strcat(pwd,"\psych functions created ",string(datetime("today",'Format','MM-dd-yyyy')),"\baseline reward_choice psychometric functions table.xlsx"));
subject_id_col = string(table_of_psychometric_functions.subjectid);
date_col = string(table_of_psychometric_functions.date);
table_of_psychometric_functions = table(strcat(subject_id_col,repelem(" ",size(subject_id_col,1),1),date_col), ...
    table_of_psychometric_functions.x1,table_of_psychometric_functions.x2,table_of_psychometric_functions.x3,table_of_psychometric_functions.x4, ...
    table_of_psychometric_functions.y1,table_of_psychometric_functions.y2,table_of_psychometric_functions.y3,table_of_psychometric_functions.y4,...
    'VariableNames',["label","x1","x2","x3","x4","y1","y2","y3","y4"]);
sigmoid_analysis_updated(table_of_psychometric_functions,"reward choice",strcat("rat sigmoid data created ",string(datetime("today",'Format','MM-dd-yyyy'))));
