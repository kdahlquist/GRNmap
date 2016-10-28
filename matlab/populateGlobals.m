function populateGlobals(GRNstruct)
   global adjacency_mat alpha b degrate fix_b num_genes prorate production_function
   
    adjacency_mat       = GRNstruct.GRNParams.adjacency_mat;
    alpha               = GRNstruct.GRNParams.alpha;
    b                   = GRNstruct.GRNParams.b;
    degrate             = GRNstruct.degRates;
    fix_b               = GRNstruct.controlParams.fix_b;
    num_genes           = GRNstruct.GRNParams.num_genes;
    prorate             = GRNstruct.GRNParams.prorate;
    production_function = GRNstruct.controlParams.production_function;
    
end