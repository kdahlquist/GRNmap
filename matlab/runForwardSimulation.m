function GRNstruct = runForwardSimulation (GRNstruct)
    global deletion
    simulation_timepoints = GRNstruct.controlParams.simulation_timepoints;
    x0 = GRNstruct.GRNParams.x0;
    for qq = 1:length(GRNstruct.microData)
        deletion = GRNstruct.microData(qq).deletion;
        % t is the time points for which we did the forward simulation. It's
        % always the same as simulation_timepoints.
        % model is the expression of each gene in the network at each of those
        % time points in t.
        if strcmpi(GRNstruct.controlParams.production_function, 'Sigmoid')
            [~,model] = ode45(@general_network_dynamics_sigmoid,simulation_timepoints,x0);
        else
            [~,model] = ode45(@general_network_dynamics_mm,simulation_timepoints,x0);
        end
        GRNstruct.GRNModel(qq).model                             = (log2(model))';
    end
end