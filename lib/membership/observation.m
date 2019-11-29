clear; clc; close all;

load('sampleFeatures.mat');

% separate every features
% for correlation features
authCorrelation = authSample(:,1);
forCorrelation = forSample(:,1);
% for theta features
authTheta = authSample(:,2);
forTheta = forSample(:,2);

% sort features into ascending
authCorrelation = sort(authCorrelation);
authTheta = sort(authTheta);
forCorrelation = sort(forCorrelation);
forTheta = sort(forTheta);

%% using IQR to determine outlier and range of membership function
% determine if any outlier in dataset
x = 1:size(authCorrelation,1);
[TF, L, U, C] = isoutlier(authCorrelation);
plot(x,authCorrelation,x(TF),authCorrelation(TF),'x',x,L*ones(1,50),x,U*ones(1,50),x,C*ones(1,50));
legend('Original Data','Outlier','Lower Threshold','Upper Threshold','Center Value');