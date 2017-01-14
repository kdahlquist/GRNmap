function expressionData = convertToNestedStructure( timepoints, rawExpressionData )

    expressionData = cell(size(rawExpressionData, 1), length(timepoints));
    
    % This takes care of heading (timepoints) for each column
    for index = 1:length(timepoints)
        expressionData{1, index} = timepoints(index).t;
    end    
        
    firstRowData = rawExpressionData (1, 1:end);
    dataIndex = 1;
    
    % Traverse the raw data matrix by row and then by column
    for row = 2:size(rawExpressionData, 1)
        dataMat = [];
        % column counter is here so we know where to put 
        % the accumulator matrix
        expressionDataColumnCounter = 1;
        for col = 1:length(rawExpressionData)
            
            % Check if the current column is a replicate
            if col > 1 && firstRowData(1, col - 1) ~= firstRowData(1, col)
                
                % store the accumulator matrix that contains the data of a 
                % single row of a timepoint
                expressionData{row, expressionDataColumnCounter} = dataMat;
                expressionDataColumnCounter = expressionDataColumnCounter + 1;
                
                % reset the accumulator matrix and index
                dataMat = [];
                dataIndex = 1;
            end
            % we only accumulate the values that are not NaN
            if ~isnan(rawExpressionData(row, col))
                
                % make a vector for the individual value and its index
                currentDataMat = [rawExpressionData(row, col); dataIndex];
                
                % append the vector to the accumulator matrix
                dataMat = [dataMat currentDataMat];
            end
            
            dataIndex = dataIndex + 1;
        end      
        % Repeated code just so the damn thing works
        expressionData{row, expressionDataColumnCounter} = dataMat;
    end
            
end

