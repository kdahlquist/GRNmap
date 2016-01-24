function GRNstruct = GRNLCurve(GRNstruct)

[p,n,ext] = fileparts(GRNstruct.inputFile);
% alphaList = [0.8,0.5,0.2,0.1,0.08,0.05,0.02,0.01,0.008,0.005,0.002,0.001,0.0008,0.0005,0.0002,0.0001];
alphaList = [0.1,0.01,0.001,0.0001]';

nalist    = length(alphaList);

LCurveData      = zeros(nalist,3);
LCurveData(:,1) = alphaList;

for iAlpha = 1:nalist

        newFileName  = [n '_' num2str(iAlpha) ext];
        newInputFile = [GRNstruct.directory newFileName];
        
        eval(['!copy ' GRNstruct.inputFile ' ' newInputFile]);
        
        GRNstruct.fileName = newFileName;
        GRNstruct.inputFile = newInputFile;
        
        xlswrite(newInputFile,alphaList(iAlpha),'optimization_parameters','B2');
        
        % Take the information from the previous run and use it as the
        % initial condition for the next run.
        if iAlpha >=2 
            
            oldFileName  = [n '_' num2str(iAlpha-1) '_output' ext];
            oldInputFile = [GRNstruct.directory oldFileName];
            
            [dataVals,txtVals]  = xlsread(oldInputFile,'network_optimized_weights');
            [nVals,mVals]       = size(dataVals);
            
            for ii = 1:nVals
                for jj = 1:mVals
                    txtVals{ii+1,jj+1} = dataVals(ii,jj);
                end
            end
            
            xlswrite(newInputFile,txtVals,'network_weights');
            
            if ~GRNstruct.controlParams.fix_P 
                [dataVals,txtVals]  = xlsread(oldInputFile,'optimized_production_rates');
                [nVals,mVals]       = size(dataVals);
            
                for ii = 1:nVals
                    txtVals{ii+1,3} = dataVals(ii,1);
                end
                xlswrite(newInputFile,txtVals,'production_rates');
            end
            if ~GRNstruct.controlParams.fix_b 
                [dataVals,txtVals]  = xlsread(oldInputFile,'optimized_threshold_b');
                [nVals,mVals]       = size(dataVals);
            
                for ii = 1:nVals
                    txtVals{ii+1,3} = dataVals(ii,1);
                end
                xlswrite(newInputFile,txtVals,'threshold_b');
            end 
        end  

        % Back Simulation
        % Populates the structure as well as the global variables
        GRNstruct = readInputSheet(GRNstruct);
        % Do the forward simulation and parameter estimation
        GRNstruct = lse(GRNstruct);
        % Output plots, .mat files, and excel sheet
        GRNstruct = output(GRNstruct);
        
        LCurveData(iAlpha,2) = GRNstruct.GRNOutput.lse_out;
        LCurveData(iAlpha,3) = GRNstruct.GRNOutput.reg_out;

end

LCurveFile = [p n 'LCurve'];

eval(['save ' LCurveFile 'LCurveData'])