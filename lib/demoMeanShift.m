clear; clc; close all;

img = imread('../../data/1.JPG');
img = imresize(img, 0.5);

bandwidth = 0.1;
nRows = size(img,1);
nCols = size(img,2);
% convert image into LAB color space
img = convertToLab(img);
% obtain only a*b channel
img = im2double(img(:,:,2:3));
% using color for segmentation
C = reshape(img, nRows*nCols, 2);
% cluster using MeanShift
[clusterCenter, ~, clusterMember] = MeanShiftCluster(C', bandwidth);
% fill cluster with color of cluster center
for i = 1:length(clusterMember)
    X(clusterMember{i},:) = repmat(clusterCenter(:,i)',size(clusterMember{i},2),1);
end
I = reshape(X,nRows,nCols,2);
K = length(clusterMember);

subplot(121), imshow(I(:,:,1));
subplot(122), imshow(I(:,:,2));