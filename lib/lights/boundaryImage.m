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