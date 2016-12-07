function GRNstruct = compressMissingData (GRNstruct)

    for index = 1:length(GRNstruct.expressionData)
        index_of_replicate = GRNstruct.expressionData(index).t.indx;
        timepoints_for_replicate = GRNstruct.expressionData(index).t.t;
%       We really should change the names above

        

        GRNstruct.expressionData(index).data = convertToNestedStructure(...
            GRNstruct.controlParams.expression_timepoints,...
            GRNstruct.microData(index).data...
        );
    end

end