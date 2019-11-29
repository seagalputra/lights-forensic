clear; clc; close all;

load('datasetAlt.mat');

img = imread(imds.Files{7});
img = imresize(img, 0.5);
imgGray = rgb2gray(img);

% detect edge in image
sigma1 = 2;
sigma2 = 1;
edgeT = 0.7;
out = color_canny(img, sigma1, sigma2, 3);
BW = out > edgeT;
BW = bwareaopen(BW,200);

imshow(BW);

%% Estimate image lighting environment
% parameter
offset = 15;
lambda = 0.1;
% obtain list index of pixel in edge image
props = regionprops(BW, 'Centroid', 'BoundingBox', 'PixelList');

for num = 1:size(props,1)
    vertices = [];
    bwCrop = imcrop(BW, props(num).BoundingBox);
    
    vertices(:,1) = props(num).PixelList(:,1);
    vertices(:,2) = props(num).PixelList(:,2);
    idx = [];
    for i = 1:size(vertices,1)
        if (mod(i,10) == 0)
            idx = [idx; vertices(i,:)];
        end
    end
    
    normals = LineNormals2D(idx);
    intensity = getIntensity(imgGray, normals, idx, offset);
    
    % get block N matrix using spherical harmaonics coefficient
    M = spHarMatrices(normals);
    % estimate lighting complex environment
    C = diag([1, 2, 2, 3, 3]);
    v{num,:} = solveEstComplex(M, C, intensity, lambda);
    % get principal light direction
    theta(num,:) = getPrincipalLight(normals, intensity, lambda);
end

possibleLights = nchoosek(v,2);
for i = 1:size(possibleLights,1)
    dist(i,:) = getCorrelation(possibleLights{i,1}, possibleLights{i,2});
end