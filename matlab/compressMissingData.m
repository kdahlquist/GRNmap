function GRNstruct = compressMissingData (GRNstruct)

    for index = 1:length(GRNStruct.Strain)
        GRNstruct.expressionData(index).data = convertToNestedStructure(...
            GRNstruct.controlParams.expression_timepoints,...
            GRNstruct.microData(index).data...
        );
    end

end