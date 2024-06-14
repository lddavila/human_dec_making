function concatenate_plots_based_on_type(directory_with_plots,pdf_file_name,pdf_directory_rel,types)
if ~exist(pdf_directory_rel,"dir")
    mkdir(pdf_directory_rel)
end
home_dir = cd(pdf_directory_rel);
pdf_directory_abs = cd(home_dir);
cd(directory_with_plots);
directory_with_plots_abs = cd(home_dir);
cd(directory_with_plots_abs);
for k=1:length(types)
    current_type = types(k);
    list_of_all_plots = strtrim(string(ls(strcat(pwd,"\*",current_type,"*.fig"))));
    disp(list_of_all_plots)

    for i=1:length(list_of_all_plots)
        openfig(list_of_all_plots(i),"reuse");
        ax = gcf;
        cd(pdf_directory_abs);
        exportgraphics(ax,strcat(pdf_file_name,current_type,".pdf"), "Append",true);
        close(gcf);
        cd(directory_with_plots_abs);
    end
end
cd(home_dir)
end