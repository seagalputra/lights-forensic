clear; clc; close all;

% Load batch image data
listData = loadData('../../dataset/authentic/2/**/*.JPG');

% PARAMETER
lenPlot = 1;
threshold = 40;

% Load image data and convert into grayscale
img = imread(listData{7});
img = imresize(img, 0.25);

disp('Image segmentation..');
[obj, gray, mask, out] = imsegment(img, 'segType', 'meanshift', ...
    'SpatialBandWidth', 3, 'RangeBandWidth', 7.5);

% imshow(mask, 'InitialMagnification', 67);

%% Do local light source detection
% first thing to do, calculate the initial lighting direction by solving
% the equation (7) from the paper.

for numObj = 1:size(obj,2)
disp(['Assesing object ', num2str(numObj)]);
numGaps = 10;
offset = 15;
nPoints = 4;
[normals, vertices] = getSurfaceNormal(obj{numObj}, numGaps);
intBoundary = getIntensity(gray{numObj}, normals, vertices, offset);

% split vertices into several plane
vertPlane = getSurfacePlane(vertices, nPoints);
N = getSurfacePlane(normals, nPoints);
M = blkdiag(N{:});
M = [M ones(size(M,1),1)];
b = intBoundary';
v = inv(M'*M)*M'*b;
L = averageLight(v);

% get center for every surface plane
cen = cellfun(@median, vertPlane, 'UniformOutput', false);

for numCenter = 1:size(cen,1)
    delt = (L - cen{numCenter})/norm(L - cen{numCenter});
    residual = delt'*delt;
    ident = eye(size(residual,1), 'like', residual);
    c{numCenter} = ident - residual;
end
C = blkdiag(c{:});
C = [C, zeros(size(C,1),1)];

% Conjugate Gradient
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
% using conjugate gradient to solving final error equation
while (i < maxI && dNew > (epsilon^2)*initDelta)
    disp(['Iteration - ', num2str(i)]);
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
% obtain final lighting direction
localLight(numObj,:) = averageLight(v);
degree(numObj,:) = atan2(-localLight(numObj,2), localLight(numObj,1))*180/pi;

end
plotLightDirection(img, localLight, out.center);

%% Check the angle between two object.
% If below threshold, then the image is authentic. If not, then the image
% is not authentic.
possibleDegree = nchoosek(degree,2);
diffLight = abs(possibleDegree(:,2) - possibleDegree(:,1));
nonAuth = find(diffLight > threshold);
disp(diffLight);
if (isempty(nonAuth) == 0)
    disp('This image is forgery');
else
    disp('This image is authentic');
end