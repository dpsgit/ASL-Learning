function videoScroller(videoStack)
	% Parameters
	WIDTH_PER_FRAME = 5;
	BOTTOM_MARGIN = 20;
	SLIDER_HEIGHT = 10;

	% codez
	nFrames = size(videoStack,1);
	sliderWidth = WIDTH_PER_FRAME * nFrames;

	fg = figure;
	figPosition = get(fg,'Position');
	figWidth = figPosition(3);

	slider = uicontrol('slider',0,'Max',nFrames,'Position',[(figWidth - sliderWidth) / 2 BOTTOM_MARGIN sliderWidth SLIDER_HEIGHT]);
	set(slider,'Callback',@updateImage);

	imshow(videoStack(:,:,1));
end

function updateImage()
end
