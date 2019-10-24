%% load image path
clear; clc; close all;

load('../data/dataset.mat');

%% Load image data
for i = 1:size(twoObj.Files,1)
[img, imgInfo] = readimage(twoObj, i);
img = imresize(img, 0.25);

img = imadjust(img, [], [], 0.32);

disp(['Image segmentation - ', num2str(i)]);
[obj, gray, mask, out] = imsegment(img, 'segType', 'meanshift', ...
    'SpatialBandWidth', 3, 'RangeBandWidth', 6.5);

imMontage = montage({img, mask});
myMontage = getframe(gca);
imwrite(myMontage.cdata, fullfile('../data/figure/segmentation/2', strcat(num2str(i), '.jpg')), 'jpg');
close all
end