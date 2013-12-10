function visualizeFAST(videoStack, factor)
    corners = FAST(videoStack, factor);
    scatter3(corners(:,1),corners(:,2),corners(:,3), 'r.');
    xlabel('X')
    ylabel('Y')
    zlabel('T')
end