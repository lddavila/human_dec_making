function sigmoid_analysis_updated(table_of_psychometric_functions,feature,dir_to_save_figs_to)
    function [] = create_sigmoid_figures_updated(results,feature,dir_to_save_figs_to)
        for i = 1:height(results)
            disp(strcat(feature, " ",string(i),"/",string(height(results))))


            x = [0.09,0.05,0.02,0.005];
            y = results{i,[6,7,8,9]};



            [fitobject1, gof1]= fit(x.',y.','a*x+b');


            counter = 1;
            [fitobject2, gof2] = fit(x.', y.', '1 / (1 + (b*exp(-c * x)))');
            while counter <20 && gof2.rsquare < .4
                [fitobject2, gof2] = fit(x.', y.', '1 / (1 + (b*exp(-c * x)))');
                counter = counter+1;
            end

            counter = 1;
            [fitobject3, gof3] = fit(x.',y.','(a/(1+b*exp(-c*(x))))');
            while counter <20 && gof3.rsquare < .4
                [fitobject3, gof3] = fit(x.',y.','(a/(1+b*exp(-c*(x))))');
                counter = counter+1;
            end

            counter = 1;
            [fitobject4, gof4] = fit(x.', y.', '(a/(1+(b*(exp(-c*(x-d))))))');
            while counter <20 && gof4.rsquare < .4
                [fitobject4, gof4] = fit(x.', y.', '(a/(1+(b*(exp(-c*(x-d))))))');
                counter = counter+1;
            end

            [fitobject5, gof5] = fit(x.',y.','a*(x-b)^(2)+c');
               
           
            
            
            

            f = figure('Visible','off');
            currentFolder = dir_to_save_figs_to;

            dynamicName = strcat(currentFolder,"\");

            if gof3.rsquare >= .4
                plot(fitobject3,x.',y.');
                ylabel(strrep(feature,"_","\_"))
                xlabel("Reward")
                title(strcat("3 Param. Sigmoid: ", strrep(string(results{i,1}),"/","-")))
                fighandle3 = gcf;
                set(fighandle3, 'visible', 'on');
                saveas(fighandle3,strcat(dynamicName,feature," 3 Parameter Sigmoid\",strrep(strrep(string(results{i,1}),"/","-"),"/","-"),".fig"))
                save(strcat(dynamicName,feature,' Sigmoid Data\',strrep(string(results{i,1}),"/","-"),'.mat'),'fitobject3')
            elseif gof4.rsquare >= .4
                plot(fitobject4, x.', y.');
                ylabel(strrep(feature,"_","\_"))
                xlabel("Reward")
                title(strcat("4 Param Sigmoid: ",strrep(string(results{i,1}),"/","-"), " ", strrep(string(results{i,2}),"/", "-")))
                fighandle4 = gcf;
                set(fighandle4, 'visible', 'on');
                saveas(fighandle4,strcat(dynamicName,feature," 4 Parameter Sigmoid\",strrep(string(results{i,1}),"/","-"),".fig"))
                save(strcat(dynamicName,feature,' Sigmoid Data\',strrep(string(results{i,1}),"/","-"),'.mat'),'fitobject4')
            elseif gof2.rsquare >= .4
                plot(fitobject2, x.', y.');
                ylabel(strrep(feature,"_","\_"))
                xlabel("Reward")
                title(strcat("2 Param Sigmoid: ",strrep(string(results{i,1}),"/","-"), " ", strrep(string(results{i,2}),"/", "-")))
                fighandle2 = gcf;
                set(fighandle2, 'visible', 'on');
                saveas(fighandle2,strcat(dynamicName,feature," 2 Parameter Sigmoid\",strrep(string(results{i,1}),"/","-"),".fig"))
                save(strcat(dynamicName,feature,' Sigmoid Data\',strrep(string(results{i,1}),"/","-"),'.mat'),'fitobject2')
            elseif gof1.rsquare > gof5.rsquare
                plot(fitobject1,x.',y.');
                ylabel(strrep(feature,"_","\_"))
                xlabel("Reward")
                title(strcat("Line: ",strrep(string(results{i,1}),"/","-")))
                fighandle1 = gcf;
                set(fighandle1, 'visible', 'on');
                saveas(fighandle1,strcat(dynamicName,feature," Lines\",strrep(string(results{i,1}),"/","-"),".fig"))
                save(strcat(dynamicName,feature,' Line Data\',strrep(string(results{i,1}),"/","-"),'.mat'),'fitobject1')
            elseif gof5.rsquare > gof1.rsquare
                plot(fitobject5,x.',y.');
                ylabel(strrep(feature,"_","\_"))
                xlabel("Reward")
                title(strcat("Parabola: ", strrep(string(results{i,1}),"/","-")))
                fighandle5 = gcf;
                set(fighandle5, 'visible', 'on');
                saveas(fighandle5,strcat(dynamicName,feature," Parabolas\",strrep(string(results{i,1}),"/","-"),".fig"))
                save(strcat(dynamicName,feature,' Parabola Data\',strrep(string(results{i,1}),"/","-"),'.mat'),'fitobject5')
            end


            close all

        end
        close all;
    end


    function create_directories_updated(feature,dir_to_save_figs_to)

        mkdir(strcat(dir_to_save_figs_to,"\",feature," 2 Parameter Sigmoid"))
        mkdir(strcat(dir_to_save_figs_to,"\",feature," 3 Parameter Sigmoid"))
        mkdir(strcat(dir_to_save_figs_to,"\",feature," 4 Parameter Sigmoid"))
        mkdir(strcat(dir_to_save_figs_to,"\",feature," Sigmoid Data"))
        mkdir(strcat(dir_to_save_figs_to,"\",feature," Lines"))
        mkdir(strcat(dir_to_save_figs_to,"\",feature," Line Data"))
        mkdir(strcat(dir_to_save_figs_to,"\",feature," Parabolas"))
        mkdir(strcat(dir_to_save_figs_to,"\",feature," Parabola Data"))

    end

dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);

create_directories_updated(feature,dir_to_save_figs_to);


create_sigmoid_figures_updated(table_of_psychometric_functions,feature,dir_to_save_figs_to);

end