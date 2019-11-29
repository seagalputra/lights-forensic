function M = spHarMatrices(N)

% for Y(1,-1) SH
Y1{1} = @(y) sqrt((3/4.*pi).*y);
% for Y(1,1) SH
Y1{2} = @(x) sqrt((3/4.*pi).*x);
% for Y(2,-2) SH
Y2{1} = @(x,y) 3.*sqrt((5/12.*pi).*x.*y);
% for Y(2,2) SH
Y2{2} = @(x,y) 3/2.*sqrt((5/12.*pi).*(x.^2-y.^2));

% create matrix M based on SH coefficient
koeff1 = ones(size(N,1),1);
koeff2 = real((2*pi/3)*Y1{1}(N(:,2)));
koeff3 = real((2*pi/3)*Y1{2}(N(:,1)));
koeff4 = real((pi/4)*Y2{1}(N(:,1),N(:,2)));
koeff5 = real((pi/4)*Y2{2}(N(:,1),N(:,2)));
M = [koeff1, koeff2, koeff3, koeff4, koeff5];