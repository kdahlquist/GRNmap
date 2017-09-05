function computeStatistics(GRNstruct)
    for i = 1:length(Strain)
        GRNstruct.expressionData(i).avg      = zeros(GRNstruct.GRNParams.num_genes,GRNstruct.GRNParams.num_times);
        GRNstruct.expressionData(i).stdev    = zeros(GRNstruct.GRNParams.num_genes,GRNstruct.GRNParams.num_times);

        % The average GRNstruct.expressionData for each timepoint for each gene.
        for iT = 1:GRNstruct.GRNParams.num_times
            data = GRNstruct.expressionData(i).raw(2:end,GRNstruct.expressionData(i).t(iT).indx);

            GRNstruct.expressionData(i).avg(:,iT)    = mean(data,2);
            GRNstruct.expressionData(i).stdev(:,iT)  = std(data,0,2);

            delDataAvg = data - GRNstruct.expressionData(i).avg(:,iT)*ones(1,length(data(1,:)));

            GRNstruct.GRNParams.nData   = GRNstruct.GRNParams.nData  + length(data(:));
            GRNstruct.GRNParams.minLSE  = GRNstruct.GRNParams.minLSE + sum(delDataAvg(:).^2);
        end
    end
