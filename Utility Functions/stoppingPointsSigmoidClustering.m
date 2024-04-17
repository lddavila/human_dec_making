function newTable = stoppingPointsSigmoidClustering(want_humans, human_dir)

if want_humans
    myDir = human_dir; %gets directory
else
    myDir = "C:\Users\lrako\OneDrive\Documents\RECORD\Stopping Points\All Sigmoids"; %gets animal directory
end
myFiles = dir(fullfile(myDir,'*.mat')); %gets all .mat files in struct

A = [];
B = [];
C = [];
D = [];
E = [];
newTable = table(A,B,C,D,E);

for k = 1:length(myFiles)
    if k == 168
        k;
    end
        
    baseFileName = myFiles(k).name;
    fullFileName = fullfile(myDir, baseFileName);
%     fprintf(1, 'Now reading %s\n', fullFileName);
    load(fullFileName)
    try
        C = {fitobject3.a,fitobject3.b,fitobject3.c,0,baseFileName};
        T = cell2table(C,'VariableNames',{'A','B','C','D','E'});
        % display([fitobject3.a,fitobject3.b,fitobject3.c,0,baseFileName])
    catch ME
        %         display(ME)
        %         display("Makes it here")
        try
            C = {1,fitobject2.b, fitobject2.c,0,baseFileName};
            T = cell2table(C,'VariableNames',{'A','B','C','D','E'});
            % display([1,fitobject2.b, fitobject2.c, 0, baseFileName])
        catch
            try
                C = {fitobject4.a,fitobject4.b,fitobject4.c,fitobject4.d,baseFileName};
                T = cell2table(C,'VariableNames',{'A','B', 'C','D','E'});
                % display([fitobject4.a,fitobject4.b,fitobject4.c,fitobject4.d,baseFileName])
            catch
                % display("None Of them worked for some reason")
            end
        end
    end
    clear fitobject2 fitobject3 fitobject4
    newTable = [newTable;T];
end
