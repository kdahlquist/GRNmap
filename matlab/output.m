function GRNstruct = output(GRNstruct)
% USAGE: GRNstruct = output(GRNstruct)
%
% Purpose: (1) call graphs if desired to produce output graph files
%          (2) parse data into necessary containers for output
%          (3) save excel workbook with output data
%          (4) save matlab .mat file with output data
%
% Input and output: GRNstruct, a data structure containing all relevant
%                   GRNmap data

if GRNstruct.controlParams.make_graphs
    GRNstruct = graphs(GRNstruct);
end

warning('off','MATLAB:xlswrite:AddSheet');

GRNstruct.GRNOutput.name    = GRNstruct.inputFile;
GRNstruct.GRNOutput.active  = GRNstruct.GRNParams.active;

adjacency_mat               = GRNstruct.GRNOutput.adjacency_mat;
degrate                     = GRNstruct.GRNOutput.degrate;
prorate                     = GRNstruct.GRNOutput.prorate;
b                           = GRNstruct.GRNOutput.b;

expression_timepoints       = GRNstruct.GRNParams.expression_timepoints;
directory                   = GRNstruct.directory;

positions                   = GRNstruct.GRNParams.positions;
num_edges                   = GRNstruct.GRNParams.num_edges;
num_forced                  = GRNstruct.GRNParams.num_forced;
is_forced                   = GRNstruct.GRNParams.is_forced;
num_genes                   = GRNstruct.GRNParams.num_genes;
no_inputs                   = GRNstruct.GRNParams.no_inputs;
num_times                   = GRNstruct.GRNParams.num_times;

simulation_timepoints       = GRNstruct.controlParams.simulation_timepoints;
production_function         = GRNstruct.controlParams.production_function;
fix_b                       = GRNstruct.controlParams.fix_b;

initial_guesses             = GRNstruct.locals.initial_guesses;
estimated_guesses           = GRNstruct.locals.estimated_guesses;

strain_length               = length(GRNstruct.expressionData);

[~,name,ext]                = fileparts(GRNstruct.inputFile);
output_file                 = [directory name '_output' ext];
output_mat                  = [directory name '_output.mat'];
copyfile(GRNstruct.inputFile, output_file, 'f');

for qq = 1:strain_length

    for ik = 1:num_genes+1

%       The id's for each gene is copied over from the "degradation_rates"
%       spreadsheet. This assumes that each of the genes are in the same in
%       each sheet.
        outputnet{1,ik}   = GRNstruct.labels.TX2{1,ik};
        outputnet{ik,1}   = GRNstruct.labels.TX2{1,ik};
        outputcells{ik,1} = GRNstruct.labels.TX0{ik,1};
        outputdata{ik,1}  = GRNstruct.labels.TX0{ik,1};
        outputdeg{ik,1}   = GRNstruct.labels.TX0{ik,1};
        outputpro{ik,1}   = GRNstruct.labels.TX0{ik,1};
        outputsigmas{ik,1}= GRNstruct.labels.TX0{ik,1};

        if ik>=2
            for jj = 2:length(simulation_timepoints)+1
                outputcells{ik,jj} = GRNstruct.GRNModel(qq).model(ik-1,jj-1);
            end
            for jj = 2:num_times+1
                outputdata{ik,jj} = GRNstruct.expressionData(qq).raw(ik,jj-1);
                outputsigmas{ik,jj} = GRNstruct.expressionData(qq).stdev(ik-1,jj-1);
            end
            for jj = 2:num_genes+1
                outputnet{jj,ik} = adjacency_mat(jj-1,ik-1);
            end
            outputpro{ik,2} = prorate(ik-1);
            outputdeg{ik,2} = degrate(ik-1);

        else
            outputdeg{ik,2} = GRNstruct.labels.TX0{ik,2};
            outputpro{ik,2} = 'production_rate';

            for jj = 2:length(simulation_timepoints)+1
                outputcells{ik,jj} = simulation_timepoints(jj-1);
            end
            for jj = 2:num_times+1
                outputdata{ik,jj}   = expression_timepoints(jj-1);
                outputtimes{1,jj}     = expression_timepoints(jj-1);
                outputsigmas{ik,jj} = expression_timepoints(jj-1);
            end
        end
    end

    outputSigmaCells{qq} = outputsigmas;
    GRNstruct.GRNOutput.d = GRNstruct.expressionData(qq).raw(2:end,:);
    xlswrite(output_file,outputcells,[cell2mat(GRNstruct.expressionData(qq).strain) '_log2_optimized_expression']);
end
for qq = 1:strain_length
    xlswrite(output_file,outputSigmaCells{qq},[cell2mat(GRNstruct.expressionData(qq).strain) '_sigmas']);
end

% Change to if not fix_p. Basically if we don't fix the production
% rates we want to output the optimized production rates.

if GRNstruct.controlParams.estimate_params && ~GRNstruct.controlParams.fix_P
    xlswrite(output_file,outputpro,'optimized_production_rates');
end

% This data is already copied over from the original input sheet.
% xlswrite(output_file,outputtimes,'out_measurement_times');
% xlswrite(output_file,outputnet,'out_network');

for ii = 1:num_edges
    outputnet{positions(ii,1)+1,positions(ii,2)+1} = initial_guesses(ii);
end

% This data is already copied over from the original input sheet.
% xlswrite(output_file,outputnet,'out_network_weights');

if strcmpi(production_function, 'Sigmoid')
    outputpro{1,2} = 'threshold_b';
    if ~fix_b
        for ii = 1:num_forced
            outputpro{is_forced(ii)+1,2} = estimated_guesses(ii+num_edges);
        end
        for ii = 1:length(GRNstruct.GRNParams.no_inputs)
            outputpro{GRNstruct.GRNParams.no_inputs(ii)+1,2} = 0;
        end
        xlswrite(output_file,outputpro,'optimized_threshold_b');
    else
        for ii = 1:num_forced
            outputpro{is_forced(ii)+1,2} = b(is_forced(ii));
        end
        for ii = 1:length(no_inputs)
            outputpro{no_inputs(ii)+1,2} = 0;
        end
    end
end

for ii = 1:num_edges
    outputnet{positions(ii,1)+1,positions(ii,2)+1} = estimated_guesses(ii);
end

xlswrite(output_file,outputnet,'network_optimized_weights');


outputDiag{1,1} = 'Parameter';
outputDiag{1,2} = 'Value';
outputDiag{2,1} = 'LSE';
outputDiag{2,2} = GRNstruct.GRNOutput.lse_out;
outputDiag{3,1} = 'Penalty';
outputDiag{3,2} = GRNstruct.GRNOutput.reg_out;
outputDiag{4,1} = 'min LSE';
outputDiag{4,2} = GRNstruct.GRNParams.minLSE;
outputDiag{5,1} = 'iteration count';
outputDiag{5,2} = GRNstruct.GRNOutput.counter;

outputDiag{6,1} = ' ';
outputDiag{7,1} = 'Gene';

for qq = 1: strain_length

    strainString = [cell2mat(GRNstruct.expressionData(qq).strain) ' MSE'];
    outputDiag{7,1+qq} = strainString;
end

for ii = 1:num_genes
    outputDiag{7+ii,1} = GRNstruct.labels.TX0{1+ii,1};
    for jj = 1: strain_length
        outputDiag{7+ii,1+jj} = GRNstruct.GRNOutput.MSE(ii,jj);
    end
end

if GRNstruct.controlParams.estimate_params
    figure(1)
    if GRNstruct.controlParams.L_curve && GRNstruct.controlParams.make_graphs
        filename = [directory 'optimization_diagnostic_' num2str(GRNstruct.copy_counter)];
    else
        filename = [directory 'optimization_diagnostic'];
    end
    print(filename,'-djpeg')
end

close all
if isfield(GRNstruct,'copy_counter') && GRNstruct.copy_counter >= GRNstruct.alpha_list_length
   GRNstruct.copy_counter = 0;
end


xlswrite(output_file,outputDiag,'optimization_diagnostics');

save(output_mat);
