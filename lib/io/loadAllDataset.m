clear; clc; close all;

path = '..\..\data_pengujian';
listFolder = dir(path);

% iterasi tiap-tiap folder pada list folder
for i = 3:size(listFolder,1)
    folderName = listFolder(i).name;
    filePath = fullfile(listFolder(i).folder, folderName);
    imds = imageDatastore(filePath, 'IncludeSubFolders', true, 'LabelSource', 'foldernames');
    
    % simpan data ke folder
    save(fullfile('datastore\all', folderName), 'imds');
end