clear; clc; close all;

% Load batch image data
listData = loadData('../../dataset/authentic/2/**/*.JPG');

% Load image data and convert into grayscale
lenPlot = 1;
img = imread('../data/1_L3.jpg');
img = imresize(img, 0.25);

disp('Image segmentation..');
[obj, gray, mask, out] = imsegment(img, 'segType', 'meanshift', ...
    'SpatialBandWidth', 2, 'RangeBandWidth', 2.4);

%% Calculate light source direction for every object
% Infinite light source model
% disp('Estimate light source direction...');
% for i = 1:size(obj,2)
%     L(i,:) = lightDirection(obj{i}, gray{i});
% end
% plot light source direction
% plotLightDirection(img, L, out.center, lenPlot);

%% TODO: Do local light source detection
% first thing to do, calculate the initial lighting direction by solving
% the equation (7) from the paper.
numGaps = 10;
offset = 15;
nPoints = 4;
[normals, vertices] = getSurfaceNormal(obj{1}, numGaps);
intBoundary = getIntensity(gray{1}, normals, vertices, offset);

% split vertices into several plane
vertPlane = getSurfacePlane(vertices, nPoints);
N = getSurfacePlane(normals, nPoints);
M = blkdiag(N{:});
M = [M ones(size(M,1),1)];
b = intBoundary';
v = inv(M'*M)*M'*b;
% define the regularization term using equation (23) and obtain the value
% from the initial average of lighting direction.
L = averageLight(v);

%% get center for every surface plane
cen = cellfun(@median, vertPlane, 'UniformOutput', false);

for i = 1:size(cen,1)
    delt = (L - cen{i})/norm(L - cen{i});
    residual = delt'*delt;
    ident = eye(size(residual,1), 'like', residual);
    c{i} = ident - residual;
end
C = blkdiag(c{:});
C = [C, zeros(size(C,1),1)];

%% Conjugate Gradient
lambda = 1;
i = 0;
k = 0;
% calculate the error by computing the first derivative of error term. 
r = -((2*(M'*M)*v) - (2*M'*b) + (2*lambda*(C'*C)*v));
delta = r;
dNew = r'*r;
initDelta = dNew;
epsilon = 0.1;
maxI = 100;
while (i < maxI && dNew > (epsilon^2)*initDelta)
    disp(i);
    upDelta = delta'*delta;
    alpha = -(((2*M'*M*v) - (2*M'*b) + (2*lambda*C'*C*v))'*delta) / (delta'*((2*M'*M) + (2*lambda*C'*C))*delta);
    v = v + (alpha*delta);
    j = 0;
    maxJ = 100;
    while (j < maxJ && alpha^2*upDelta > epsilon^2)
        alpha = -(((2*M'*M*v) - (2*M'*b) + (2*lambda*C'*C*v))'*delta) / (delta'*((2*M'*M) + (2*lambda*C'*C))*delta);
        v = v + (alpha*delta);
        j = j + 1;
    end
    r = -((2*(M'*M)*v) - (2*M'*b) + (2*lambda*(C'*C)*v));
    dOld = dNew;
    dNew = r'*r;
    beta = dNew / dOld;
    delta = r + (beta*delta);
    k = k + 1;
    if (k == size(v,1) || r'*delta <= 0)
        delta = r;
        k = 0;
    end
    i = i + 1;
end
localLight = averageLight(v);
plotLightDirection(img, localLight, out.center, lenPlot);