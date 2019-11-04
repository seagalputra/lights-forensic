%% load image path
clear; clc; close all;
load('../data/dataset.mat');

%% Load image data
for i = 1:size(twoObj.Files,1)
disp(['Calculating object-', num2str(i)]);
[img, imgInfo] = readimage(twoObj, i);
img = imresize(img, 0.25);

% save actual label
label(i,:) = imgInfo.Label;
% save filename
name = split(imgInfo.Filename, '\');
name = name{end};
% remove filename extensions
filename = split(name, '.');
filename = filename{1};
listFilename{i,:} = filename;

%% image segmentation
[obj, gray, mask, out] = imsegment(img, 'segType', 'meanshift', ...
    'SpatialBandWidth', 3, 'RangeBandWidth', 6.5, 'gamma', 0.32);

%% Do local light source detection
% PARAMETER
lenPlot = 1;
threshold = 30;
% listLight = [];
for numObj = 1:size(obj,2)
    % disp(['Assesing object ', num2str(numObj)]);
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
    % saving current figure
    saveas(gca, fullfile('../data/figure/normals/2', strcat(num2str(i), '.jpg')));
end

% featureLight{i,:} = listLight;
%% Check the angle between two object.
% If below threshold, then the image is authentic. If not, then the image
% is not authentic.
possibleDegree = nchoosek(degree,2);
diffLight = abs(possibleDegree(:,2) - possibleDegree(:,1));
nonAuth = find(diffLight > threshold);
if (isempty(nonAuth) == 0)
    % forgery label
    predict(i,:) = 0;
else
    % authentic label
    predict(i,:) = 1;
end

%% Plot and save current figure
% plot light direction
figure(2);
plotLightDirection(img, localLight, out.center, filename);
saveas(gca, fullfile('../data/figure/light/2', strcat(num2str(i), '.jpg')));

% clearing variable
clear localLight degree; 
close all;
end
%% Calculating the accuracy
rightLabel = label == predict;
accuracy = sum(rightLabel) / size(label,1);
disp(['Akurasi : ', num2str(accuracy)]);

%% Creating table to store information
tblInfo = table(listFilename, label, predict);
% Save table to excel format
writetable(tblInfo, strcat('../data/lightInfo2Object-',num2str(threshold),'.xlsx'));