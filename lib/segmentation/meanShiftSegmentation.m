function mask = meanShiftSegmentation(rgbImage, spatialBandWidth, rangeBandWidth)

% segment using mean shift
[~, labels] = edison_wrapper(rgbImage, @rgb2lab, 'SpatialBandWidth', ...
    spatialBandWidth, 'RangeBandWidth', rangeBandWidth);

% convert labels into binary logical image
BW = logical(labels);
% clean up little binary mask
mask = bwareaopen(BW, 500);