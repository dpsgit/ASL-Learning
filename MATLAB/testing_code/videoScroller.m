function videoScroller(videoStack)
% Parameters
	WIDTH_PER_FRAME = 5;
	BOTTOM_MARGIN = 20;
	SLIDER_HEIGHT = 10;

	% codez
	nFrames = size(videoStack,3);
	sliderWidth = WIDTH_PER_FRAME * nFrames;

	S.stack = videoStack;

	S.fh = figure('units','pixels',...
	              'position',[600 600 600 400],...
	              'menubar','none',...
	              'name','Sign identification',...
	              'numbertitle','off',...
	              'resize','off');
	S.sl = uicontrol('style','slide',...
	                 'unit','pix',...
	                 'position',[170 10 260 30],...
	                 'min',1,'max',nFrames,'val',1);    
	set(S.sl,'call',{@ed_call,S});  % Shared Callback.

	S.fNum = 1;
	imshow(videoStack(:,:,S.fNum));
	text(10,20,num2str(S.fNum));

function [] = ed_call(varargin)
% Callback for the edit box and slider.
[h,S] = varargin{[1,3]};  % Get calling handle and structure.

switch h  % Who called?
    case S.sl
        S.fNum = round(get(S.sl,'value'));
        set(S.sl,'value',S.fNum);
        figure(S.fh);
        imshow(S.stack(:,:,S.fNum));
        text(10,20,num2str(S.fNum));
    otherwise
        % Do nothing, or whatever.
end