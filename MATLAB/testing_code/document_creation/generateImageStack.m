function imageStack = generateImageStack(directory, ext, toSmooth) 
    addpath('../PLSA/optical_flow');
	files = dir(directory);
	numNames = [];
    counter = 1;
    for i = 1:length(files)
    	if length(files(i).name) > length(ext) && ~isempty(findstr(files(i).name,ext))
    		image = imread(files(i).name);
    		if size(image,3) == 3
    			bwImage = rgb2gray(image);
    			image = bwImage(:,:,1);
    		end
            if toSmooth
                imageStack(:,:,counter) = smoothImg(image, 1);
            else
                imageStack(:,:,counter) = image;
            end 

            counter = counter + 1;
        	numNames = cat(1,numNames,str2num(regexprep(files(i).name,'[a-zA-Z.]','')));
        end
    end

    [~, sortedIndices] = sort(numNames);
    imageStack = imageStack(:,:,sortedIndices);
end