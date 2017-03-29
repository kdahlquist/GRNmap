function GRNstruct = compressMissingData (GRNstruct)
    
    for index = 1:length(GRNstruct.rawExpressionData)
        GRNstruct.expressionData(index).data = convertToNestedStructure(...
            GRNstruct.rawExpressionData(index).t,...
            GRNstruct.rawExpressionData(index).data...
        );
    end
    
end