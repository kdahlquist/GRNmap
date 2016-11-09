function GRNstruct = compressMissingData (GRNstruct)

    global Strain
    simulation_timepoints = GRNstruct.controlParams.simulation_timepoints;
    % Naming new data expressionData

    % Iterates through rawExpressionData(microData) for every
    % unique timepoint compressing data into new data structure
    currentTimePoint = 0;
    currentTimePointIndex = 1;

    for index = 1:length(Strain)
        GRNstruct.expressionData(index).data = struct();
    end

end