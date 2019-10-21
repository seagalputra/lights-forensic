function plotLightDirection(image, lightDirection, center)
imshow(image, 'InitialMagnification', 67);
hold on;
for i = 1:size(lightDirection,1)
   color = {'c', 'm', 'y'};
   quiver(center(i,1), center(i,2), lightDirection(i,1), lightDirection(i,2), 0, ...
       'Color', color{i}, 'LineWidth', 2, 'MaxHeadSize', 2);
   legendInfo{i} = num2str(lightDirection(i,:));
end
legend(legendInfo);
