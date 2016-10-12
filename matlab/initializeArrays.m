function GRNstruct = initializeArrays (GRNstruct)
    % We can get rid of these globals later
    global fix_b fix_P Strain expression_timepoints
    
    num_edges  = GRNstruct.GRNParams.num_edges;
    num_forced = GRNstruct.GRNParams.num_forced;
    num_genes  = GRNstruct.GRNParams.num_genes;
            
    GRNstruct.locals.initial_guesses = zeros(num_edges + num_forced * (1 - fix_b) + num_genes * (1 - fix_P), 1);
    GRNstruct.locals.estimated_guesses = zeros(length(GRNstruct.locals.initial_guesses), 1);
        
    GRNstruct.GRNOutput.SSE = zeros(num_genes, length(Strain));
    GRNstruct.GRNOutput.d = zeros(num_genes, length(GRNstruct.microData(1).data));
    GRNstruct.GRNOutput.prorate = zeros(num_genes, 1);
    GRNstruct.GRNOutput.degrate = zeros(num_genes, 1);
    GRNstruct.GRNOutput.wts = zeros(num_edges, 1);
    GRNstruct.GRNOutput.b = zeros(num_genes, 1);
    GRNstruct.GRNOutput.adjacency_mat = zeros(num_genes, num_genes);
    GRNstruct.GRNOutput.active = zeros(1, num_genes);
    GRNstruct.GRNOutput.tspan = zeros(1, length(expression_timepoints));
end