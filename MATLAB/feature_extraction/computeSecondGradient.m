function [g2x g2y g2t] = computeSecondGradient(threedmat)
    % assume to be x by y by t
    g1x = 0 .* threedmat;
    g1y = 0 .* threedmat;
    g1t = 0 .* threedmat;
    
    xFilter = [0, 0, 0;
               -1, 0, 1;
               0, 0, 0];
    yFilter = [0, -1, 0;
               0, 0, 0;
               0, 1, 0];  
    tFilter = [0, 0, 0;
               -1, 0, 1;
               0, 0, 0];  
   
    for i = 1:size(threedmat,3)
        g1x = conv2(threedmat(:,:,i),xFilter);
        g1y = conv2(threedmat(:,:,i),yFilter);
        g1t = conv2(threedmat(i,:,:),tFilter);
    end
    
end