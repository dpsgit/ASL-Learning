function displayCorrelations(frequencies, videoStack, pw_z, topic, boxSize)

    wBoxes = floor(size(videoStack,2) / boxSize);
    hBoxes = floor(size(videoStack,1) / boxSize);
    
    labels = {'Right','Up','Left','Down','Static'};
    for k = 0:4
        subplot(5,2,1 + 2 * k),
        
        imgProbs = imresize(reshape(pw_z(1 + k:5:end,topic),hBoxes,wBoxes),boxSize);

        imshow(1000*imgProbs); 
        
        titleStr = strcat('Topic ',num2str(topic),' - ',labels(k+1));
        title(titleStr);
    end
    
    
    for i = 10
        for k = 0:4
            subplot(5,2,2 + 2 * k),
            imgProbs = imresize(reshape(frequencies(i,1 + k:5:end),hBoxes,wBoxes),boxSize);

            imshow(uint8(2 * round(imgProbs)));
           
            titleStr = strcat('Frequency counts, frame - ',num2str(i));
            title(titleStr);
            
        end
        drawnow;
    end
end

