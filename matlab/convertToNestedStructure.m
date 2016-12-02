function expressionData = convertToNestedStructure( expression_timepoints, rawExpressionData )

    expressionData = cell();
    
    prevTimepoint = -1;
    for index = 1:length(expression_timepoints)
        if expression_timepoints(index) ~= prevTimepoint
           prevTimepoint = expression_timepoints(index);
           sizes = cellfun('length', expressionData);
           expressionData{sizes(1) + 1 , 1} = expression_timepoints(index);
        end
    end    
    
    for index = 1:length(rawExpressionData)
        % TODO: Nested Matrix Dissection
    end    

end

