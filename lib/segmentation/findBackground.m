function background = findBackground(listMask)
binaryMean = cellfun(@mean2, listMask);
[~, idx] = max(binaryMean);
initialBw = ~listMask{idx};
background = imfill(initialBw, 'holes');