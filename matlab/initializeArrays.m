function GRNstruct = initializeArrays (GRNstruct)
    % We can get rid of these globals later

    num_edges             = GRNstruct.GRNParams.num_edges;
    num_forced            = GRNstruct.GRNParams.num_forced;
    num_genes             = GRNstruct.GRNParams.num_genes;
    fix_b                 = GRNstruct.controlParams.fix_b;
    fix_P                 = GRNstruct.controlParams.fix_P;
    expression_timepoints = GRNstruct.GRNParams.expression_timepoints;

    for i = 1:length(GRNstruct.expressionData)
       GRNstruct.GRNModel(i).model = zeros(num_genes, length(GRNstruct.controlParams.simulation_timepoints));
       GRNstruct.GRNModel(i).simulation_timepoints = zeros(length(GRNstruct.controlParams.simulation_timepoints), 1);
    end

    GRNstruct.locals.initial_guesses = zeros(num_edges + num_forced * (1 - fix_b) + num_genes * (1 - fix_P), 1);
    GRNstruct.locals.estimated_guesses = zeros(length(GRNstruct.locals.initial_guesses), 1);

    GRNstruct.GRNOutput.MSE = zeros(num_genes, length(GRNstruct.expressionData));
    GRNstruct.GRNOutput.d = zeros(num_genes, length(GRNstruct.expressionData(1).raw));
    GRNstruct.GRNOutput.prorate = zeros(num_genes, 1);
    GRNstruct.GRNOutput.degrate = zeros(num_genes, 1);
    GRNstruct.GRNOutput.wts = zeros(num_edges, 1);
    GRNstruct.GRNOutput.b = zeros(num_genes, 1);
    GRNstruct.GRNOutput.adjacency_mat = zeros(num_genes, num_genes);
    GRNstruct.GRNOutput.active = zeros(1, num_genes);
    GRNstruct.GRNOutput.tspan = zeros(1, length(expression_timepoints));
end
