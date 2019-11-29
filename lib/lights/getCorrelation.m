function distance = getCorrelation(w1, w2)
Q = diag([0, pi/6, pi/6, 5*pi/4, 5*pi/4]);
correlation = (w1'*Q*w2)/(sqrt(w1'*Q*w1)*sqrt(w2'*Q*w2));
distance = 0.5*(1-correlation);