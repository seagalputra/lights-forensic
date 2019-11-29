function v = solveEstComplex(M, C, b, lambda)
b = b';
v = inv(M'*M + lambda*(C'*C))*M'*b;