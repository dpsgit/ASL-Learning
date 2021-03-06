function [frequencyTable, startTimes] = createWordFrequencies(videoStack, timeSequences, staticThresh, backgroundThresh, docLength, boxSize, r, u, l, d, s)
    % videoStack    - a hxwxf matrix, of f frames of height h and width w
    % timeSequences - a fx1 vector of the associated frame time stamps (s)
    % docLength     - the (target) length of a document (s)
    
    [height, width, nFrames] = size(videoStack);
    
    deltaTimes = diff(timeSequences);
    avgDelta = mean(deltaTimes);
    framesPerDoc = round(docLength / avgDelta);
    
    fBoxes = floor(nFrames / framesPerDoc);
    hBoxes = floor(height / boxSize);
    wBoxes = floor(width / boxSize);
    
    % compute the discretized optical flow vectors here
    
    if nargin < 11
        fprintf('Computing optical flow\n');
        [r, u, l, d, s] = computeOpticalFlowBins(videoStack, staticThresh);
    end
    
    frequencyTable = zeros(fBoxes,5 * hBoxes * wBoxes);
    startTimes  = zeros(fBoxes,1);

    %backgroundMask = repmat(sum(s,3) > nFrames * backgroundThresh,1,1,nFrames - 1);
    

    %r = r.* backgroundMask; u = u .* backgroundMask; l = l .* backgroundMask; d = d .* backgroundMask; s = s .* backgroundMask;

    for frame = 1:fBoxes - 1

        fprintf('Analyzing frame %d\n',frame);
        startTimes(frame) = (frame - 1) * framesPerDoc + 1;
        frameRange = (frame - 1) * framesPerDoc + 1 : frame * framesPerDoc;
        for height = 1:hBoxes
            for width = 1:wBoxes
                heightRange = (height - 1) * boxSize + 1 : height * boxSize;
                widthRange = (width - 1) * boxSize + 1: width * boxSize;
                
                [X, Y, Z] = meshgrid(heightRange, widthRange, frameRange);
                wordRange = sub2ind(size(videoStack),X, Y, Z);
                wordRange = wordRange(:);
                
                freqStart = sub2ind([hBoxes wBoxes],height,width);
                frequencyTable(frame, 5 * (freqStart - 1) + 1: 5 * (freqStart - 1) + 5) = ...
                    [sum(l(wordRange)) sum(r(wordRange)) sum(u(wordRange)) sum(d(wordRange)) sum(s(wordRange))]; 
            end
        end
        
    end
end

