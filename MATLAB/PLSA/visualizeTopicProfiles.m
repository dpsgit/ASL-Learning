function visualizeTopicProfiles(pw_z, videoStack, boxSize)
    % wordFrequencies - a mxn matrix, 
    %       m = number of documents
    %       n = 5 * number of pixel boxes in (r u l d s) order
    
    wBoxes = floor(size(videoStack,2) / boxSize);
    hBoxes = floor(size(videoStack,1) / boxSize);
    
    for i = 1:size(pw_z,2)
        wordProbs = sum(reshape(pw_z(:,i),5,hBoxes * wBoxes),1);
        imgProbs = imresize(reshape(wordProbs,hBoxes,wBoxes),boxSize);
        max(imgProbs(:))
        %imgProbs = 255 * imgProbs / max(imgProbs(:));
        imshow(255 * imgProbs);
        drawnow;
    end
end

