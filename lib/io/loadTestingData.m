clear; clc; close all;

path = '../../data_pengujian';
listFolder = dir(path);

for i = 3:size(listFolder,1)
    disp(listFolder(i).name);
    
    % iterate to every sub folder
    subPath = fullfile(listFolder(i).folder, listFolder(i).name);
    listSubFolder = dir(subPath);
    
    for j = 3:size(listSubFolder,1)
        disp(listSubFolder(j).name);
        
        % using image datastore to load image into memory
        imds = imageDatastore(fullfile(listSubFolder(j).folder, listSubFolder(j).name), ...
            'IncludeSubfolders', true, 'LabelSource', 'foldernames');
        
        % save datastore to specific folder
        save(fullfile('datastore', 'pengujian', listFolder(i).name ,strcat(listSubFolder(j).name, '-lights-', listFolder(i).name, '.mat')), 'imds');
    end
end