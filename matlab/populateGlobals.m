function populateGlobals(GRNstruct)
   global adjacency_mat b degrate  fix_b num_genes prorate
   
    adjacency_mat = GRNstruct.GRNParams.adjacency_mat;
    b             = GRNstruct.GRNParams.b;
    degrate       = GRNstruct.degrates;
    fix_b         = GRNstruct.controlParams.fix_b;
    num_genes     = GRNstruct.GRNParams.num_genes;
    prorate       = GRNstruct.GRNParams.prorate;

end