function [L, theta, normals, vertices] = lightDirection(object, grayImage, varargin)
    % DEFAULT PARAMETER
    defaultNPoints = 4;
    defaultLambda = 1;
    defaultNumGaps = 10;
    defaultOffset = 15;
    defaultModelType = 'infinite';
    
    % validate function input parameter
    parser = inputParser;
    addRequired(parser, 'object', @islogical);
    addRequired(parser, 'grayImage', @isGrayscale);
    addOptional(parser, 'lambda', defaultLambda, @isnumeric);
    addParameter(parser, 'nPoints', defaultNPoints, @isnumeric);
    addParameter(parser, 'numGaps', defaultNumGaps, @isnumeric);
    addParameter(parser, 'offset', defaultOffset, @isnumeric);
    addParameter(parser, 'modelType', defaultModelType, @ischar);
    parse(parser, object, grayImage, varargin{:});
    inputs = parser.Results;
    
    % call the main logic
    [L, theta, normals, vertices] = getLightDirection(inputs);
end

function [L, theta, normals, vertices] = getLightDirection(params)    
    switch params.modelType
        case 'infinite'
            L = infiniteLight(params.object, params.grayImage, ...
                params.nPoints, params.lambda, params.numGaps, params.offset);
        case 'local'
            [L, theta, normals, vertices] = localLight(params.object, params.grayImage, ...
                params.nPoints, params.lambda, params.numGaps, params.offset);
        case 'complex'
            [L, theta, normals, vertices] = lightComplex(params.object, params.grayImage, ...
                params.lambda, params.numGaps, params.offset);
    end
end

function L = infiniteLight(object, grayImage, nPoints, lambda, numGaps, offset)
    % find points at boundary object and calculate surface normal
    [normals, vertices] = getSurfaceNormal(object, numGaps);
    % obtain intensity at boundary image using improfile and extrapolation
    intBoundary = getIntensity(grayImage, normals, vertices, offset);
    % before calculating the light source direction, split normal surface into
    % several planes
    N = getSurfacePlane(normals, nPoints);
    % calculate light source direction by solving least-square problem
    v = vecLight(N, intBoundary, lambda);
    % average the result of light estimation
    L = averageLight(v);
end

function [L, theta, normals, vertices] = localLight(object, grayImage, nPoints, lambda, numGaps, offset)
    % find points at boundary object and calculate surface normal
    [normals, vertices] = getSurfaceNormal(object, numGaps);
    % make sure the value doesn't include NaN
    normals(isnan(normals)) = -1;
    % obtain intensity at boundary image using improfile and extrapolation
    intBoundary = getIntensity(grayImage, normals, vertices, offset);
    % split vertices and normals into several plane
    vertPlane = getSurfacePlane(vertices, nPoints);
    N = getSurfacePlane(normals, nPoints);
    % get initial light source by solving least square equation
    [initL, v, M, b] = leastSquare(N, intBoundary);
    % get initial regularization term
    C = regularization(initL, vertPlane);
    % Do conjugate gradient
    [L, theta] = conjugateGrad(v, M, b, C, lambda);
end

function [v, theta, normals, vertices] = lightComplex(object, grayImage, lambda, numGaps, offset)
    [normals, vertices] = getSurfaceNormal(object, numGaps);
    normals(isnan(normals)) = -1;
    intBoundary = getIntensity(grayImage, normals, vertices, offset);
    % get block N matrix using spherical harmonics coefficient
    M = spHarMatrices(normals);
    % estimate lighting complex environment
    C = diag([1, 2, 2, 3, 3]);
    v = solveEstComplex(M, C, intBoundary, lambda);
    % get principal light direction
    theta = getPrincipalLight(normals, intBoundary, lambda);
end

function checkGray = isGrayscale(gray)
    if (size(gray,3) == 1)
        checkGray = true;
    else
        checkGray = false;
    end
end