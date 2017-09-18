function GRNstruct = readInputSheet(GRNstruct)
% USAGE: GRNstruct = readInputSheet(GRNstruct)
%
% Purpose: (1) load input data from excel workbook
%          (2) parse data into necessary containers
%          (3) compute descriptive statistics (means, variances, etc)
%          (4) extract basic parameters (network size, etc)
%
% Input and output: GRNstruct, a data structure containing all relevant
%                   GRNmap data

alpha = 0;
fix_b = 0;
fix_P = 0;
production_function = {};
expression_timepoints = [];

% If we do multiple runs in a row the Strain variable should be cleared
% before each run.

Strain = [];


input_file = GRNstruct.inputFile;
GRNstruct.expressionData = {};

[parms0,parmnames0] = xlsread(input_file,'optimization_parameters');
[numRows,numCols] = size(parmnames0);

% This part of the code reads the optimization parameter sheet and creates
% variables for the parameters.

for currentRow = 2:numRows
    % Gives us the indexes of the numerical values in the row.
    indexVec = find(isnan(parms0(currentRow-1,:))==0);

    % If the parameter in the sheet has numerical values in its row,
    % create a row vector with that paramter's name and whose values are
    % the numerical entries in that row
    if ~isempty(indexVec)
        eval([parmnames0{currentRow,1} '= [' num2str(parms0(currentRow-1,indexVec)) '];']);

    % If the parameter in the sheet has strings in its row, we create a
    % cell array with that parameter's name and whose values are the
    % strings in that row.
    else
        currentCol = 2;
        % If we are at the end of the row or if there is no string at the
        % current column, we're done. Otherwise, add string to cell array.
        while currentCol <= numCols
           parmstr = parmnames0{currentRow,currentCol};
           if isempty(parmstr)
               break
           end
           eval([parmnames0{currentRow,1} '{currentCol - 1}= parmstr;']);
           currentCol = currentCol + 1;
        end
    end
end

% This reads the microarray data for each strain.
for index = 1:length(Strain)
    currentStrain = strtrim(lower(Strain{index}));
    [GRNstruct.expressionData(index).raw,GRNstruct.labels.TX1] = xlsread(input_file,[currentStrain '_log2_expression']);
    GRNstruct.expressionData(index).strain = currentStrain;

    genes = strtrim(lower(GRNstruct.labels.TX1(2:end,1)));

    if strcmp(currentStrain,'wt')
        deletedRow = 0;
    else
        deletedGene = currentStrain(2:end);
        deletedRow = find(strcmpi(genes,deletedGene));
    end

    GRNstruct.expressionData(index).deletion = deletedRow;
    GRNstruct.expressionData(index).strain = Strain(index);

end

% Populate the structure
[GRNstruct.degRates,GRNstruct.labels.TX0]                = xlsread(input_file,'degradation_rates');
[GRNstruct.GRNParams.wtmat,GRNstruct.labels.TX2]         = xlsread(input_file,'network_weights');
[GRNstruct.GRNParams.adjacency_mat,GRNstruct.labels.TX3] = xlsread(input_file,'network');
[GRNstruct.GRNParams.prorate,GRNstruct.labels.TX5]       = xlsread(input_file,'production_rates');
% Describes the geometry of the gene regulatory network.

GRNstruct.GRNParams.alpha                            = alpha;
GRNstruct.GRNParams.num_strains                      = length(Strain);
GRNstruct.GRNParams.num_edges                        = sum(GRNstruct.GRNParams.adjacency_mat(:));
GRNstruct.GRNParams.num_genes                        = size(GRNstruct.GRNParams.adjacency_mat,2);
GRNstruct.GRNParams.active                           = 1:GRNstruct.GRNParams.num_genes;

GRNstruct.GRNParams.expression_timepoints            = expression_timepoints;
GRNstruct.GRNParams.num_times                        = length(expression_timepoints);

% Describes the runtime paramters given by the user in the
% optimization_paramenters sheet
GRNstruct.controlParams.simulation_timepoints        = zeros(1, length(simulation_timepoints));
GRNstruct.controlParams.simulation_timepoints        = simulation_timepoints;
% The following are used as parameters for fmincon. Refer to fmincon
% documentation for the meaning of these variables
GRNstruct.controlParams.kk_max                       = kk_max;
GRNstruct.controlParams.MaxIter                      = MaxIter;
GRNstruct.controlParams.MaxFunEval                   = MaxFunEval;
GRNstruct.controlParams.TolFun                       = TolFun;
GRNstruct.controlParams.TolX                         = TolX;

GRNstruct.controlParams.estimate_params              = estimate_params;
GRNstruct.controlParams.make_graphs                  = make_graphs;
GRNstruct.controlParams.production_function          = production_function;
GRNstruct.controlParams.fix_b                        = fix_b;
GRNstruct.controlParams.fix_P                        = fix_P;
GRNstruct.controlParams.L_curve                      = L_curve;

% Populate the global variables

if strcmpi(GRNstruct.controlParams.production_function, 'Sigmoid')
    [GRNstruct.GRNParams.b,GRNstruct.labels.TX6] = xlsread(input_file,'threshold_b');
else
    GRNstruct.controlParams.fix_b = 1;
    GRNstruct.GRNParams.b = zeros(length(GRNstruct.degRates),1);
end

%TX1 contains both the systemic and standard names
%TX11 is the list of standard (common) names
%%Revision to old way of computing TX11

% for ii = 1:length(GRNstruct.expressionData(1).data(:,1));
%     GRNstruct.labels.TX11{ii,1} = GRNstruct.labels.TX1{ii,2};
% end

% To be read by the program correctly, prorate and degrate need to be row
% vectors instead of column vectors, so we use the transpose of the array
% obtained from the datafile
% prorate         = prorate';
GRNstruct.degRates = GRNstruct.degRates';

% We use variables wherever we would need numbers that might change if we
% are using a different network.

GRNstruct.GRNParams.nData   = 0;
GRNstruct.GRNParams.minLSE  = 0;

for i = 1:length(Strain)
    GRNstruct.expressionData(i).t = {};
    % The first row of the GRNstruct.expressionData data indicating all of the replicate timepoints
    reps = (GRNstruct.expressionData(i).raw(1,:));
    % Finds the indices in reps that correspond to each timepoint in tspan.
    for jj = 1:length(expression_timepoints)
        GRNstruct.expressionData(i).t(jj).indx                = find(reps == expression_timepoints(jj));
        GRNstruct.expressionData(i).t(jj).t                   = expression_timepoints(jj);
    end
    % GRNstruct.expressionData data for all strains
    % GRNstruct.expressionData(i).raw  = (GRNstruct.expressionData(i).d(2:end,:));

    % TODO Move the code below into a function of its own, and call that function
    %      only after 'compressMissingData' is called.
    %
    % 1. Check that minLSE is calculated correctly (#353)
    % 2. Check that sigmas (stdev) are calculated correctly (#352)
    % 3. Check that means (avg) are calculated correctly
end

% # of interactions between controlling and affected TF's
% sum each row of matrix adjacency_mat (network)
num_controlling_genes = sum(GRNstruct.GRNParams.adjacency_mat,2);

% Whether or not genes are affected T(1)/F(0)
is_controlled                  = num_controlling_genes > 0;
GRNstruct.GRNParams.no_inputs  = find(is_controlled == 0);
GRNstruct.GRNParams.is_forced  = find(is_controlled == 1);
GRNstruct.GRNParams.num_forced = sum(is_controlled);

% Where the edges are in the network
% rows corresponds to row (genes affected)
% columns correspond to column (genes controlling)
% Positions gives us ordered pair of genes in the form of
% (aff_gene, contr_gene), where the first gene is controlled
% by the second gene.
[rows,columns]                 = find(GRNstruct.GRNParams.adjacency_mat == 1);
GRNstruct.GRNParams.positions  = sortrows([rows,columns],1);

GRNstruct.GRNParams.x0 = ones(GRNstruct.GRNParams.num_genes,1);
end
