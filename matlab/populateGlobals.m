function populateGlobals(GRNstruct)
   global adjacency_mat b degrate fix_b num_genes prorate production_function
   
    adjacency_mat       = GRNstruct.GRNParams.adjacency_mat;
    b                   = GRNstruct.GRNParams.b;
    degrate             = GRNstruct.degRates;
    fix_b               = GRNstruct.controlParams.fix_b;
    num_genes           = GRNstruct.GRNParams.num_genes;
    prorate             = GRNstruct.GRNParams.prorate;
    production_function = GRNstruct.controlParams.production_function;
    
end