function dz = general_network_dynamics_sigmoid(t,zz)
% USAGE  dz = general_network_dynamics_sigmoid(t,zz)
global adjacency_mat b degrate deletion  fix_b is_forced num_genes prorate wts  

dz  = zeros(size(zz));
W   = zeros(size(adjacency_mat));
D   = degrate(:);
B   = zeros(num_genes,1);

if ~fix_b
    B(is_forced) = b;
end

parms_used = 0;

for ii = 1:length(zz)

    nAii = sum(adjacency_mat(ii,:));
    jj   = find(adjacency_mat(ii,:)==1);
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

WX  = W*zz;
QX  = zeros(size(WX));
IX  = WX>QX;

% WXB = (W*zz - B).*(IX) + -10*(1-IX);
WXB = WX - B;

pro = prorate(:)./(1+exp(-WXB));
deg = D.*zz;

dz = pro - deg;

if deletion ~= 0
    dz(deletion) = 0;
end

return