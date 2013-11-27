function imageStack = generateImageStack(baseName, ext, numFiles) 
    for i = 1:length(newFiles)
        imageStack(:,:,i) = imread(strcat(baseName, num2str(i), ext));
    end
end