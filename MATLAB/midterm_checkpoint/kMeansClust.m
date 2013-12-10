function means = kMeansClust(data, nClusters)
    [nSamples, nDim] = size(data);
    means = data(randperm(nSamples,nClusters),:);
    
    curLabels = zeros(nSamples,1);
    labels = ones(nSamples,1);
    while (curLabels ~= labels)
        curLabels = labels;
        for j = 1:nSamples
            labels(j) = findClosestLabel(data(j,:),means);
        end
        for j = 1:nClusters
            means(j,:) = mean(data(labels == j,:),1);
        end
        
    end

end

function label = findClosestLabel(sample, clusters)
    nClusters = size(clusters,1);
    delta = clusters - repmat(sample,nClusters,1);
    [val, label] = min(diag(delta * delta'));
end

