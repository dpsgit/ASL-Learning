function visualizeTopic(pw_z, word, frequencies, videoStack, boxSize)
    % wordFrequencies - a mxn matrix, 
    %       m = number of documents
    %       n = 5 * number of pixel boxes in (r u l d s) order
    
    wBoxes = floor(size(videoStack,2) / boxSize);
    hBoxes = floor(size(videoStack,1) / boxSize);
    
    docProbs = frequencies .* repmat(pw_z(:,word)',size(frequencies,1),1);
    
    for i = 1:size(frequencies,1)
        wordProbs = sum(reshape(docProbs(i,:)',5,hBoxes * wBoxes),1);
        imgProbs = imresize(reshape(wordProbs,hBoxes,wBoxes),boxSize);
        
        %imgProbs = 255 * imgProbs / max(imgProbs(:));
        imshow((imgProbs));
        %{
        hold off,
        imshow(videoStack(:,:,i));
        hold on,
        greenImg = ones(size(imgProbs));
        h = imshow([0 * greenImg 255 * greenImg 0 * greenImg]);
        set(h,'AlphaData',imgProbs);
        %}
        drawnow;
    end
end

