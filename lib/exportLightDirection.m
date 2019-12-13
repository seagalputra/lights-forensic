clear; clc; close all;

% path = 'pengujian\all\sumber_cahaya\*.mat';
% path = 'pengujian\all\rotasi\*.mat';
path = 'pengujian\all\scaling\*.mat';

listData = dir(path);
for numData = 1:size(listData,1)
    disp(['Assesing file : ', listData(numData).name]);
    % load every observation data
    load(fullfile(listData(numData).folder, listData(numData).name));
    
    for i = 1:size(imds.Files,1)
        disp(num2str(i));
        % load image
        filePath = imds.Files{i};
        img = imread(filePath);
        img = imresize(img, 0.5);
        grayImage = rgb2gray(img);

        % segement image using meanshift
        [obj, gray, mask, params] = imsegment(img, ...
            'segType', 'meanshift', ...
            'SpatialBandWidth', 3, ...
            'RangeBandWidth', 6.5, ...
            'gamma', 0.32, ...
            'numberToExtract', 2, ...
            'sizeThreshold', 500);
    
        % calculate complex lighting environment
%         lights = {};
%         listDegree = [];
%         for j = 1:size(obj,2)
%             [light, degree, normals, vertices] = lightDirection(obj{j}, gray{j}, ...
%                 'modelType', 'complex');
%             lights{end+1} = light;
%             listDegree = [listDegree; degree];
%         end
        
        % calculate principal light direction
        lights = {};
        imshow(img);
        hold on;
        for j = 1:size(obj,2)
            [normals, vertices] = getSurfaceNormal(obj{j}, 10);
            normals(isnan(normals)) = -1;
            intBoundary = getIntensity(grayImage, normals, vertices, 15);
            [theta, v] = getPrincipalLight(normals, intBoundary, 1);
            lights{end+1} = v;
    
            line([params.center(j,1) params.center(j,1)+lights{j}(2,1)*20], [params.center(j,2) params.center(j,2)+lights{j}(3,1)*20], ...
                'Color', 'red', 'LineWidth', 2);
        end
        
        fileSplit = strsplit(filePath, '\');
        pathSplit = strsplit(path, '\');
        folder = pathSplit{3};
        subfolder = listData(numData).name;
        filename = fileSplit{end};
        
        saveas(gca, fullfile('..\..\lightDirection', folder, subfolder, lower(filename)));
        close all;
    end
end