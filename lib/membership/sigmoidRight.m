function degree = sigmoidRight(x, a, b, c)

if (x <= a)
    degree = 0;
elseif (x > a && x <= b)
    degree = 2*((x-a)/(c-a))^2;
elseif (x > b && x <= c)
    degree = 1 - (2*((c-x)/(c-a))^2);
elseif (c < x)
    degree = 1;
end

end