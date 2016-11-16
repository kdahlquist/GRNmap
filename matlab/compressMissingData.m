function GRNstruct = compressMissingData (GRNstruct)

    expression_timepoints = GRNstruct.controlParams.expression_timepoints;
    % Naming new data expressionData

    % Iterates through rawExpressionData(microData) for every
    % unique timepoint compressing data into new data structure
    currentTimePoint = 0;
    currentTimePointIndex = 1;

    for index = 1:length(GRNStruct.Strain)
        GRNstruct.expressionData(index).data = {};
    end

end