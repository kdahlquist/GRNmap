function GRNstruct = globalToStruct(GRNstruct)
    global adjacency_mat alpha b counter expression_timepoints ...
           degrate lse_out penalty_out MSE wts prorate
    
    GRNstruct.GRNOutput.adjacency_mat = adjacency_mat;
    GRNstruct.GRNOutput.prorate       = prorate;
    GRNstruct.GRNOutput.degrate       = degrate;
    GRNstruct.GRNOutput.wts           = wts;
    GRNstruct.GRNOutput.b             = b;
    GRNstruct.GRNOutput.tspan         = expression_timepoints;
    GRNstruct.GRNOutput.alpha         = alpha;
    GRNstruct.GRNOutput.lse_out       = lse_out;
    GRNstruct.GRNOutput.MSE           = MSE;
    
    if GRNstruct.controlParams.estimate_params
        GRNstruct.GRNOutput.reg_out   = penalty_out;
        GRNstruct.GRNOutput.counter   = counter;
    else
        GRNstruct.GRNOutput.reg_out   = NaN;
        GRNstruct.GRNOutput.counter   = 0;
    end
end