clear; clc; close all;

path = 'pengujian\all\sumber_cahaya\*.mat';
% path = 'pengujian\all\rotasi\*.mat';
% path = 'pengujian\all\scaling\*.mat';

threshold = 30;
listData = dir(path);
for numData = 1:size(listData,1)
    disp(['Assesing file : ', listData(numData).name]);
    % load every observation data
    load(fullfile(listData(numData).folder, listData(numData).name));
    % change categorical label into binary label
    labels = imds.Labels == 'authentic';
    
    % call main logic here
    predicts = [];
    probability = [];
    features = [];
    listFilename = {};
    for i = 1:size(imds.Files,1)
        disp(num2str(i));
        filePath = imds.Files{i};
        filePathSplit = strsplit(filePath, '\');
        filename = filePathSplit{end};
        listFilename{end+1} = filename;
        
        % load image
        img = imread(filePath);
        img = imresize(img, 0.5);

        % segement image using meanshift
        [obj, gray, mask, params] = imsegment(img, ...
            'segType', 'meanshift', ...
            'SpatialBandWidth', 3, ...
            'RangeBandWidth', 6.5, ...
            'gamma', 0.32, ...
            'numberToExtract', 2, ...
            'sizeThreshold', 500);
    
        % calculate complex lighting environment
        lights = {};
        listDegree = [];
        for j = 1:size(obj,2)
            [light, degree, normals, vertices] = lightDirection(obj{j}, gray{j}, ...
                'modelType', 'local');
            lights{end+1} = light;
            listDegree = [listDegree; degree];
        end
    
        % compute correlation between several lighting condition
%         possibleLights = nchoosek(lights,2);
%         for numLight = 1:size(possibleLights,1)
%             corrLight(numLight,:) = getCorrelation(possibleLights{numLight,1}, possibleLights{numLight,2});
%         end
    
        % compute different between principal light direction
        possibleDegree = nchoosek(listDegree,2);
        diffLight = abs(possibleDegree(:,2) - possibleDegree(:,1));
        
        % store every attribute in features
        features = [features; diffLight];
        
        nonAuth = find(diffLight > threshold);
        if (isempty(nonAuth) == 0)
            % forgery label
            predicts = [predicts; 0];
        else
            % authentic label
            predicts = [predicts; 1];
        end
    end
    rightLabel = labels == predicts;
    accuracy = sum(rightLabel) / size(labels,1);
    disp(['Akurasi : ', num2str(accuracy)]);
    
    % saving predicts data and features in table
%     colNames = {'Filename', 'Features', 'Labels', 'Predicts'};
%     T = table(listFilename', features, labels, predicts, 'VariableNames', colNames);
%     splitPath = strsplit(path, '\');
%     folderName = splitPath{3};
%     
%     writetable(T, fullfile('..\..\report_table\', folderName, strcat(num2str(numData), '.xlsx')));
    
%     % create performance model analysis using ROC curve
%     [FPR, TPR, T, AUC] = perfcurve(labels, probability(:,2), 1);
%     
%     threshold = 0.7;
%     pred = (probability(:,2)>=threshold);
%     TP = sum(pred == 1 & labels == 1);
%     FP = sum(pred == 1 & labels == 0);
%     TN = sum(pred == 0 & labels == 0);
%     FN = sum(pred == 0 & labels == 1);
%     
%     disp(['Area Under the Curve         : ', num2str(AUC)]);
%     disp(['Accuracy                     : ', num2str(100*(TP+TN)/(TP+TN+FP+FN)), ' %']);
%     disp(['True Positive Rate           : ', num2str(100*TP/(TP+FN)), ' %']);
%     disp(['False Positive Rate          : ', num2str(100*FP/(FP+TN)), ' %']);
    % disp(['True Negative Rate           : ', num2str(100*TN/(TN+FP)), ' %']);
    % disp(['False Negative Rate          : ', num2str(100*FN/(FN+TP)), ' %']);
    % disp(['Positive Predictive Value    : ', num2str(100*TP/(TP+FP)), ' %']);
    % disp(['Negative Predictive Value    : ', num2str(100*TN/(TN+FN)), ' %']);    
    % disp(['False Discovery Rate         : ', num2str(100*FP/(FP+TP)), ' %']);
    % disp(['False Omission Rate          : ', num2str(100*FN/(FN+TN)), ' %']);
%     disp('----------------------------------------------------------');
%     
%     c = linspace(0,1);
%     plot(c,c,'--');
%     hold on;
%     plot(FPR, TPR, 'LineWidth', 2);
%     title('ROC Curve - Distorsi Scaling');
end
% legend('2 Sumber Cahaya', '3 Sumber Cahaya', '4 Sumber Cahaya');