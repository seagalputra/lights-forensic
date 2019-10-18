function [normals, vertices] = getSurfaceNormal(object, numGaps)
vertices = boundaryImage(object, numGaps);
normals = LineNormals2D(vertices);