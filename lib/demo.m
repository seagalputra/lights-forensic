clear; clc; close all;

%% Load image data and convert into grayscale
lenPlot = 10;
img = imread('../data/1.JPG');
[obj, gray, out] = imsegment(img);

%% Calculate light source direction for every object
figure(1);
imshow(img);
hold on;
disp('Estimate light source direction...');
L = cellfun(@(obj, gray) lightDirection(obj, gray), obj, gray, 'UniformOutput', false);
L = cell2mat(L);
% plot light source direction
plotLightDirection(img, L, out.center, lenPlot);
