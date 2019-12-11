function [theta, v] = getPrincipalLight(N, intensity, lambda)

% for Y(1,-1) SH
Y1{1} = @(y) sqrt((3/4.*pi).*y);
% for Y(1,1) SH
Y1{2} = @(x) sqrt((3/4.*pi).*x);

% create matrix M based on SH coefficient
koeff1 = ones(size(N,1),1);
koeff2 = real((2*pi/3)*Y1{1}(N(:,2)));
koeff3 = real((2*pi/3)*Y1{2}(N(:,1)));
M = [koeff1, koeff2, koeff3];
C = diag([1, 2, 2]);

v = solveEstComplex(M, C, intensity, lambda);
% calculate the theta
theta = lightAngle(v(3), v(2));
