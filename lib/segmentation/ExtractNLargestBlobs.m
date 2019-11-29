function binaryImage = ExtractNLargestBlobs(binaryImage, numberToExtract)
try
    [labeledImage, numberOfBlobs] = bwlabel(binaryImage);
    blobMeasurements = regionprops(labeledImage, 'area');
    % Get all the areas
    allAreas = [blobMeasurements.Area];
    if numberToExtract > length(allAreas)
        numberToExtract = length(allAreas);
    end
    if numberToExtract > 0
        [sortedAreas, sortIndexes] = sort(allAreas, 'descend');
    elseif numberToExtract < 0
        [sortedAreas, sortIndexes] = sort(allAreas, 'ascend');
        numberToExtract = -numberToExtract;
    else
        binaryImage = false(size(binaryImage));
        return;
    end
    biggestBlob = ismember(labeledImage, sortIndexes(1:numberToExtract));
    binaryImage = biggestBlob > 0;
catch ME
    errorMessage = sprintf('Error in function ExtractNLargestBlobs().\n\nError Message:\n%s', ME.message);
	fprintf(1, '%s\n', errorMessage);
end