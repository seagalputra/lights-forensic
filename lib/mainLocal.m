%% load image path
clear; clc; close all;
load('../data/dataset.mat');

%% Load image data
[img, imgInfo] = readimage(twoObj, 1);
img = imresize(img, 0.25);

% img = imadjust(img, [], [], 0.32);

disp('Image segmentation..');
[obj, gray, mask, out] = imsegment(img, 'segType', 'meanshift', ...
    'SpatialBandWidth', 3, 'RangeBandWidth', 6.5);

% subplot(121), imshow(img), title('Original Image');
% subplot(122), imshow(mask), title('Mask Image');

%% Do local light source detection
% first thing to do, calculate the initial lighting direction by solving
% the equation (7) from the paper.

% PARAMETER
lenPlot = 1;
threshold = 40;

for numObj = 1:size(obj,2)
    disp(['Assesing object ', num2str(numObj)]);
    [localLight(numObj,:), degree(numObj,:)] = lightDirection(obj{numObj}, gray{numObj}, 'modelType', 'local');
end
plotLightDirection(img, localLight, out.center);

%% Check the angle between two object.
% If below threshold, then the image is authentic. If not, then the image
% is not authentic.
possibleDegree = nchoosek(degree,2);
diffLight = abs(possibleDegree(:,2) - possibleDegree(:,1));
nonAuth = find(diffLight > threshold);
disp(diffLight);
if (isempty(nonAuth) == 0)
    disp('This image is forgery');
else
    disp('This image is authentic');
end