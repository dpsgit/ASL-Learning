function visualizeTopicProfiles(pw_z, videoStack, boxSize)
    % wordFrequencies - a mxn matrix, 
    %       m = number of documents
    %       n = 5 * number of pixel boxes in (r u l d s) order
    
    S.wBoxes = floor(size(videoStack,2) / boxSize);
    S.hBoxes = floor(size(videoStack,1) / boxSize);

    S.zNum = 1;
    S.boxSize = boxSize;
    S.pwz = pw_z;

    lWords = S.pwz(1:5:end,S.zNum);% > .0000000001;
    rWords = S.pwz(2:5:end,S.zNum);% > .0000000001;
    uWords = S.pwz(3:5:end,S.zNum);% > .0000000001;
    dWords = S.pwz(4:5:end,S.zNum);% > .0000000001;
    sWords = S.pwz(5:5:end,S.zNum);% > .0000000001;
    motionWords = lWords + rWords + uWords + dWords;

    rFrame = imresize(reshape(rWords,S.hBoxes, S.wBoxes), boxSize);
    uFrame = imresize(reshape(uWords,S.hBoxes, S.wBoxes), boxSize);
    lFrame = imresize(reshape(lWords,S.hBoxes, S.wBoxes), boxSize);
    dFrame = imresize(reshape(dWords,S.hBoxes, S.wBoxes), boxSize);
    sFrame = imresize(reshape(sWords,S.hBoxes, S.wBoxes), boxSize);
    mFrame = imresize(reshape(motionWords,S.hBoxes, S.wBoxes), boxSize);

    nTopics = size(pw_z,2);

    S.stack = videoStack;

    S.fh = figure('units','pixels',...
                  'position',[600 600 600 400],...
                  'menubar','none',...
                  'name','PLSA Topic Visualization',...
                  'numbertitle','off',...
                  'resize','off');
    S.sl = uicontrol('style','slide',...
                     'unit','pix',...
                     'position',[170 10 260 30],...
                     'min',1,'max',nTopics,'val',1);    
    set(S.sl,'call',{@ed_call,S});  % Shared Callback.

    S.zNum = 1;
    fprintf('Topic: %d\n',S.zNum);

    subplot(2,3,1),
    printNormImg(rFrame, 'Right Word');
    subplot(2,3,2),
    printNormImg(uFrame, 'Up Word');
    subplot(2,3,3),
    printNormImg(lFrame, 'Left Word');
    subplot(2,3,4),
    printNormImg(dFrame, 'Down Word');
    subplot(2,3,5),
    printNormImg(sFrame, 'Static Word');
    subplot(2,3,6),
    printNormImg(mFrame, 'All Motion Words');

function [] = ed_call(varargin)
% Callback for the edit box and slider.
[h,S] = varargin{[1,3]};  % Get calling handle and structure.

switch h  % Who called?
    case S.sl
        S.zNum = round(get(S.sl,'value'));
        fprintf('Topic: %d\n',S.zNum);
        set(S.sl,'value',S.zNum);
        figure(S.fh);

    lWords = S.pwz(1:5:end,S.zNum);% > .0000000001;
    rWords = S.pwz(2:5:end,S.zNum) ;%> .0000000001;
    uWords = S.pwz(3:5:end,S.zNum) ;%> .0000000001;
    dWords = S.pwz(4:5:end,S.zNum) ;%> .0000000001;
    sWords = S.pwz(5:5:end,S.zNum) ;%> .0000000001;
    motionWords = lWords + rWords + uWords + dWords;

        rFrame = imresize(reshape(rWords,S.hBoxes, S.wBoxes), S.boxSize);
        uFrame = imresize(reshape(uWords,S.hBoxes, S.wBoxes), S.boxSize);
        lFrame = imresize(reshape(lWords,S.hBoxes, S.wBoxes), S.boxSize);
        dFrame = imresize(reshape(dWords,S.hBoxes, S.wBoxes), S.boxSize);
        sFrame = imresize(reshape(sWords,S.hBoxes, S.wBoxes), S.boxSize);
        mFrame = imresize(reshape(motionWords,S.hBoxes, S.wBoxes), S.boxSize);

        subplot(2,3,1),
        printNormImg(rFrame, 'Right Word');
        subplot(2,3,2),
        printNormImg(uFrame, 'Up Word');
        subplot(2,3,3),
        printNormImg(lFrame, 'Left Word');
        subplot(2,3,4),
        printNormImg(dFrame, 'Down Word');
        subplot(2,3,5),
        printNormImg(sFrame, 'Static Word');
        subplot(2,3,6),
        printNormImg(mFrame, 'All Motion Words');
        
    otherwise
        % Do nothing, or whatever.
end

