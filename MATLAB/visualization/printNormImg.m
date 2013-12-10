function printNormImg(img, title)
	maxProb = max(img(:));

	normalizedImg = uint8(255 * img / maxProb);

	imshow(normalizedImg);
	text(10,size(img,1) + 30,strcat('Max: ',num2str(maxProb)));
	text(10,-30,title);
end

