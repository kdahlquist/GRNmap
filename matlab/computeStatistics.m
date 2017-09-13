function GRNstruct = computeStatistics(GRNstruct)
    % USAGE: GRNstruct = computeStatistics(GRNstruct)
    %
    % Purpose: perform minLSE, stdev, and avg calculations and stores them in
    %          the struct.
    %
    % Input and output: a GRNstruct with compressMissingData having already
    %                    been called on it is given as input and outputs a
    %                    GRNstruct with statistics data stored in it

    GRNstruct.GRNParams.nData   = 0;
    GRNstruct.GRNParams.minLSE  = 0;
    expression_timepoints = GRNstruct.GRNParams.expression_timepoints;
    num_genes = GRNstruct.GRNParams.num_genes;
    num_strains = GRNstruct.GRNParams.num_strains;

    for i = 1:num_strains
        GRNstruct.expressionData(i).avg      = zeros(GRNstruct.GRNParams.num_genes,GRNstruct.GRNParams.num_times);
        GRNstruct.expressionData(i).stdev    = zeros(GRNstruct.GRNParams.num_genes,GRNstruct.GRNParams.num_times);

        for timepointIndex = 1:length(expression_timepoints)
            for geneIndex = 1:num_genes
                truncatedData = GRNstruct.expressionData(i).compressed(2:end, :);
                dataCell = truncatedData{geneIndex, timepointIndex};
                
                cellMean = mean(dataCell(1,:),2);
                cellStd = std(dataCell(1,:),0,2);

                GRNstruct.expressionData(i).avg(geneIndex,timepointIndex) = cellMean;
                GRNstruct.expressionData(i).stdev(geneIndex,timepointIndex) = cellStd;

                delDataAvg = dataCell(1,:) - GRNstruct.expressionData(i).avg(geneIndex,timepointIndex) * ones(1,length(dataCell(1,:)));

                GRNstruct.GRNParams.nData   = GRNstruct.GRNParams.nData  + length(dataCell(:));
                GRNstruct.GRNParams.minLSE  = GRNstruct.GRNParams.minLSE + sum(delDataAvg(:).^2);
            end
        end
    end
