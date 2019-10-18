function [center, radius, boxProps] = getBinaryProps(binaryMask)

center = [];
radius = [];
boxProps = [];
% calculate binary image properties
props = regionprops(binaryMask, 'BoundingBox', 'Area', 'Centroid', ...
    'MajorAxisLength', 'MinorAxisLength');
for i = 1:size(props,1)
    center = [center; props(i).Centroid];
    diameter = mean([props(i).MajorAxisLength props(i).MinorAxisLength], 2);
    radius = [radius; diameter/2];   
    boxProps = [boxProps; props(i).BoundingBox];
end