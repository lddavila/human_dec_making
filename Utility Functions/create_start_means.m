function start_means = create_start_means(mu)

%sigma plots the singular values of the frequency response of a dynamic system model 
sigma(:,:,1) = [1 1; 1 2];
sigma(:,:,2) = [1 1; 1 2];
sigma(:,:,3) = [1 1; 1 2];

if length(mu) == 4
    sigma(:,:,4) = [0.5 0.5; 0.5 1];
end

start_means = struct('mu',mu,'Sigma',sigma);

end