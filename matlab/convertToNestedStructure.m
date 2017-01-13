function expressionData = convertToNestedStructure( timepoints, rawExpressionData )

    expressionData = cell(size(rawExpressionData, 1), size(timepoints, 1));
    
    % This takes care of heading (timepoints) for each column
    for index = 1:size(timepoints, 2)
        expressionData{1, index} = timepoints(index).t;
    end    
        
    firstRowData = rawExpressionData (1, 1:end);
    dataIndex = 1;
    
    for row = 2:size(rawExpressionData, 1)
        dataMat = [];
        expressionDataColumnCounter = 1;
        for col = 1:length(rawExpressionData)
            
            if col > 1 && firstRowData(1, col - 1) ~= firstRowData(1, col)
                
                expressionData{row, expressionDataColumnCounter} = dataMat;
                expressionDataColumnCounter = expressionDataColumnCounter + 1;
                
                dataMat = [];
                dataIndex = 1;
            end
            if ~isnan(rawExpressionData(row, col))
                currentDataMat = [rawExpressionData(row, col); dataIndex];
                dataMat = [dataMat currentDataMat];
            end
            
            dataIndex = dataIndex + 1;
        end 
    end
            
end

