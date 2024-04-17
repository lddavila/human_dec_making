function rat_struct_object = create_rat_struct_object(covariance_matrices,cluster_centers,component_proportion)
Mu = cluster_centers;
Sigma(:,:,1) = covariance_matrices{1};
Sigma(:,:,2) = covariance_matrices{2};
Sigma(:,:,3) = covariance_matrices{3};
Sigma(:,:,4) = covariance_matrices{4};
% PComponents = cell2mat(component_proportion);
% rat_struct_object = struct('mu',Mu,'Sigma',Sigma,'ComponentProportion',PComponents);

rat_struct_object = struct('mu',Mu,'Sigma',Sigma);
end