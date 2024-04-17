function [] = plot_spider_plots_ontop_of_eachother_include_sig_for_mean(probabilities, point_labels,title_of_figure,legend_strings,dir_to_save_things_to,the_subtitle)
figure;
axes_limits = [min(probabilities)-0.05;max(probabilities)+0.05];
axes_labels = cell(1,length(point_labels));
for i=1:length(axes_labels)
    axes_labels{i} = char(strcat(string(point_labels(i))));
end
legend_labels = cell(1,length(legend_strings));
for i=1:length(legend_strings)
    legend_labels{i} = char(legend_strings(i));
end


spider_plot(probabilities, ...
    'AxesLimits',axes_limits, ...
    'AxesPrecision',zeros(1,size(probabilities,2))+3, ...
    'AxesDisplay','data', ...
    'AxesLabelsOffset', 0.2, ...
    'AxesDataOffset', 0.01, ...
    'AxesLabels',axes_labels)


title([title_of_figure,the_subtitle]);

disp(legend_strings)
legend(legend_strings,'Location','best')
%set(gcf,'renderer','Painters');
disp("the probability submitted");
disp(probabilities);
saveas(gcf,strcat(dir_to_save_things_to,"\",title_of_figure,".fig"),"fig");

end