function C = regularization(L, vertPlane)
% get center for every surface plane
cen = cellfun(@median, vertPlane, 'UniformOutput', false);

for numCenter = 1:size(cen,1)
    delt = (L - cen{numCenter})/norm(L - cen{numCenter});
    residual = delt'*delt;
    ident = eye(size(residual,1), 'like', residual);
    c{numCenter} = ident - residual;
end
C = blkdiag(c{:});
C = [C, zeros(size(C,1),1)];