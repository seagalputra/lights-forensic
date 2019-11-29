clear; clc; close all;

path = uigetdir;

imds = imageDatastore(path, 'IncludeSubfolders', true);

% creating label for every data
for i = 1:size(imds.Files,1)
    filePath = imds.Files{i};
    filePath = strsplit(filePath, '\');
    if (strcmp(filePath{7}, 'authentic'))
        labels(i,:) = 1;
    elseif (strcmp(filePath{7}, 'forgery'))
        labels(i,:) = 0;
    end
end
% save label into imageDatastore
imds.Labels = labels;
save('../../dataset.mat', 'imds');