clear; clc; close all;

% If you wanna load another data, please change this variable into specific
% path of your dataset folder.
path = '../../pengujian-all';
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
                dataset = imageDatastore(currentSubFolders, ...
                    'IncludeSubfolders', true, ...
                    'LabelSource', 'foldernames');
                
                labelCounter = countEachLabel(dataset);
                disp(labelCounter);
                
                % store dataset into appropriate folder
                switch listFolder{i}
                    case 'rotasi'
                        save(fullfile('pengujian/all/rotasi/', strcat(subFolder, '-lights-', 'rotasi.mat')), 'dataset');
                    case 'scaling'
                        save(fullfile('pengujian/all/scaling/', strcat(subFolder, '-lights-', 'scaling.mat')), 'dataset');
                    case 'sumber cahaya'
                        save(fullfile('pengujian/all/sumber_cahaya/', strcat(subFolder, '-lights', '.mat')), 'dataset');
                end
            end
        end
    end
end