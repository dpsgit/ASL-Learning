function visualizeWords(pw_z, frequencies, videoStack, boxSize)
    % wordFrequencies - a mxn matrix, 
    %       m = number of documents
    %       n = 5 * number of pixel boxes in (r u l d s) order
    
    wBoxes = floor(size(videoStack,2) / boxSize);
    hBoxes = floor(size(videoStack,1) / boxSize);
    
    docProbs = frequencies .* repmat(sum(pw_z',1),size(frequencies,1),1);
    
    for i = 1:10
        wordProbs = sum(reshape(docProbs(i,:)',5,hBoxes * wBoxes),1);
        imgProbs = imresize(reshape(wordProbs,hBoxes,wBoxes),boxSize);
        
        imgProbs = 255 * imgProbs / max(imgProbs(:));
        imshow(uint8(round(imgProbs)));
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

