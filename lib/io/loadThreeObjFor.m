clear; clc; close all;

% load three object forgery
threeObj = dir('../../testing/dataset/3-object/forgery/**/*.jpg');

%% Iterate for every forgery folder
% for multiple-multiple
L5L5 = {}; L5L15 = {}; L6L5 = {}; L9L10 = {};
L9L15 = {}; L10L10 = {}; L15L6 = {}; L15L10 = {};

% for multiple-single
L1L10 = {}; L2L5 = {}; L3L5 = {}; L5L3 = {};
L6L3 = {}; L9L3 = {}; L10L2 = {}; L10L3 = {};

for i = 1:size(threeObj,1)
    % generate filename and folder for every file
    folder = threeObj(i).folder;
    id = strsplit(folder, '\');
    id = id{end};
    fullpath = fullfile(folder, threeObj(i).name);
    % separate every file into id
    switch id
        case 'L5L5'
            L5L5{end+1} = fullpath;
        case 'L5L15'
            L5L15{end+1} = fullpath;
        case 'L6L5'
            L6L5{end+1} = fullpath;
        case 'L9L10'
            L9L10{end+1} = fullpath;
        case 'L9L15'
            L9L15{end+1} = fullpath;
        case 'L10L10'
            L10L10{end+1} = fullpath;
        case 'L15L6'
            L15L6{end+1} = fullpath;
        case 'L15L10'
            L15L10{end+1} = fullpath;
        case 'L1L10'
            L1L10{end+1} = fullpath;
        case 'L2L5'
            L2L5{end+1} = fullpath;
        case 'L3L5'
            L3L5{end+1} = fullpath;
        case 'L5L3'
            L5L3{end+1} = fullpath;
        case 'L6L3'
            L6L3{end+1} = fullpath;
        case 'L9L3'
            L9L3{end+1} = fullpath;
        case 'L10L2'
            L10L2{end+1} = fullpath;
        case 'L10L3'
            L10L3{end+1} = fullpath;
    end
end
%% Combine cell into struct
threeObjFor = struct( ...
    'L5L5',L5L5', ...
    'L5L15',L5L15', ...
    'L6L5',L6L5', ...
    'L9L10',L9L10', ...
    'L9L15',L9L15', ...
    'L10L10',L10L10', ...
    'L15L6',L15L6', ...
    'L15L10',L15L10', ...
    'L1L10',L1L10', ...
    'L2L5',L2L5', ...
    'L3L5',L3L5', ...
    'L5L3',L5L3', ...
    'L6L3',L6L3', ...
    'L9L3',L9L3', ...
    'L10L2',L10L2', ...
    'L10L3',L10L3' ...
    );

save('../../testing/threeObjForgery.mat', 'threeObjFor');