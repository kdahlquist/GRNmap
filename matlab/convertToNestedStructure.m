function compressedData = convertToNestedStructure( timepoints, raw )

    if (isempty(raw))
        errorMsg = 'Empty input sheet given.';
        errordlg(errorMsg, 'Missing Data');
        error('convertToNestedStructure:MissingData', errorMsg);
    end
    compressedData = cell(size(raw, 1), length(timepoints));

    % This takes care of heading (timepoints) for each column
    for index = 1:length(timepoints)
        compressedData{1, index} = timepoints(index).t;
    end

    firstRowData = raw (1, 1:end);

    for row = 2:size(raw, 1)
        dataMat = [];
        dataIndex = 1;
        compressedDataColumnCounter = 1;
        previousTimepoint = firstRowData(1, 1);
        for col = 1:length(raw)

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

                compressedData{row, compressedDataColumnCounter} = dataMat;
                compressedDataColumnCounter = compressedDataColumnCounter + 1;
                dataMat = [];
                dataIndex = 1;
            end

            if ~isnan(raw(row, col))
                currentDataMat = [raw(row, col); dataIndex];
                dataMat = [dataMat currentDataMat];
            end

            dataIndex = dataIndex + 1;
            previousTimepoint = firstRowData(1, col);
        end

        compressedData{row, compressedDataColumnCounter} = dataMat;
    end

end
