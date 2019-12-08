clear; clc; close all;

path = uigetdir;

imds = imageDatastore(path, 'IncludeSubfolders', true);

% creating label for every data
for i = 1:size(imds.Files,1)
    filePath = imds.Files{i};
    filePath = strsplit(filePath, '\');
    if (strcmp(filePath{8}, 'authentic'))
        labels(i,:) = 1;
    elseif (strcmp(filePath{8}, 'fake'))
        labels(i,:) = 0;
    end
end
% save label into imageDatastore
imds.Labels = labels;

% get an user input to store data in mat-files
filename = input('Please input filename : ', 's');
save(fullfile('observationData', strcat(filename, '.mat')), 'imds');