% locate additional toolbox file
% path = fullfile('..', '..', 'toolbox', 'MatlabFns', 'Spatial');
% absPath = what(path);
% absPath = absPath.path;
% 
% if (isfolder(path) ~= 1)
%     error('Please locate the file correctly');
% else
%     addpath(genpath(absPath));
% end

addpath('lights');
addpath('segmentation');
addpath('segmentation/meanshift');
