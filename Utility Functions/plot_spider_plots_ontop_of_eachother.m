function [] = plot_spider_plots_ontop_of_eachother(probabilities, point_labels,title_of_figure,legend_strings,dir_to_save_things_to)
figure('units','normalized','outerposition',[0 0 1 1])
axes_limits = [zeros(1,length(probabilities));max(probabilities)+0.05];
axes_labels = cell(1,length(point_labels));
for i=1:length(axes_labels)
    axes_labels{i} = char(strcat("Cluster ",string(point_labels(i))));
end
legend_labels = cell(1,length(legend_strings));
for i=1:length(legend_strings)
    legend_labels{i} = char(legend_strings(i));
end
spider_plot(probabilities, ...
    'AxesLimits',axes_limits, ...
    'AxesPrecision',zeros(1,size(probabilities,2))+3,...
    'AxesDisplay','data',...,
    'AxesLabelsOffset', 0.2,...
    'AxesDataOffset',0.1,...
    'AxesLabels',axes_labels);



% 
% s = spider_plot_class(probabilities);
% s.AxesLimits = axes_limits;
% s.AxesPrecision = zeros(1,size(probabilities,2))+3;
% s.AxesDisplay = 'data';
% % s.AxesLabelsOffset = 0.2;
% % s.AxesDataOffset=0.1;
% s.AxesFontColor = [0, 0, 1; 1, 0 ,0];
% s.AxesLabels = axes_labels;

title(title_of_figure);
disp(legend_strings);
legend(legend_strings);
set(gcf,'renderer','Painters');
disp("the probability submitted");
disp(probabilities);
saveas(gcf,strcat(dir_to_save_things_to,"\",title_of_figure(1),".fig"),"fig");

end