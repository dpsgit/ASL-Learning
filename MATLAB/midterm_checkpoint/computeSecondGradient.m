function [g2x, g2y, g2t] = computeSecondGradient(threedmat)
    % assume to be x by y by t
    
    x1Filter(:,:,1) = [0 0 0;
                       0 0 0;
                       0 0 0];
                  
    x1Filter(:,:,2) = [0, 0, 0;
                       -1, 0, 1;
                       0, 0, 0]; % apply to (:,:,i)
    x1Filter(:,:,3) = [0 0 0;
                       0 0 0;
                       0 0 0];
                   
    y1Filter = permute(x1Filter,[2 1 3]); % apply to (:,:,i)
    t1Filter = permute(x1Filter,[3 1 2]); % apply to (i,:,:)
    
    x2Filter(:,:,1) = [-1 0 1;
                       0 0 0;
                       1 0 -1];
    x2Filter(:,:,2) = [0 0 0;
                       0 0 0;
                       0 0 0];
    x2Filter(:,:,3) = [1 0 -1;
                       0 0 0;
                       -1 0 1];
    
    y2Filter = permute(x2Filter,[2 1 3]);
    t2Filter = permute(x2Filter,[3 1 2]); 
    
    g1x = convn(threedmat,x1Filter);
    g1y = convn(threedmat,y1Filter);
    g1t = convn(threedmat,t1Filter);
    
    g2x = convn(g1x,x2Filter);
    g2y = convn(g1y,y2Filter);
    g2t = convn(g1t,t2Filter);    
end