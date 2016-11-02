function populateGlobals(GRNstruct)

   global adjacency_mat alpha b degrate fix_b num_genes prorate
   
    adjacency_mat       = GRNstruct.GRNParams.adjacency_mat;
    alpha               = GRNstruct.GRNParams.alpha;
    b                   = GRNstruct.GRNParams.b;
    degrate             = GRNstruct.degRates;
    fix_b               = GRNstruct.controlParams.fix_b;
    num_genes           = GRNstruct.GRNParams.num_genes;
    prorate             = GRNstruct.GRNParams.prorate;
    
end