function [counts, chains] = findSequenceChains(clusters, samples, k, timeList, numMotifs)
    % Expect samples to be numSamples x numFeatures

    % Calculate densities

    [kNearestArray, kNearestDist] = knnsearch(samples, samples(clusters,:),'K', k + 1);
    
    counts = histc(timeList(kNearestArray(:,2:end))',1:max(timeList));
    
    chains = kMeansClust(counts',numMotifs);
end