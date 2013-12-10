function n_taw = computeCorrelations(pw_z, frequencies)
    topicSums = frequencies * pw_z;

    possibleWords = pw_z ~= 0;
    possibleFrequencies = frequencies * possibleWords;
    
    n_taw = topicSums ./ possibleFrequencies;
end


