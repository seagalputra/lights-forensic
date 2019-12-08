function mf = triangle(x, a, b, c)
%     mf = max(min((x-a)/(b-a), (c-x)/(c-b)),0);
    if (x <= a || x >= c)
        mf = 0;
    elseif (x > a && x <= b)
        mf = (x-a)/(b-a);
    elseif (x > b && x <= c)
        mf = -(x-c)/(c-b);
    end
end