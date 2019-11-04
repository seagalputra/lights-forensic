clear; clc; close all;

load('../../testing/twoObjAuthentic.mat');

ID = 'L1';
img = imread(twoObjAuth(1).(ID));
% img = rgb2gray(img);
% imtool(img);

% SLIC image segmentation
[labels, numLabels] = superpixels(img, 200);

figure,
BW = boundarymask(labels);
imshow(imoverlay(img,BW,'cyan'), 'InitialMagnification', 67);

outputImage = zeros(size(img),'like',img);
% group label image into specific group
idx = label2idx(labels);
nRows = size(img,1);
nCols = size(img,2);
for labelVal = 1:numLabels
    redIdx = idx{labelVal};
    greenIdx = idx{labelVal}+nRows*nCols;
    blueIdx = idx{labelVal}+2*nRows*nCols;
    outputImage(redIdx) = mean(img(redIdx));
    outputImage(greenIdx) = mean(img(greenIdx));
    outputImage(blueIdx) = mean(img(blueIdx));
end

%% perform image segmentation using kmeans
outputImage = double(outputImage);
feature = reshape(outputImage, nRows*nCols, 3);

nCluster = 3;
numReplicates = 3;
clusterIdx = kmeans(feature, nCluster, 'distance', 'sqEuclidean', ...
    'Replicates', numReplicates, 'Display', 'iter');
pixelLabels = reshape(clusterIdx, nRows, nCols);

% separate each label
for i = 1:nCluster
    mask = zeros([size(img,1) size(img,2)]);
    mask(pixelLabels == i) = 1;
    binaryMask{i} = mask;
    
    subplot(1,nCluster,i);
    imshow(mask);
end
% figure,
% imshow(outputImage, 'InitialMagnification', 67);