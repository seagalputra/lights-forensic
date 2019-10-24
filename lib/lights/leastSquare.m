function [L, v, M, b] = leastSquare(N, intBoundary)
M = blkdiag(N{:});
M = [M ones(size(M,1),1)];
b = intBoundary';
v = inv(M'*M)*M'*b;
L = averageLight(v);