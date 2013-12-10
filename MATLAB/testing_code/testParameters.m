% Parameters to adjust
densityTuningRange = 2:5:20;
histogramRange = 5:5:20;
videoRange = 78:120;

signTimes = [79:90 93:104 107:118];

%[allFeatures, timeList] = compute3dHog(double(videoStack(:,:,videoRange)));
best = [0 0 -Inf];
for k1 = densityTuningRange
    for k2 = histogramRange
        fprintf('Trying k1 = %d k2 = %d\n',k1, k2);
        motifs = findMotifClusters(allFeatures,k1);
        [counts chains] = findSequenceChains(motifs, allFeatures, k2, timeList, 5);
        counts = counts / k2;
        counts = counts / size(counts,2);
        correctTime = counts(signTimes - videoRange(1),:);
        incorrectTime = sum(counts(:)) - sum(correctTime(:));
        fprintf('Current: %f, Current Best: %f\n',sum(correctTime(:)) - incorrectTime, best(3));
        if sum(correctTime(:)) - incorrectTime > best(3)
            best(3) = sum(correctTime(:)) - incorrectTime;
            best(1) = k1;
            best(2) = k2;
            fprintf('Updating max\n');
        else
            fprintf('FAIL\n');
        end
    end
    
end
