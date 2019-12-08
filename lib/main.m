clear; clc; close all;

load('2LightsNoPostprocess.mat');

predicts = [];
probability = [];
for i = 1:size(imds.Files,1)
    disp(num2str(i));
    % load image
    img = imread(imds.Files{i});
    img = imresize(img, 0.5);

    % segement image using meanshift
    [obj, gray, mask, params] = imsegment(img, ...
        'segType', 'meanshift', ...
        'SpatialBandWidth', 3, ...
        'RangeBandWidth', 6.5, ...
        'gamma', 0.32, ...
        'numberToExtract', 2, ...
        'sizeThreshold', 500);
    
    % calculate complex lighting environment
    lights = {};
    listDegree = [];
    for j = 1:size(obj,2)
        [light, degree, normals, vertices] = lightDirection(obj{j}, gray{j}, ...
            'modelType', 'complex');
        lights{end+1} = light;
        listDegree = [listDegree; degree];
    end
    
    % compute correlation between several lighting condition
    possibleLights = nchoosek(lights,2);
    for numLight = 1:size(possibleLights,1)
        corrLight(numLight,:) = getCorrelation(possibleLights{numLight,1}, possibleLights{numLight,2});
    end
    
    % compute different between principal light direction
    % possibleDegree = nchoosek(degree,2);
    possibleDegree = nchoosek(listDegree,2);
    diffLight = abs(possibleDegree(:,2) - possibleDegree(:,1));
    
    % membership function 1
    degreeCorrelation(1) = sigmoidLeft(corrLight, 0.35, 0.5, 0.65); % low
    degreeCorrelation(2) = sigmoidRight(corrLight, 0.4, 0.65, 0.8); % high
        
    % membership function 2
    degreeTheta(1) = sigmoidLeft(diffLight, 45, 57, 92); % low
    degreeTheta(2) = sigmoidRight(diffLight, 81, 105, 135); % high
    
    [predicted, degreeForgery, degreeAuthentic] = rule(degreeCorrelation, degreeTheta);
    predicts = [predicts; predicted];
    probability = [probability; degreeForgery, degreeAuthentic];
end

%% create performance model analysis using ROC curve
confMatrix = confusionmat(imds.Labels, predicts);
TP = confMatrix(1,1);
FP = confMatrix(1,2);
FN = confMatrix(2,1);
TN = confMatrix(2,2);
% Accuracy
disp(['Accuracy                     : ', num2str(100*(TP+TN)/(TP+TN+FP+FN)), ' %']);
% True Positive Rate
disp(['True Positive Rate           : ', num2str(100*TP/(TP+FN)), ' %']);
% True Negative Rate
disp(['True Negative Rate           : ', num2str(100*TN/(TN+FP)), ' %']);
% False Positive Rate
disp(['False Positive Rate          : ', num2str(100*FP/(FP+TN)), ' %']);
% False Negative Rate
disp(['False Negative Rate          : ', num2str(100*FN/(FN+TP)), ' %']);
% Positive Predictive Value
disp(['Positive Predictive Value    : ', num2str(100*TP/(TP+FP)), ' %']);
% Negative Predictive Value
disp(['Negative Predictive Value    : ', num2str(100*TN/(TN+FN)), ' %']);
% False Discovery Rate
disp(['False Discovery Rate         : ', num2str(100*FP/(FP+TP)), ' %']);
% False Omission Rate
disp(['False Omission Rate          : ', num2str(100*FN/(FN+TN)), ' %']);

c = linspace(0,1);
[FPR, TPR, T, AUC] = perfcurve(imds.Labels, probability(:,2), 1);
plot(c,c,'--');
hold on;
plot(FPR, TPR, 'LineWidth', 2);

%% Generate report table
varNames = {'Filename', 'Label', 'Prediction'};
listFilename = imds.Files;
listLabels = imds.Labels;
reportTable = table(listFilename, listLabels, predicts, 'VariableNames', varNames);