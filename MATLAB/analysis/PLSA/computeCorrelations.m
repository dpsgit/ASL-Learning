function n_taw = computeCorrelations(pw_z, frequencies, ep)
    topicSums = frequencies * pw_z

    possibleWords = pw_z < ep;
    possibleFrequencies = frequencies * possibleWords
    
    n_taw = topicSums ./ possibleFrequencies;
end


