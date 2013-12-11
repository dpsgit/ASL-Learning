function visualizeFrequencyTable(wordFrequencies, videoStack, boxSize, framesPerDoc)
    % wordFrequencies - a mxn matrix, 
    %       m = number of documents
    %       n = 5 * number of pixel boxes in (r u l d s) order
    
    S.wBoxes = floor(size(videoStack,2) / boxSize)
    S.hBoxes = floor(size(videoStack,1) / boxSize)

    S.vs = videoStack;
    S.wf = wordFrequencies;
    S.fNum = 1;
    S.boxSize = boxSize;
    S.fpd = framesPerDoc;

    lWords = S.wf(S.fNum,1:5:end);
    rWords = S.wf(S.fNum,2:5:end);
    uWords = S.wf(S.fNum,3:5:end);
    dWords = S.wf(S.fNum,4:5:end);
    sWords = S.wf(S.fNum,5:5:end);

    rFrame = imresize(reshape(rWords,S.hBoxes, S.wBoxes), boxSize);
    uFrame = imresize(reshape(uWords,S.hBoxes, S.wBoxes), boxSize);
    lFrame = imresize(reshape(lWords,S.hBoxes, S.wBoxes), boxSize);
    dFrame = imresize(reshape(dWords,S.hBoxes, S.wBoxes), boxSize);
    sFrame = imresize(reshape(sWords,S.hBoxes, S.wBoxes), boxSize);
    
    nFrames = size(wordFrequencies,1);

    S.stack = videoStack;

    S.fh = figure('units','pixels',...
                  'position',[600 600 600 400],...
                  'menubar','none',...
                  'name','Frequency Table',...
                  'numbertitle','off',...
                  'resize','off');
    S.sl = uicontrol('style','slide',...
                     'unit','pix',...
                     'position',[170 10 260 30],...
                     'min',1,'max',nFrames,'val',1);    
    set(S.sl,'call',{@ed_call,S});  % Shared Callback.

    S.fNum = 1;
    fprintf('Frame: %d\n',S.fNum);

    subplot(2,3,2),
    printNormImg(rFrame, 'Right Flow');
    subplot(2,3,3),
    printNormImg(uFrame, 'Up Flow');
    subplot(2,3,4),
    printNormImg(lFrame, 'Left Flow');
    subplot(2,3,5),
    printNormImg(dFrame, 'Down Flow');
    subplot(2,3,6),
    printNormImg(sFrame, 'Static Flow');

    startTimes = (S.fNum - 1) * framesPerDoc + 1;
    frameRange = (S.fNum - 1) * framesPerDoc + 1 : S.fNum * framesPerDoc;

    subplot(2,3,1),
    for i = frameRange
        imshow(uint8(round(videoStack(:,:,i))));
        pause(.2);
        drawnow;
    end

function [] = ed_call(varargin)
% Callback for the edit box and slider.
[h,S] = varargin{[1,3]};  % Get calling handle and structure.

switch h  % Who called?
    case S.sl
        S.fNum = round(get(S.sl,'value'));
        fprintf('Frame: %d\n',S.fNum);
        set(S.sl,'value',S.fNum);
        figure(S.fh);

        lWords = S.wf(S.fNum,1:5:end);
        rWords = S.wf(S.fNum,2:5:end);
        uWords = S.wf(S.fNum,3:5:end);
        dWords = S.wf(S.fNum,4:5:end);
        sWords = S.wf(S.fNum,5:5:end);

        rFrame = imresize(reshape(rWords,S.hBoxes, S.wBoxes), S.boxSize);
        uFrame = imresize(reshape(uWords,S.hBoxes, S.wBoxes), S.boxSize);
        lFrame = imresize(reshape(lWords,S.hBoxes, S.wBoxes), S.boxSize);
        dFrame = imresize(reshape(dWords,S.hBoxes, S.wBoxes), S.boxSize);
        sFrame = imresize(reshape(sWords,S.hBoxes, S.wBoxes), S.boxSize);

        subplot(2,3,2),
        printNormImg(rFrame, 'Right Flow');
        subplot(2,3,3),
        printNormImg(uFrame, 'Up Flow');
        subplot(2,3,4),
        printNormImg(lFrame, 'Left Flow');
        subplot(2,3,5),
        printNormImg(dFrame, 'Down Flow');
        subplot(2,3,6),
        printNormImg(sFrame, 'Static Flow');

        startTimes = (S.fNum - 1) * S.fpd + 1;
        frameRange = (S.fNum - 1) * S.fpd + 1 : min(S.fNum * S.fpd, size(S.vs,3))

        subplot(2,3,1),
        for i = frameRange
            imshow(S.vs(:,:,i));

            pause(.2);
            drawnow;
        end
    otherwise
        % Do nothing, or whatever.
end

