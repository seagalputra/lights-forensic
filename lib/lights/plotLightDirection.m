function plotLightDirection(image, lightDirection, center, lenPlot)
imshow(image);
hold on;
for i = 1:size(lightDirection,1)
   line([center(i,1) center(i,1)+lightDirection(i,1)*lenPlot], [center(i,2) center(i,2)+lightDirection(i,2)*lenPlot], ...
       'LineWidth', 2);
   lgd = legend(num2str(lightDirection(i,:)));
   title(lgd, 'Light Direction (in X and Y axis)');
end
