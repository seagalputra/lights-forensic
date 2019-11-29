clear; clc; close all;

% load two object
twoObject = dir('../../testing/dataset/2-object/authentic/**/*.jpg');

%% Iterate in every authentic folder
L1 = {}; L2 = {}; L3 = {}; L4 = {}; L5 = {}; 
L6 = {}; L7 = {}; L8 = {}; L9 = {}; L10 = {}; 
L11 = {}; L12 = {}; L13 = {}; L14 = {}; L15 = {};
for i = 1:size(twoObject,1)
    % generate filename and folder for every file
    folder = twoObject(i).folder;
    id = strsplit(folder, '\');
    id = id{end};
    fullpath = fullfile(folder, twoObject(i).name);
    % separate every file into id
    switch id
        case 'L1'
            L1{end+1} = fullpath;
        case 'L2'
            L2{end+1} = fullpath;
        case 'L3'
            L3{end+1} = fullpath;
        case 'L4'
            L4{end+1} = fullpath;
        case 'L5'
            L5{end+1} = fullpath;
        case 'L6'
            L6{end+1} = fullpath;
        case 'L7'
            L7{end+1} = fullpath;
        case 'L8'
            L8{end+1} = fullpath;
        case 'L9'
            L9{end+1} = fullpath;
        case 'L10'
            L10{end+1} = fullpath;
        case 'L11'
            L11{end+1} = fullpath;
        case 'L12'
            L12{end+1} = fullpath;
        case 'L13'
            L13{end+1} = fullpath;
        case 'L14'
            L14{end+1} = fullpath;
        case 'L15'
            L15{end+1} = fullpath;
    end
end
%% append all data into one struct file
twoObjAuth = struct( ...
    'L1',L1', ...
    'L2',L2', ...
    'L3',L3', ...
    'L4',L4', ...
    'L5',L5', ...
    'L6',L6', ...
    'L7',L7', ...
    'L8',L8', ...
    'L9',L9', ...
    'L10',L10', ...
    'L11',L11', ...
    'L12',L12', ...
    'L13',L13', ...
    'L14',L14', ...
    'L15',L15' ...
    );

save('../../testing/twoObjAuthentic.mat', 'twoObjAuth');