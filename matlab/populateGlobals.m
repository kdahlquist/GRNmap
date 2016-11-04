function populateGlobals(GRNstruct)

   global adjacency_mat alpha b degrate fix_b num_genes prorate expression_timepoints is_forced
   
    adjacency_mat         = GRNstruct.GRNParams.adjacency_mat;
    alpha                 = GRNstruct.GRNParams.alpha;
    b                     = GRNstruct.GRNParams.b;
    degrate               = GRNstruct.degRates;
    expression_timepoints = GRNstruct.GRNParams.expression_timepoints;
    fix_b                 = GRNstruct.controlParams.fix_b;
    num_genes             = GRNstruct.GRNParams.num_genes;
    prorate               = GRNstruct.GRNParams.prorate;
    is_forced             = GRNstruct.GRNParams.is_forced;
        
end