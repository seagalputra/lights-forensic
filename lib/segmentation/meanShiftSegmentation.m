function mask = meanShiftSegmentation(rgbImage, spatialBandWidth, rangeBandWidth, sizeThreshold)

% segment using mean shift
[~, labels] = edison_wrapper(rgbImage, @RGB2Luv, 'SpatialBandWidth', ...
    spatialBandWidth, 'RangeBandWidth', rangeBandWidth);

% convert labels into binary logical image
BW = logical(labels);
% clean up little binary mask
mask = bwareaopen(BW, sizeThreshold);