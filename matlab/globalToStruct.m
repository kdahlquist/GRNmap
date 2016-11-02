function GRNstruct = globalToStruct(GRNstruct)
    global adjacency_mat alpha b counter expression_timepoints ...
           degrate lse_out penalty_out SSE wts prorate
    
    GRNstruct.GRNOutput.adjacency_mat = adjacency_mat;
    GRNstruct.GRNOutput.prorate = prorate;
    GRNstruct.GRNOutput.degrate = degrate;
    GRNstruct.GRNOutput.wts = wts;
    GRNstruct.GRNOutput.b = b;
    GRNstruct.GRNOutput.tspan = expression_timepoints;
    GRNstruct.GRNOutput.alpha = alpha;
    GRNstruct.GRNOutput.counter = counter;
    GRNstruct.GRNOutput.lse_out = lse_out;
    GRNstruct.GRNOutput.penalty_out = penalty_out;
    GRNstruct.GRNOutput.SSE = SSE;

%     We skipped log2FC due to too many parts
%     GRNstruct.microData = log2FC; 
end