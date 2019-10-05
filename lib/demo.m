clear; clc; close all;
% Load image data and convert into grayscale
lenPlot = 10;
img = imread('../data/f1.JPG');
[obj, gray, out] = imsegment(img, 'nColors', 3);

% Calculate light source direction for every object
figure(1);
imshow(img);
hold on;
disp('Estimate light source direction...');
for i = 1:size(obj,2)
    L(i,:) = lightDirection(obj{i}, gray{i});
end
% plot light source direction
plotLightDirection(img, L, out.center, lenPlot);
