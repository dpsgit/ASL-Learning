function visualizeWords(wordFrequencies, videoStack, frame, frameRange, boxSize)
    % wordFrequencies - a mxn matrix, 
    %       m = number of documents
    %       n = 5 * number of pixel boxes in (r u l d s) order
    
    wBoxes = floor(size(videoStack,2) / boxSize);
    hBoxes = floor(size(videoStack,1) / boxSize);

    rWords = wordFrequencies(frame,1:5:end);
    uWords = wordFrequencies(frame,2:5:end);
    lWords = wordFrequencies(frame,3:5:end);
    dWords = wordFrequencies(frame,4:5:end);
    sWords = wordFrequencies(frame,5:5:end);

    rFrame = imresize(reshape(rWords,hBoxes, wBoxes), boxSize);
    uFrame = imresize(reshape(uWords,hBoxes, wBoxes), boxSize);
    lFrame = imresize(reshape(lWords,hBoxes, wBoxes), boxSize);
    dFrame = imresize(reshape(dWords,hBoxes, wBoxes), boxSize);
    sFrame = imresize(reshape(sWords,hBoxes, wBoxes), boxSize);
    
    hdl = figure;
    subplot(2,3,2),
    imshow(rFrame);
    subplot(2,3,3),
    imshow(uFrame);
    subplot(2,3,4),
    imshow(lFrame);
    subplot(2,3,5),
    imshow(dFrame);
    subplot(2,3,6),
    imshow(sFrame);
    
    for i = frameRange
        subplot(2,3,1),
        imshow(videoStack(:,:,i));
        drawnow;
    end
end

