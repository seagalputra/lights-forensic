function [objMask, objGray, mask, out] = imsegment(image, varargin)
    % DEFAULT PARAMETER
    defaultNColors = 2;
    defaultNReplicates = 3;
    defaultThreshold = 1000;
    defaultSegType = 'meanshift';
    defaultSpatialBandWidth = 3;
    defaultRangeBandWidth = 4.0;
    defaultGamma = 0.25;
    % validate function input parameter
    parser = inputParser;
    addRequired(parser, 'image', @isRGB);
    % parameter for kmeans
    addParameter(parser, 'nColors', defaultNColors, @isnumeric);
    addParameter(parser, 'numReplicates', defaultNReplicates, @isnumeric);
    
    % parameter for meanshift
    addParameter(parser, 'SpatialBandWidth', defaultSpatialBandWidth, @isnumeric);
    addParameter(parser, 'RangeBandWidth', defaultRangeBandWidth, @isnumeric);
    
    % parameter for preprocessing
    addParameter(parser, 'gamma', defaultGamma, @isnumeric);
    
    % other parameter
    addParameter(parser, 'sizeThreshold', defaultThreshold, @isnumeric);
    addParameter(parser, 'segType', defaultSegType, @ischar);
    
    parse(parser, image, varargin{:});
    inputs = parser.Results;
    % call main logic
    [objMask, objGray, mask, out] = segmentImage(inputs);
end

function [objMask, objGray, mask, out] = segmentImage(params)
    % convert image into grayscale
    gray = convertToGray(params.image);
    
    % decide which segmentation is used
    switch params.segType
        case 'kmeans'
            mask = kmeansClustering(params.image, params.nColors, ...
                params.numReplicates, params.sizeThreshold);
        case 'thresh'
            mask = colorThreshold(params.image);
        case 'meanshift'
            % preprocessing state
            preImg = imadjust(params.image, [], [], params.gamma);
            mask = meanShiftSegmentation(preImg, params.SpatialBandWidth, ...
                params.RangeBandWidth, params.sizeThreshold);
    end
    
    % create bounding box and obtain properties of the image
    [center, radius, boxProps] = getBinaryProps(mask);
    % crop every object
    [objMask, objGray] = getObjectMask(mask, gray, boxProps);
    % create struct table every properties of object
    out.center = center;
    out.radius = radius;
    out.boxProps = boxProps;
end

function bool = isRGB(image)
    if (size(image,3) == 3)
        bool = true;
    else
        bool = false;
    end
end