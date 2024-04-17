function change_scatter_object_colors(array_of_scatter_objects,desired_colors)
for i=1:length(array_of_scatter_objects)
    current_scatter_object = array_of_scatter_objects{i};
    current_scater_object.MarkerEdgeColor = desired_colors{i};
end
end