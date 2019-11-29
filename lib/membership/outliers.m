function [lower, upper] = outliers(data)
    % rank the data
    y = sort(data);
    % compute 25th percentile (first quartile)
    Q(1) = median(y(find(y<median(y))));
    % compute 50th percentile (second quartile)
    Q(2) = median(y);
    % compute 75th percentile (third quartile)
    Q(3) = median(y(find(y>median(y))));
    % compute interquartile range (IQR)
    IQR = Q(3) - Q(1);
    % determine outlier
    lower = Q(1) - 1.5*IQR;
    upper = Q(3) + 1.5*IQR;
end