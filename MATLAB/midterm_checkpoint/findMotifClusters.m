function estimatedMotifs = findMotifClusters(samples, k)
    % Expect samples to be numSamples x numFeatures

    numSamples = size(samples,1);

    % Calculate densities

    [kNearestArray, kNearestDist] = knnsearch(samples, samples,'K', k + 1);
    
    densities = 1 ./ kNearestDist(:,k+1);

    estimatedMotifs = [];

    for i = 1:numSamples
        %fprintf('Testing local density max of %d \n', i);
        if (sum(densities(i) <= densities(kNearestArray(i,2:end))) == 0)
            estimatedMotifs = cat(1, estimatedMotifs, i);
        end
    end
    
end