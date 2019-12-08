clear; clc; close all;

load('2LightsFeatures.mat');

listPredict = [];
for i = 1:size(features,1)
    disp(num2str(i));
    % membership function correlation
    degreeCorrelation(1) = sigmoidLeft(features(i,1), 0.35, 0.5, 0.65); % low
    degreeCorrelation(2) = sigmoidRight(features(i,1), 0.4, 0.65, 0.8); % high
        
    % membership function theta
    degreeTheta(1) = sigmoidLeft(features(i,2), 45, 57, 92); % low
    degreeTheta(2) = sigmoidRight(features(i,2), 81, 105, 135); % high
    
    [predicted, degreeForgery, degreeAuthentic] = rule(degreeCorrelation, degreeTheta);
    
    listPredict = [listPredict; predicted, degreeForgery];
end

[FPR,TPR,T,AUC] = perfcurve(labels,listPredict(:,2),0);

c = linspace(0,1);
plot(c,c,'--');
hold on;
plot(FPR,TPR,'r','LineWidth',2);
title(['AUC : ', num2str(AUC)]);