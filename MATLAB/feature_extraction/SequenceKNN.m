function [ output_args] = SequenceKNN(feature_multi_array, sequence_size, k)


% Training samples for 1 video looks like a numFrames x length_of_feature+1
% array. For multiple videos, however, we will have a numFrames/video*numVideos x
% length_of_feature+1 x numFrames

numSequences = m - (sequence_size) + 1;

% Array containing arrays of indices of k nearest neighbors
kNearestArray = zeros(k, numSequences);

% Calculate densities
for i = 1:numSequences

    currSequence = X(i:i+sequence_size, n-1);
    minDistances = zeros(1, k);
    for i = 1:k;
        minDistances(i) = Inf;
    end

    for j = 1:numSequences
        if (i ~= j && (j > i+sequence_size) || (j+sequence_size < i))
            comparedSequence = X(j:j+sequence_size, n-1);
            dist = DTWDistance(currSequence, comparedSequence);
            if (dist < minDistances(k));
                minDistances(k) = dist;
                sort(minDistances, 2, 'ascend'); % 1 or 2 for dim?
            end
        end
    end

    density(i) = 1/minDistances(k);
    kNearestArray(i, :) = minDistances';

end

for i = 1:numSequences;

    isMostDense = true;
    for j = kNearestArray(i);

        if (density(i) < density(j));
            isMostDense = false;
        end
    end

    if (isMostDense == true);
        estimatedMotifs = cat(1, estimatedMotifs, i);
    end

end