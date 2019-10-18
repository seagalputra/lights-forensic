function L = lightDirection(object, grayImage, varargin)
    % DEFAULT PARAMETER
    defaultNPoints = 4;
    defaultLambda = 1;
    defaultNumGaps = 10;
    defaultOffset = 15;
    
    % validate function input parameter
    parser = inputParser;
    addRequired(parser, 'object', @islogical);
    addRequired(parser, 'grayImage', @isGrayscale);
    addOptional(parser, 'lambda', defaultLambda, @isnumeric);
    addParameter(parser, 'nPoints', defaultNPoints, @isnumeric);
    addParameter(parser, 'numGaps', defaultNumGaps, @isnumeric);
    addParameter(parser, 'offset', defaultOffset, @isnumeric);
    parse(parser, object, grayImage, varargin{:});
    inputs = parser.Results;
    
    L = getLightDirection(inputs.object, inputs.grayImage, inputs.nPoints, ...
        inputs.lambda, inputs.numGaps, inputs.offset);
end

function L = getLightDirection(object, grayImage, nPoints, lambda, numGaps, offset)
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

function checkGray = isGrayscale(gray)
    if (size(gray,3) == 1)
        checkGray = true;
    else
        checkGray = false;
    end
end