function GRNstruct = compressMissingData (GRNstruct)
    
    for index = 1:length(GRNstruct.microData)
        GRNstruct.expressionData(index).data = convertToNestedStructure(...
            GRNstruct.microData(index).t,...
            GRNstruct.microData(index).data...
        );
    end
    
end