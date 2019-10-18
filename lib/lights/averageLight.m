function L = averageLight(v)
Lx = [];
Ly = [];
for i = 1:size(v,1)
    if (mod(i,2) == 0)
        Ly = [Ly; v(i,:)];
    else
        Lx = [Lx; v(i,:)];
    end
end
L = [Lx, Ly];
L = mean(L);