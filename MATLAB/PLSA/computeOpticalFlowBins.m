function [flowRight, flowUp, flowLeft, flowDown, flowStatic] = computeOpticalFlowBins(videoStack, staticThresh)
    % videoStack - a hxwxf matrix
    % Returns: 
    %   flowBins - a hxwx(f-1) matrix
    
    [h, w, nFrames] = size(videoStack);
    
    flowRight = zeros(h,w,nFrames - 1);
    flowUp = zeros(h,w,nFrames - 1);
    flowLeft = zeros(h,w,nFrames - 1);
    flowDown = zeros(h,w,nFrames - 1);
    
    flowStatic = zeros(h,w,nFrames - 1);
    
    for i = 1:nFrames - 1
        [u, v] = HS(videoStack(:,:,i),videoStack(:,:,i+1));
        
        flowRight(:,:,i) = u > 0 & abs(u) <= abs(v);
        flowUp(:,:,i) = v > 0 & abs(v) < abs(u);
        flowLeft(:,:,i) = u < 0 & abs(u) <= abs(v);
        flowDown(:,:,i) = v < 0 & abs(v) < abs(u);
        
        flowStatic(:,:,i) = u.^2 + v.^2 < staticThresh ^2;
        
    end
    
    % remove the regions that are static from the other flows
    flowRight = flowRight & ~flowStatic;
    flowUp = flowUp & ~flowStatic;
    flowLeft = flowLeft & ~flowStatic;
    flowDown = flowDown & ~flowStatic;
end

