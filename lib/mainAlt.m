% load two object authentic image path
clear; clc; close all;
load('datasetAlt.mat');

threshold = [35,40,45,50];

for numThreshold = 1:size(threshold,2)
disp(['Calculating threshold : ', num2str(threshold(numThreshold))]);
for i = 1:size(imds.Files,1)
    disp(['Calculating image - ', num2str(i)]);
    img = imread(imds.Files{i});
    % resize image into half size
    img = imresize(img, 0.5);
    
    % segment image using meanshift
    [obj, gray, mask, params] = imsegment(img, 'segType', 'meanshift', ...
        'SpatialBandWidth', 3, 'RangeBandWidth', 6.5, 'gamma', 0.32);
    
    % local light source detection
    for j = 1:size(obj,2)
        [lights(j,:), degree(j,:), normals, vertices] = lightDirection(obj{j}, ...
            gray{j}, 'modelType', 'local');
    end
    
    % check the angle between two object
    possibleDegree = nchoosek(degree,2);
    diffLight = abs(possibleDegree(:,2) - possibleDegree(:,1));
    nonAuth = find(diffLight > threshold(numThreshold));
    if (isempty(nonAuth))
        % authentic label
        predicts(i,:) = 1;
    else
        % forgery label
        predicts(i,:) = 0;
    end
end

% calculating accuracy
rightLabel = imds.Labels == predicts;
accuracy = sum(rightLabel) / size(imds.Labels,1);
disp(['Akurasi : ', num2str(accuracy)]);

% saving accuracy report into table
listAccuracy(numThreshold) = accuracy;
end

tblAccuracy = table(threshold', listAccuracy', 'VariableNames', {'Threshold', 'ListAccuracy'});
save('accuracyAlt.mat', 'tblAccuracy', 'imds');