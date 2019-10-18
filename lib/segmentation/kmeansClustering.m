function binaryMask = kmeansClustering(rgbImage, nColors, numReplicates, sizeThreshold)

% convert image into LAB color space
labImage = convertToLab(rgbImage);

ab = double(labImage(:,:,2:3));
nRows = size(ab,1);
nCols = size(ab,2);
ab = reshape(ab, nRows*nCols, 2);
% do clustering
clusterIdx = kmeans(ab, nColors, 'distance', 'sqEuclidean', ...
    'Replicates', numReplicates, 'Display', 'iter');
pixelLabels = reshape(clusterIdx, nRows, nCols);
% separate each label
for i = 1:nColors
    mask = zeros([size(rgbImage,1) size(rgbImage,2)]);
    mask(pixelLabels == i) = 1;
    binaryMask{i} = mask;
end
% find background mask
binaryMask = findBackground(binaryMask);
binaryMask = bwareaopen(binaryMask, sizeThreshold);