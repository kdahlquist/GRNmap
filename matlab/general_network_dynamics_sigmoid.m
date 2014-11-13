function dz = general_network_dynamics_sigmoid(t,zz)
% USAGE  dz = general_network_dynamics_sigmoid(t,zz)
global A b degrate deletion  fix_b i_forced n_genes prorate wts  

dz  = zeros(size(zz));
W   = zeros(size(A));
D   = degrate(:);
B   = zeros(n_genes,1);

if fix_b == 0
    B(i_forced) = b;
end

parms_used  = 0;

for ii = 1:length(zz)

    nAii = sum(A(ii,:));
    jj   = find(A(ii,:)==1);
    p1   = parms_used+1;
    p2   = parms_used+nAii;
    wtii = wts(p1:p2);
    wtii = (wtii(:))';
    W(ii,jj) = wtii;
    parms_used = parms_used + nAii;

end

if deletion ~= 0

    W(deletion,:) = 0;
    W(:,deletion) = 0;
    B(deletion) = 0;
    D(deletion) = 0;
end

WXB = -W*zz + B;

pro = prorate(:)./(1+exp(WXB));
deg = D.*zz;

dz = pro - deg;

if deletion ~= 0
    dz(deletion) = 0;
end

return