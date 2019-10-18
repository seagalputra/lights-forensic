function plotBoundingBox(image, boxProps)
imshow(image);
hold on;
for i = 1:size(boxProps,1)
    rectangle('Position', [boxProps(i,1), boxProps(i,2), boxProps(i,3), boxProps(i,4)], ...
        'EdgeColor', 'r', 'LineWidth', 2);
end