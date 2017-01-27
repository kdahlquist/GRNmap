function expressionData = convertToNestedStructure( timepoints, rawExpressionData )

    if (isempty(rawExpressionData))
        errorMsg = 'Empty input sheet given.';
        errordlg(errorMsg, 'Missing Data');
        error('convertToNestedStructure:MissingData', errorMsg);
    end
    expressionData = cell(size(rawExpressionData, 1), length(timepoints));
    
    % This takes care of heading (timepoints) for each column
    for index = 1:length(timepoints)
        expressionData{1, index} = timepoints(index).t;
    end

    firstRowData = rawExpressionData (1, 1:end);

    for row = 2:size(rawExpressionData, 1)
        dataMat = [];
        dataIndex = 1;
        expressionDataColumnCounter = 1;
        previousTimepoint = firstRowData(1, 1);
        for col = 1:length(rawExpressionData)

            if previousTimepoint ~= firstRowData(1, col)
                if isequal(dataMat, [])
                    errorMsg = sprintf('Missing data for timepoint %d on row %d.', previousTimepoint, row);
                    errordlg(errorMsg, 'Missing Data');
                    error('convertToNestedStructure:MissingData', errorMsg);
                end

                if size(dataMat, 2) == 1
                    warningMsg = sprintf('Only 1 data exists for timepoint %d on row %d', previousTimepoint, row);
                    warndlg(warningMsg, 'Single Replicate Data');
                    warning('convertToNestedStructure:SingleReplicateData', warningMsg);
                end

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
            previousTimepoint = firstRowData(1, col);
        end

        expressionData{row, expressionDataColumnCounter} = dataMat;
    end

end
