function GRNstruct = initializeArrays (GRNstruct)
    % We can get rid of these globals later
    global fix_b fix_P
    
    num_edges = GRNstruct.GRNParams.num_edges;
    num_forced = GRNstruct.GRNParams.num_forced;
    num_genes = GRNstruct.GRNParams.num_genes;

    GRNstruct.locals.initial_guesses = zeros(num_edges + num_forced * (1 - fix_b) + num_genes * (1 - fix_P), 1);
    GRNstruct.locals.estimated_guesses = zeros(length(GRNstruct.locals.initial_guesses), 1);
   
end