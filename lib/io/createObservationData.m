clear; clc; close all;

path = 'pengujian\all\sumber_cahaya\*.mat';

listData = dir(path);
for num = 1:size(listData,1)
    disp(['Split data for ', listData(num).name]);
    filename = listData(num).name;
    load(fullfile(listData(num).folder, filename));

    % split data each label
    [training, testing] = splitEachLabel(imds, 0.6);
    
    % save splitted dataset into folder
    save(fullfile('pengamatan', filename), 'training');
    save(fullfile('pengujian\final', filename), 'testing');
end
