function [L, theta] = conjugateGrad(v, M, b, C, lambda)
% Conjugate Gradient
i = 0;
k = 0;
% calculate the error by computing the first derivative of error term. 
r = -((2*(M'*M)*v) - (2*M'*b) + (2*lambda*(C'*C)*v));
delta = r;
dNew = r'*r;
initDelta = dNew;
epsilon = 0.1;
maxI = 100;
% using conjugate gradient to solving final error equation
while (i < maxI && dNew > (epsilon^2)*initDelta)
    % disp(['Iteration - ', num2str(i)]);
    upDelta = delta'*delta;
    alpha = -(((2*M'*M*v) - (2*M'*b) + (2*lambda*C'*C*v))'*delta) / (delta'*((2*M'*M) + (2*lambda*C'*C))*delta);
    v = v + (alpha*delta);
    j = 0;
    maxJ = 100;
    while (j < maxJ && alpha^2*upDelta > epsilon^2)
        alpha = -(((2*M'*M*v) - (2*M'*b) + (2*lambda*C'*C*v))'*delta) / (delta'*((2*M'*M) + (2*lambda*C'*C))*delta);
        v = v + (alpha*delta);
        j = j + 1;
    end
    r = -((2*(M'*M)*v) - (2*M'*b) + (2*lambda*(C'*C)*v));
    dOld = dNew;
    dNew = r'*r;
    beta = dNew / dOld;
    delta = r + (beta*delta);
    k = k + 1;
    if (k == size(v,1) || r'*delta <= 0)
        delta = r;
        k = 0;
    end
    i = i + 1;
end
% obtain final lighting direction
L = averageLight(v);
% theta = atan2(-L(2), L(1))*180/pi;
theta = lightAngle(L(1), L(2));