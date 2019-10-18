function intBoundary = getIntensity(grayImage, normals, vertices, offset)
x = vertices(:,1)';
y = vertices(:,2)';
nx = normals(:,1)';
ny = normals(:,2)';
for i = 1:size(x,2)
    intProfile = improfile(grayImage, [x(i) x(i)+nx(i)], [y(i) y(i)+ny(i)], offset);
    intBoundary(i) = interp1(intProfile, 0, 'linear', 'extrap');
end