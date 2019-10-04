function [objMask, objGray, out] = imsegment(image, varargin)
    % DEFAULT PARAMETER
    defaultNColors = 2;
    defaultNReplicates = 3;
    defaultThreshold = 500;
    defaultSegType = 'kmeans';
    % validate function input parameter
    parser = inputParser;
    addRequired(parser, 'image', @isRGB);
    addParameter(parser, 'nColors', defaultNColors, @isnumeric);
    addParameter(parser, 'numReplicates', defaultNReplicates, @isnumeric);
    addParameter(parser, 'sizeThreshold', defaultThreshold, @isnumeric);
    addParameter(parser, 'segType', defaultSegType, @isstring);
    parse(parser, image, varargin{:});
    inputs = parser.Results;
    % call main logic
    [objMask, objGray, out] = segmentImage(inputs);
end

function [objMask, objGray, out] = segmentImage(params)
    % convert image into grayscale
    gray = convertToGray(params.image);
    % decide which segmentation is used
    switch params.segType
        case 'kmeans'
            mask = kmeansSegmentation(params.image, params.nColors, ...
                params.numReplicates);
        case 'thresh'
            mask = colorThreshold(params.image);
    end
    
    % create bounding box and obtain properties of the image
    [center, radius, boxProps] = getBinaryProps(mask, params.sizeThreshold);
    % crop every object
    [objMask, objGray] = getObjectMask(mask, gray, boxProps);
    % create struct table every properties of object
    out.center = center;
    out.radius = radius;
    out.boxProps = boxProps;
end

function binaryMask = kmeansSegmentation(image, nColors, numReplicates)
    labImage = convertToLab(image);
    % reshape image into array
    ab = double(labImage(:,:,2:3));
    nRows = size(ab,1);
    nCols = size(ab,2);
    ab = reshape(ab, nRows*nCols, 2);
    % do clustering
    clusterIdx = kmeans(ab, nColors, 'distance', 'sqEuclidean', ...
        'Replicates', numReplicates, 'Display', 'iter');
    pixelLabels = reshape(clusterIdx, nRows, nCols);
    % separate each label
    for i = 1:nColors
        mask = zeros([size(image,1) size(image,2)]);
        mask(pixelLabels == i) = 1;
        binaryMask{i} = mask;
    end
    % find background mask
    binaryMask = findBackground(binaryMask);
end

function background = findBackground(listMask)
    binaryMean = cellfun(@mean2, listMask);
    [~, idx] = max(binaryMean);
    initialBw = ~listMask{idx};
    background = imfill(initialBw, 'holes');
end

function [BW, maskedRGBImage] = colorThreshold(rgbImage)
    I = rgb2ycbcr(rgbImage);
    % Define thresholds for channel 1 based on histogram settings
    channel1Min = 0.000;
    channel1Max = 255.000;
    % Define thresholds for channel 2 based on histogram settings
    channel2Min = 108.000;
    channel2Max = 184.000;
    % Define thresholds for channel 3 based on histogram settings
    channel3Min = 85.000;
    channel3Max = 123.000;
    % Create mask based on chosen histogram thresholds
    sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
        (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
        (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
    BW = sliderBW;
    % Fill holes in segmentation result
    BW = imfill(BW, 'holes');
    % Initialize output masked image based on input image.
    maskedRGBImage = RGB;
    % Set background pixels where BW is false to zero.
    maskedRGBImage(repmat(~BW,[1 1 3])) = 0;
end

function [objMask, objGray] = getObjectMask(binaryMask, grayImage, boxProps)
    for i = 1:size(boxProps,1)
        % crop every object in image
        objMask{i} = imcrop(binaryMask, boxProps(i,:));
        objGray{i} = imcrop(grayImage, boxProps(i,:));
    end
end

function [center, radius, boxProps] = getBinaryProps(binaryMask, sizeThreshold)
    center = [];
    radius = [];
    boxProps = [];
    % filter binary mask with largest area
    bw = bwareaopen(binaryMask, sizeThreshold);
    % calculate binary image properties
    props = regionprops(bw, 'BoundingBox', 'Area', 'Centroid', ...
        'MajorAxisLength', 'MinorAxisLength');
    for i = 1:size(props,1)
        center = [center; props(i).Centroid];
        diameter = mean([props(i).MajorAxisLength props(i).MinorAxisLength], 2);
        radius = [radius; diameter/2];
        boxProps = [boxProps; props(i).BoundingBox];
    end
end

function labImage = convertToLab(rgbImage)
    cform = makecform('srgb2lab');
    labImage = applycform(rgbImage, cform);
end

function grayImage = convertToGray(rgbImage)
    grayImage = rgb2gray(rgbImage);
end

function bool = isRGB(image)
    if (size(image,3) == 3)
        bool = true;
    else
        bool = false;
    end
end