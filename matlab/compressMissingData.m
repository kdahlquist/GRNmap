function GRNstruct = compressMissingData (GRNstruct)

    for index = 1:length(GRNstruct.expressionData)
        GRNstruct.expressionData(index).compressed = convertToNestedStructure(...
            GRNstruct.expressionData(index).t,...
            GRNstruct.expressionData(index).raw...
        );
    end

end
