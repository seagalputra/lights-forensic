function degree = sigmoidLeft(x, a, b, c)

if (x <= a)
    degree = 1;
elseif (x > a && x <= b)
    degree = 1 - 2*((x-a)/(c-a))^2;
elseif (x > b && x < c)
    degree = 2*((c-x)/(c-a))^2;
elseif (x >= c)
    degree = 0;
end

end