function videoStack = loadVideoGreyscale(folderLoc, root, nFiles)
    if isempty(folderLoc)
        folderLoc = pwd; 
    end
    
    for i = 1:nFiles
        fileName = cat(2,folderLoc,'/',root,num2str(i),'.tiff');
        
        gray = rgb2gray(imread(fileName));
        videoStack(:,:,i) = gray(:,:,1);
    end
end

