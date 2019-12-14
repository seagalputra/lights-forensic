clear; clc; close all;

% If you wanna load another data, please change this variable into specific
% path of your dataset folder.
path = '../../dataset';
listFolder = cellstr(ls(path));

for i = 1:size(listFolder,1)
    if ~(strcmp(listFolder{i}, '.') || strcmp(listFolder{i}, '..'))
        
        % iterate every in every folder
        currentPath = fullfile(path, listFolder{i});
        listSubFolders = cellstr(ls(currentPath));
        for j = 1:size(listSubFolders,1)
            subFolder = listSubFolders{j};
            
            if ~(strcmp(listSubFolders{j}, '.') || strcmp(listSubFolders{j}, '..'))
                currentSubFolders = fullfile(currentPath, subFolder);
                disp(currentSubFolders);
                
                % load dataset into imageDataStore
                imds = imageDatastore(currentSubFolders, ...
                    'IncludeSubfolders', true, ...
                    'LabelSource', 'foldernames');
                
                labelCounter = countEachLabel(imds);
                disp(labelCounter);
                
                % store dataset into appropriate folder
                switch listFolder{i}
                    case 'rotasi'
                        save(fullfile('datastore/all/rotasi/', strcat(subFolder, '-lights-', 'rotasi.mat')), 'imds');
                    case 'scaling'
                        save(fullfile('datastore/all/scaling/', strcat(subFolder, '-lights-', 'scaling.mat')), 'imds');
                    case 'sumber cahaya'
                        save(fullfile('datastore/all/sumber_cahaya/', strcat(subFolder, '-lights', '.mat')), 'imds');
                end
            end
        end
    end
end