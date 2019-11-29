clear; clc; close all;

load('datasetAlt.mat');
% load('datasetObservation.mat');

% threshold = 60;
features = [];
% i = 295;
for i = 1:size(imds.Files,1)
    disp(['Estimating image - ', num2str(i)]);
    % load image
    img = imread(imds.Files{i});
    img = imresize(img, 0.5);

    % segement image using meanshift
    [obj, gray, mask, params] = imsegment(img, 'segType', 'meanshift', ...
        'SpatialBandWidth', 3, 'RangeBandWidth', 6.5, ...
        'gamma', 0.32, 'numberToExtract', 2);
    
    % calculate complex lighting environment
    for j = 1:size(obj,2)
        [light, degree(j,:), normals, vertices] = lightDirection(obj{j}, gray{j}, ...
            'modelType', 'complex');
        lights{j,:} = light;
    end
    
    % compute correlation between several lighting condition
    possibleLights = nchoosek(lights,2);
    for numLight = 1:size(possibleLights,1)
        corrLight(numLight,:) = getCorrelation(possibleLights{numLight,1}, possibleLights{numLight,2});
    end
    % mean of several correlation light
    % avgCorrLight = mean(corrLight);
    
    % compute different between principal light direction
    possibleDegree = nchoosek(degree,2);
    diffLight = abs(possibleDegree(:,2) - possibleDegree(:,1));
    % avgDiffLight = mean(diffLight);
    
    for numFeatures = 1:size(diffLight,1)
        % membership function 1
        degreeCorrelation(1) = sigmoidLeft(corrLight(numFeatures,:), 0.35, 0.5, 0.65); % low
        degreeCorrelation(2) = sigmoidRight(corrLight(numFeatures,:), 0.4, 0.65, 0.8); % high
        
        % membership function 2
        degreeTheta(1) = sigmoidLeft(diffLight(numFeatures,:), 45, 57, 92); % low
        degreeTheta(2) = sigmoidRight(diffLight(numFeatures,:), 81, 105, 135); % high
        
        % predict using rule
        tempPredicts(numFeatures,:) = rule(degreeCorrelation, degreeTheta);
    end
    
    nonAuth = find(tempPredicts == 0);
    if (isempty(nonAuth))
        predicts(i,:) = 1;
    else
        predicts(i,:) = 0;
    end
    
    % using rule to classify the image is authentic or not
    % membership function 1 (correlation)
    % degreeCorrelation(1) = sigmoidLeft(corrLight, 0.35, 0.5, 0.65); % low
    % degreeCorrelation(2) = sigmoidRight(corrLight, 0.4, 0.65, 0.8); % high
    % membership function 2 (theta)
    % degreeTheta(1) = sigmoidLeft(diffLight, 45, 57, 92); % low
    % degreeTheta(2) = sigmoidRight(diffLight, 81, 105, 135); % high
    % predict using rule
    % predicts(i,:) = rule(degreeCorrelation, degreeTheta);
    
    % store feature into matrix
    % features = [features; avgCorrLight avgDiffLight imds.Labels(i)];
    % features = [features; corrLight, diffLight, imds.Labels(i)];
    
%     nonAuth = find(diffLight > threshold);
%     if (isempty(nonAuth))
%         predicts(i,:) = 1;
%     else
%         predicts(i,:) = 0;
%     end
end

rightLabel = imds.Labels == predicts;
accuracy = sum(rightLabel) / size(imds.Labels,1);
disp(['Akurasi : ', num2str(accuracy)]);
% save('featuresAlt.mat', 'features', 'imds');

%% Generate report table
varNames = {'Filename', 'Label', 'Prediction'};
listFilename = imds.Files;
listLabels = imds.Labels;
reportTable = table(listFilename, listLabels, predicts, 'VariableNames', varNames);
save('reportObservation.mat', 'reportTable', 'accuracy');