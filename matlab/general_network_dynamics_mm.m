function dz = general_network_dynamics_mm(t,zz)
% USAGE  dz = general_network_dynamics(t,zz)
global A degrate deletion n_genes no_inputs prorate wts  

dz  = zeros(size(zz));
W   = zeros(size(A));
P   = prorate(:);
D   = degrate(:);

parms_used  = 0;


for ii = 1:length(zz)

   nAii = sum(A(ii,:));
   jj   = find(A(ii,:)==1);
   p1   = parms_used+1;
   p2   = parms_used + nAii;
   wtii = wts(p1:p2);
   wtii = (wtii(:))';
   W(ii,jj) = wtii;
   parms_used = parms_used + nAii;

end

if deletion ~= 0
   W(deletion,:) = 0;
   W(:,deletion) = 0;
   D(deletion) = 0;
   P(deletion) = 0;
end

f = michaelis_menten(W,zz);

prod = zeros(n_genes,1);

sam = abs(W)*zz;

sam = sam.*(sam>0) + (sam == 0);

deg = D.*zz;

for i = 1:n_genes
   pro = 0;
   for j = 1:n_genes
       pro = pro+((abs(W(i,j))*zz(j)/sam(i)).*f(i,j));
   end
   prod(i) = pro;
   for j = 1:length(no_inputs)
       if i == no_inputs(j,:)
           prod(i) = 1;
       end
   end
end

dz = P(:).*prod - deg;

for i = 1:n_genes
   if i ~= deletion
       if prod(i)==0
           dz(i) = P(i) - deg(i);
       end
   end
end

if deletion ~= 0
   dz(deletion) = 0;
end
return