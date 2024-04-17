function [] = plot_spider_plots(probabilities, point_labels,title_of_figure,dir_to_save_figs_to)
figure;
axes_limits = [zeros(1,length(probabilities));(probabilities + .05)];
axes_labels = cell(1,length(point_labels));
for i=1:length(axes_labels)
    axes_labels{i} = char(string(point_labels(i)));
end
spider_plot(probabilities,'AxesLabels',axes_labels,'AxesLimits',axes_limits);
title(title_of_figure);
saveas(gcf,strcat(dir_to_save_figs_to,"\",title_of_figure),"fig")
end