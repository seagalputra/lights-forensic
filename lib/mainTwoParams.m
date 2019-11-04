% load two object authentic image path
clear; clc; close all;
load('../../testing/twoObjAuthentic.mat');

%% Load every single light ID
% define light ID want to observe
ID = 'L4';
% PARAMETER
threshold = 5:5:60;
lenData = size(twoObjAuth,1);

for numThreshold = 1:size(threshold,2)
disp(['Threshold - ', num2str(threshold(numThreshold))]);

for i = 1:lenData
disp(['Calculating object-', num2str(i)]);
img = imread(twoObjAuth(i).(ID));
img = imresize(img, 0.5);

actual = strsplit(twoObjAuth(i).(ID), '\');
actual = actual{7};
if (strcmp(actual, 'authentic'))
    label(i,:) = 1;
else
    label(i,:) = 0;
end

% segment image using meanshift
[obj, gray, mask, out] = imsegment(img, 'segType', 'meanshift', ...
    'SpatialBandWidth', 3, 'RangeBandWidth', 6.5, 'gamma', 0.32);

% do local light source detection
for numObj = 1:size(obj,2)
    [localLight(numObj,:), degree(numObj,:), normals, vertices] = lightDirection(obj{numObj}, ...
        gray{numObj}, 'modelType', 'local');
end

% check the angle between two object
possibleDegree = nchoosek(degree,2);
diffLight = abs(possibleDegree(:,2) - possibleDegree(:,1));
nonAuth = find(diffLight > threshold(numThreshold));
if (isempty(nonAuth))
    predict(i,:) = 1;
    title = 'Authentic';
else
    predict(i,:) = 0;
    title = 'Forgery';
end
% don't forget to save the figure
figDir = fullfile('../../testing/figure/light/', ID);
if (size(dir(figDir),1) < lenData+2)
    figure(1);
    plotLightDirection(img, localLight, out.center, title);
    saveas(gca, fullfile(figDir, strcat(num2str(i), '.jpg')));
    close all;
end
clear localLight degree;
end

%% calculating the accuracy
rightLabel = label == predict;
accuracy = sum(rightLabel) / size(label,1);
disp(['Akurasi : ', num2str(accuracy)]);

listAccuracy(numThreshold) = accuracy;
% clc;
end

%% Store data into excel format