function [dsCornerArray, timeIndices] = FAST(videoArray, dsFactor)


% --------- Original video ----------

[m, n, l] = size(videoArray);

boxFilter = (1/9)*ones(5, 5);

for i = 1:l
    dsVideoArray(:,:,i) = conv2((double(videoArray(:,:,i))), boxFilter, 'full');
end

dsVideoArray = uint8(videoArray);

%{
cornerArray = []; % ? x 3

% yt channel
for x = 1:n
    corners = detectFASTFeatures(squeeze(videoArray(:, x, :)));
    xDim = x*ones(size(corners, 1), 1);
    cornerArray = vertcat(cornerArray, horzcat(corners.Location(:,2), xDim, corners.Location(:,1))); % Want a ROI here?
end

% xt channel
for y = 1:m
    corners = detectFASTFeatures(squeeze(videoArray(y, :, :)));
    yDim = y*ones(size(corners, 1), 1);
    cornerArray = vertcat(cornerArray, horzcat(yDim, corners.Location(:, 2), corners.Location(:, 1))); % Want a ROI here?
end

% xy channel
for t = 1:l
    corners = detectFASTFeatures(squeeze(videoArray(:, :, t)));
    tDim = t*ones(size(corners, 1), 1);
    cornerArray = vertcat(cornerArray, horzcat(corners.Location(:,2), corners.Location(:,1), tDim)); % Want a ROI here?
end 
%}

% --------- Downsampled video ----------

[dsM, dsN, dsL] = size(dsVideoArray);

dsCornerArray = []; % ? x 3

% yt channel
for x = 1:dsN;
    dsCorners = detectFASTFeatures(uint8(squeeze(dsVideoArray(:, x, :))));
    xDim = x*ones(size(dsCorners, 1), 1);
    dsCornerArray = vertcat(dsCornerArray, horzcat(dsCorners.Location(:,2), xDim, dsCorners.Location(:,1))); % Want a ROI here?
end

% xt channel
for y = 1:dsM;
    dsCorners = detectFASTFeatures(squeeze(dsVideoArray(y, :, :)));
    yDim = y*ones(size(dsCorners, 1), 1);
    dsCornerArray = vertcat(dsCornerArray, horzcat(yDim, dsCorners.Location(:, 2), dsCorners.Location(:, 1))); % Want a ROI here?
end

% xy channel
for t = 1:dsL;
    dsCorners = detectFASTFeatures(squeeze(dsVideoArray(:, :, t)));
    tDim = t*ones(size(dsCorners, 1), 1);
    dsCornerArray = vertcat(dsCornerArray, horzcat(dsCorners.Location(:,2), dsCorners.Location(:,1), tDim)); % Want a ROI here?
end
    
%cornerArray = intersect(dsCornerArray, cornerArray, 'rows');

end