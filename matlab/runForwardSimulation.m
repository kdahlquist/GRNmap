% This is the forward simulation, which is performed for every single strain
% The simulation gives the gene expression at each of the time
% points specified by simulation_timepoints

function GRNstruct = runForwardSimulation (GRNstruct)
    global deletion
    simulation_timepoints = GRNstruct.controlParams.simulation_timepoints;
    x0 = GRNstruct.GRNParams.x0;
    for qq = 1:length(GRNstruct.expressionData)
        deletion = GRNstruct.expressionData(qq).deletion;
        % t is the time points for which we did the forward simulation. It's
        % always the same as simulation_timepoints.
        % model is the expression of each gene in the network at each of those
        % time points in t.
        if strcmpi(GRNstruct.controlParams.production_function, 'Sigmoid')
            [~,model] = ode45(@general_network_dynamics_sigmoid,simulation_timepoints,x0);
        else
            % Currently disabled until testing for Michaelis-Menten is completed!
            % [~,model] = ode45(@general_network_dynamics_mm,simulation_timepoints,x0);
        end
        GRNstruct.GRNModel(qq).model                             = (log2(model))';
    end
end
