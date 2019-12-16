clear; clc; close all;

path = '../../data_pengujian';
listFolder = cellstr(ls(path));

for i = 1:size(listFolder,1)
    if ~(strcmp(listFolder{i}, '.') || strcmp(listFolder{i}, '..'))
        % iterate every data in every folder
        currentPath = fullfile(path, listFolder{i});
        listSubFolders = cellstr(ls(currentPath));
        
        for j = 1:size(listSubFolders,1)
            subFolder = listSubFolders{j};
            
            if ~(strcmp(listSubFolders{j}, '.') || strcmp(listSubFolders{j}, '..'))
                currentSubFolders = fullfile(currentPath, subFolder);
                disp(currentSubFolders);
                
                testing = imageDatastore(currentSubFolders, ...
                    'IncludeSubfolders', true, ...
                    'LabelSource', 'foldernames');
                
                labelCounter = countEachLabel(testing);
                disp(labelCounter);
                
                switch listFolder{i}
                    case 'rotasi'
                        save(fullfile('datastore/pengujian/rotasi', strcat(subFolder, '-lights-', 'rotasi.mat')), 'testing');
                    case 'scaling'
                        save(fullfile('datastore/pengujian/scaling', strcat(subFolder, '-lights-', 'scaling.mat')), 'testing');
                end
            end
        end
    end
end