clear; clc; close all;

%% Load image data and convert into grayscale
lenPlot = 10;
img = imread('../data/1.JPG');
[obj, gray, out] = imsegment(img);

%% Calculate light source direction for every object
imshow(img);
hold on;
disp('Estimate light source direction...');
for i = 1:size(obj,2)
    L = lightDirection(obj{i}, gray{i});
    % plot light source direction from center object
    line([out.center(i,1) out.center(i,1)+L(1)*lenPlot], [out.center(i,2) out.center(i,2)+L(2)*lenPlot], ...
        'Color', 'red', 'LineWidth', 2);
end
% rectangle('Position', [boxProps(i,1), boxProps(i,2), boxProps(i,3), boxProps(i,4)], ...
%     'EdgeColor', 'r', 'LineWidth', 2);
