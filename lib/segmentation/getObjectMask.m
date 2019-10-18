function [objMask, objGray] = getObjectMask(binaryMask, grayImage, boxProps)
for i = 1:size(boxProps,1)
    % crop every object in image
    objMask{i} = imcrop(binaryMask, boxProps(i,:));
    objGray{i} = imcrop(grayImage, boxProps(i,:));
end