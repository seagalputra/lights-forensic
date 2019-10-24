clear; clc; close all;

% NOTE : authentic label is 1 then forgery label is 0

%% load data for 2 object
% load and assign label for authentic data
pathAuth = '../../dataset/authentic/2';
twoObjAuth = imageDatastore(pathAuth, 'IncludeSubfolders', true);

szTwoAuth = size(twoObjAuth.Files,1);
disp(['Ukuran data untuk 2 objek authentic : ', num2str(szTwoAuth)]);
% create label for authentic
labelAuth = ones(szTwoAuth, 1);
twoObjAuth.Labels = labelAuth;

% load and assign label for forgery data
pathFor = '../../dataset/forgery/2';
twoObjFor = imageDatastore(pathFor, 'IncludeSubfolders', true);

szTwoFor = size(twoObjFor.Files,1);
disp(['Ukuran data untuk 2 objek forgery : ', num2str(szTwoFor)]);
% create label for forgery
labelFor = zeros(szTwoFor, 1);
twoObjFor.Labels = labelFor;

% combine every dataset
twoObj = imageDatastore(cat(1, twoObjAuth.Files, twoObjFor.Files));
twoObj.Labels = cat(1, twoObjAuth.Labels, twoObjFor.Labels);

%% load data for 3 object
% load and assign label for authentic data
pathAuth = '../../dataset/authentic/3';
threeObjAuth = imageDatastore(pathAuth, 'IncludeSubfolders', true);

szThreeAuth = size(threeObjAuth.Files,1);
disp(['Ukuran data untuk 3 objek authentic : ', num2str(szThreeAuth)]);
% create label for authentic
labelAuth = ones(szThreeAuth, 1);
threeObjAuth.Labels = labelAuth;

% load ana assign label for forgery data
pathFor = '../../dataset/forgery/3';
threeObjFor = imageDatastore(pathFor, 'IncludeSubfolders', true);

szThreeFor = size(threeObjFor.Files,1);
disp(['Ukuran data untuk 3 objek forgery : ', num2str(szThreeFor)]);
% create label for forgery
labelFor = zeros(szThreeFor, 1);
threeObjFor.Labels = labelFor;

% combine every dataset
threeObj = imageDatastore(cat(1, threeObjAuth.Files, threeObjFor.Files));
threeObj.Labels = cat(1, threeObjAuth.Labels, threeObjFor.Labels);

save('../data/dataset.mat', 'twoObj', 'threeObj');