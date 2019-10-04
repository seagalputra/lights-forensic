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

function [normals, vertices] = getSurfaceNormal(object, numGaps)
    vertices = boundaryImage(object, numGaps);
    normals = LineNormals2D(vertices);
end

function intBoundary = getIntensity(grayImage, normals, vertices, offset)
    x = vertices(:,1)';
    y = vertices(:,2)';
    nx = normals(:,1)';
    ny = normals(:,2)';
    for i = 1:size(x,2)
        intProfile = improfile(grayImage, [x(i) x(i)-nx(i)], [y(i) y(i)+ny(i)], offset);
        intBoundary(i) = interp1(intProfile, 0, 'linear', 'extrap');
    end
end

function splitNormals = getSurfacePlane(normals, nPoints)
    result = fix(size(normals,1)/nPoints);
    remainder = mod(size(normals,1), nPoints);
    sizePoints = repmat(result, 1, nPoints);
    sizePoints(end) = sizePoints(end) + remainder;
    splitNormals = mat2cell(normals, sizePoints, 2);
end

function v = vecLight(N, intensity, lambda)
    M = blkdiag(N{:});
    M = [M ones(size(M,1),1)];
    b = intensity';
    c = {[-1 0 1 0; 0 -1 0 1]};
    c = repmat(c,1,size(N,1)/2);
    block_c = blkdiag(c{:});
    block_c = [block_c zeros(size(block_c,1),1)];
    v = pinv((M'*M) + lambda*(block_c'*block_c))*M'*b;
    v(end) = [];
end

function L = averageLight(v)
    Lx = [];
    Ly = [];
    for i = 1:size(v,1)
        if (mod(i,2) == 0)
            Ly = [Ly; v(i,:)];
        else
            Lx = [Lx; v(i,:)];
        end
    end
    L = [Lx, Ly];
    L = mean(L);
end

function checkGray = isGrayscale(gray)
    if (size(gray,3) == 1)
        checkGray = true;
    else
        checkGray = false;
    end
end

function vertices = boundaryImage(binaryMask, numGaps)
    % trace a boundary
    bwIdx = find(binaryMask);
    % set first index for initial point to trace
    [row, cols] = ind2sub(size(binaryMask), bwIdx(1));
    boundaryIdx = bwtraceboundary(binaryMask, [row cols], 'N');
    % to make point between pixel image, use a gap value.
    idx = [];
    for i = 1:size(boundaryIdx,1)
        if (mod(i,numGaps) == 0)
            idx = [idx; boundaryIdx(i,:)];
        end
    end
    vertices = [idx(:,2) idx(:,1)];
end