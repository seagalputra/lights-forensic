clear; clc; close all;

listData = dir('observationData/*.mat');
for numData = 1:size(listData,1)
    disp(['Assesing file : ', listData(numData).name]);
    % load every observation data
    load(fullfile(listData(numData).folder, listData(numData).name));
    
    features = [];
    for i = 1:size(imds.Files,1)
        disp(num2str(i));
    
        % load image data
        img = imread(imds.Files{i});
        img = imresize(img, 0.5);
    
        % segment image using meanshift segmentation
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
        possibleDegree = nchoosek(listDegree,2);
        diffLight = abs(possibleDegree(:,2) - possibleDegree(:,1));
    
        features = [features; corrLight, diffLight];
    end

    filename = imds.Files;
    labels = imds.Labels;
    save(fullfile('features', listData(numData).name), 'filename', 'features', 'labels'); 
end