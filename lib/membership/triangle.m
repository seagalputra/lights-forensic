function mf = triangle(x, a, b, c)
    mf = max(min((x-a)/(b-a), (c-x)/(c-b)),0);
end