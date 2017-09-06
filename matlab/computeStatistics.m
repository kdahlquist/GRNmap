function computeStatistics(GRNstruct)
    % USAGE: GRNstruct = computeStatistics(GRNstruct)
    %
    % Purpose: perform minLSE, stdev, and avg calculations and stores them in
    %          the struct.
    %
    % Input and output: a GRNstruct with compressMissingData having already
    %                    been called on it

    expression_timepoints = GRNstruct.GRNParams.expression_timepoints;
    num_genes = GRNstruct.GRNParams.num_genes;
    log2FC = GRNstruct.expressionData;

    for i = 1:length(GRNstruct.expressionData.strain)
        GRNstruct.expressionData(i).avg      = zeros(GRNstruct.GRNParams.num_genes,GRNstruct.GRNParams.num_times);
        GRNstruct.expressionData(i).stdev    = zeros(GRNstruct.GRNParams.num_genes,GRNstruct.GRNParams.num_times);

        for timepointIndex = 1:length(expression_timepoints)
            for geneIndex = 1:num_genes
                truncatedData = log2FC(qq).compressed(2:end, :);
                dataCell = truncatedData{geneIndex, timepointIndex};

                GRNstruct.expressionData(i).avg(:,iT)    = mean(dataCell,2);
                GRNstruct.expressionData(i).stdev(:,iT)  = std(dataCell,0,2);

                delDataAvg = dataCell - GRNstruct.expressionData(i).avg(:,iT) * ones(1,length(dataCell(1,:)));

                GRNstruct.GRNParams.nData   = GRNstruct.GRNParams.nData  + length(dataCell(:));
                GRNstruct.GRNParams.minLSE  = GRNstruct.GRNParams.minLSE + sum(delDataAvg(:).^2);
            end
        end
    end
