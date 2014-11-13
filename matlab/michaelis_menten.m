function p = michaelis_menten(w,x)

global n_genes 

p = zeros(n_genes,n_genes);

for ii = 1:n_genes
    for jj = 1:n_genes
        if w(ii,jj)>0
            p(ii,jj) = (w(ii,jj)*x(jj))/(1+w(ii,jj)*x(jj));
        end
    end
end

return