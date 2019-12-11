clear; clc; close all;

[filename, path] = uigetfile({'*.png;*.jpg;*.tif','Image Files'});

img = imread(fullfile(path, filename));
img = imresize(img, 0.5);
grayImage = rgb2gray(img);

[obj, gray, mask, params] = imsegment(img, ...
    'segType', 'meanshift', ...
    'SpatialBandWidth', 3, ...
    'RangeBandWidth', 6.5, ...
    'gamma', 0.32, ...
    'numberToExtract', 2, ...
    'sizeThreshold', 500);

lights = {};
for j = 1:size(obj,2)
    [light, degree(j,:), normals, vertices] = lightDirection(obj{j}, gray{j}, ...
        'modelType', 'complex');
    lights{end+1} = light;
end

% lights = {};
% imshow(img);
% hold on;
% for j = 1:size(obj,2)
%     [normals, vertices] = getSurfaceNormal(obj{j}, 10);
%     normals(isnan(normals)) = -1;
%     intBoundary = getIntensity(grayImage, normals, vertices, 15);
%     [theta, v] = getPrincipalLight(normals, intBoundary, 1);
%     lights{end+1} = v;
%     
%     line([params.center(j,1) params.center(j,1)+lights{j}(2,1)*20], [params.center(j,2) params.center(j,2)+lights{j}(3,1)*20], ...
%         'Color', 'red', 'LineWidth', 2);
% end

%% Plot light using sphere
firstCoeff = lights{1};
firstCoeff(6:9,:) = 0;

figure,
imshow(gray{1});
% plotLitSphere(firstCoeff);
shading = plotLitSphere2(firstCoeff, 4, 1);

secondCoeff = lights{2};
secondCoeff(6:9,:) = 0;

figure,
imshow(gray{2});
% plotLitSphere(secondCoeff);
shading = plotLitSphere2(secondCoeff, 4, 1);