clear; clc; close all;

addPath;
load('../../testing/twoObjAuthentic.mat');

%% Edge detection using sobel operator for each R-G-B channel
% for nChannel = 1:size(img,3)
%     [E{nChannel}, threshOut, Gv{nChannel}, Gh{nChannel}] = edge(img(:,:,nChannel), 'Sobel', 0.02);
% end
% using OR operator to get final edge map
% edgeMap = E{1}|E{2}|E{3};

% figure(1),
% imshow(edgeMap);

%% Compare gradient image with threshold
% threshold = 0.01;
% for nGrad = 1:size(Gv,2)
%     mask{nGrad} = Gv{nGrad} > threshold;
% end

%% Using quasi-invariant edges
% sigma = 1; % standard deviataion gaussian kernel

% shadow-shading quasi invariant
% [theta_x, theta_y, phi_x, phi_y, r_x, r_y, intensityL2] = spherical_der(img, sigma);
% shadow_shading_invariant = sqrt(theta_x.^2+theta_y.^2+phi_x.^2+phi_y.^2+eps);
% shadow_shading_variant = sqrt(r_x.^2+r_y.^2+eps);

% show image shadow-shading invariant
% figure(2),
% imshow(shadow_shading_invariant, []);

%% Trying to figure it out with meanshift algorithm

ID = 'L1';
% do a loop
for i = 1:size(twoObjAuth,1)
    disp(['Image segmentation - ', num2str(i)]);
    img = imread(twoObjAuth(i).(ID));
    img = imresize(img, 0.5);
    
    [fimage, labels] = edison_wrapper(img, @RGB2Luv, ...
        'SpatialBandWidth', 20, 'RangeBandWidth', 7.5);
    % because label start from zero
    labels = labels + 1;
    % make label more colorful
    rgb = label2rgb(labels);
    
    imwrite(rgb, fullfile('../../shadow/', ID, strcat(num2str(i),'.jpg')));
end

%% Define shadow
% % create mask from label
% binaryMask = zeros([size(img,1) size(img,2)]);
% binaryMask(labels == 17) = 1;
% 
% % calculate std in specific mask
% grayImage = rgb2gray(img);
% selectedGray = grayImage(idx{17});
% stats = std(double(selectedGray));
% disp(['Standard Deviation : ', num2str(stats)]);