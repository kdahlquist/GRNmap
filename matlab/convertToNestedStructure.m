function expressionData = convertToNestedStructure( timepoints, rawExpressionData )

    expressionData = cell(size(rawExpresionData, 1), timepoints.t);
    
    for index = 1:size(timepoints, 1)
        expressionData{1, index} = timepoints.t(index);
    end    
        
    for row = 1:size(rawExpressionData, 1)
        for col = 1:length(rawExpressionData)
            % TODO: Nested Matrix Dissection
            
%           if timepoints(2).indx = [4 5 6] -> [1 2 3] on expressionData
%             dataIndex = mod( , col);
            dataMat = [rawExpressionData(row, col); dataIndex];
            if ~isnan(rawExpressionData(row, col))
%                 expressionData{} = dataMat;
            end
        end 
    end
            
end

