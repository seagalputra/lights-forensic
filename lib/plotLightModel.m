clear; clc; close all;

load('2ObjectNoPostProcess.mat');

img = imread(imds.Files{3});
img = imresize(img, 0.5);

[obj, gray, mask, params] = imsegment(img, 'segType', 'meanshift', ...
    'SpatialBandWidth', 3, 'RangeBandWidth', 6.5, ...
    'gamma', 0.32);

for j = 1:size(obj,2)
    [light, degree(j,:), normals, vertices] = lightDirection(obj{j}, gray{j}, ...
        'modelType', 'complex');
    lights{j,:} = light;
end

%% plot light using sphere
lightCoeff = lights{1,:};
lightCoeff(6:9,:) = 0;

imshow(gray{1});
% plotLitSphere(lightCoeff);
shading = plotLitSphere2(lightCoeff, 4, 1);