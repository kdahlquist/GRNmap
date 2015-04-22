function p = michaelis_menten(w,x)

global num_genes 

p = zeros(num_genes,num_genes);

for ii = 1:num_genes
    for jj = 1:num_genes
        if w(ii,jj)>0
            p(ii,jj) = (w(ii,jj)*x(jj))/(1+w(ii,jj)*x(jj));
        end
    end
end

return