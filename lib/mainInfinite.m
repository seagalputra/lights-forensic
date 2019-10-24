clear; clc; close all;

% Load image data and convert into grayscale
lenPlot = 1;
img = imread('../data/1_L3.jpg');
img = imresize(img, 0.25);

disp('Image segmentation..');
[obj, gray, mask, out] = imsegment(img, 'segType', 'meanshift', ...
    'SpatialBandWidth', 2, 'RangeBandWidth', 2.4);

%% Calculate light source direction for every object
% Infinite light source model
disp('Estimate light source direction...');
for i = 1:size(obj,2)
    L(i,:) = lightDirection(obj{i}, gray{i});
end
% plot light source direction
plotLightDirection(img, L, out.center);