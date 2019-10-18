function splitNormals = getSurfacePlane(normals, nPoints)
result = fix(size(normals,1)/nPoints);
remainder = mod(size(normals,1), nPoints);
sizePoints = repmat(result, 1, nPoints);
sizePoints(end) = sizePoints(end) + remainder;
splitNormals = mat2cell(normals, sizePoints, 2);