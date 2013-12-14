function [processedStack] = bg_subtract(videoStack, backgroundThresh, staticThresh)
    % #DEPRECATED

%UNTITLED Summary of this function goes here
    % backgroundThresh: On a per pixel basis through the video, at least
    % backgroundThresh (percent) of those pixels must be static in order
    % for it that pixel to be called background throughout.

    background = zeros(size(videoStack));
    nFrames = size(videoStack, 3);
    
    for i = 1:nFrames-1
        i
        [u, v] = HS(videoStack(:, :, i), videoStack(:, :, i+1));
        background(:, :, i) = background(:, :, i) + ((u.^2 + v.^2) < staticThresh^2);
    end
    
    staticBackground = sum(background, 3) ./ nFrames;

    staticBackground = round(uint8(staticBackground > backgroundThresh));

    processedStack = zeros(size(videoStack));
    for i = 1:nFrames
        processedStack(:, :, i) = videoStack(:, :, i) - (videoStack(:, :, i) .* staticBackground);
    end
    
    processedStack = uint8(processedStack);

end