clear; clc; close all;

%% load image data
[filename, path] = uigetfile({'*.png;*.jpg;*.tif','Image Files'});
img = imread(fullfile(path,filename));

%% Load image data
img = imresize(img, 0.25);

%% image segmentation
disp('Segmentasi gambar...');
[obj, gray, mask, out] = imsegment(img, 'segType', 'meanshift', ...
    'SpatialBandWidth', 3, 'RangeBandWidth', 6.5, 'gamma', 0.32);

%% Do local light source detection
% PARAMETER
disp('Estimasi arah sumber cahaya...');
lenPlot = 1;
threshold = 30;
listLight = [];
for numObj = 1:size(obj,2)
    [light, degree(numObj,:), normals, vertices] = lightDirection(obj{numObj}, ...
        gray{numObj}, 'modelType', 'local');
    
    localLight(numObj,:) = light;
    listLight = [listLight, light];
    
    % plot every surface normal
    figure(1);
    subplot(1,size(obj,2),numObj);
    imshow(gray{numObj});
    hold on;
    plot([vertices(:,1) vertices(:,1)+10*normals(:,1)]', [vertices(:,2) vertices(:,2)+10*normals(:,2)]');
end

%% Check the angle between two object.
% If below threshold, then the image is authentic. If not, then the image
% is not authentic.
possibleDegree = nchoosek(degree,2);
diffLight = abs(possibleDegree(:,2) - possibleDegree(:,1));
nonAuth = find(diffLight > threshold);
if (isempty(nonAuth) == 0)
    % forgery label
    predict = 0;
    label = 'Forgery';
else
    % authentic label
    predict = 1;
    label = 'Authentic';
end
disp(['Hasil Prediksi : ', label]);

%% Plot and save current figure
% plot light direction
figure(2);
plotLightDirection(img, localLight, out.center, label);