clear; clc; close all;

% path = 'pengujian\all\sumber_cahaya\*.mat';
% path = 'pengujian\all\rotasi\*.mat';
path = 'pengujian\all\scaling\*.mat';

listData = dir(path);
for numData = 1:size(listData,1)
    disp(['Assesing file : ', listData(numData).name]);
    % load every observation data
    load(fullfile(listData(numData).folder, listData(numData).name));
    
    % call main logic here
    for i = 1:size(imds.Files,1)
        disp(num2str(i));
        % load image
        filePath = imds.Files{i};
        img = imread(filePath);
        img = imresize(img, 0.5);

        % segement image using meanshift
        [obj, gray, mask, params] = imsegment(img, ...
            'segType', 'meanshift', ...
            'SpatialBandWidth', 3, ...
            'RangeBandWidth', 6.5, ...
            'gamma', 0.32, ...
            'numberToExtract', 2, ...
            'sizeThreshold', 500);
        
        fileSplit = strsplit(filePath, '\');
        pathSplit = strsplit(path, '\');
        folder = pathSplit{3};
        filename = fileSplit{end};
        subfolder = listData(numData).name;
        imwrite(mask, fullfile('binaryMask', folder, subfolder, lower(filename)));
    end
end