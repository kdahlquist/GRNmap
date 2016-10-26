function GRNstruct = lse(GRNstruct)
% USAGE: GRNstruct = lse(GRNstruct)
% 
% Purpose: perform parameter estimation to fit model to data
%
% Input and output: GRNstruct, a data structure containing all relevant
%                   GRNmap data

global counter fix_b fix_P log2FC lse_out penalty_out prorate Strain b is_forced SSE     

% We store relevant values and matrices from
% the struct into local variables
positions      = GRNstruct.GRNParams.positions;
num_edges      = GRNstruct.GRNParams.num_edges;
num_genes      = GRNstruct.GRNParams.num_genes;
num_forced     = GRNstruct.GRNParams.num_forced;
is_forced      = GRNstruct.GRNParams.is_forced;
estimate_params = GRNstruct.controlParams.estimate_params;
kk_max         = GRNstruct.controlParams.kk_max;
MaxIter        = GRNstruct.controlParams.MaxIter;
MaxFunEval     = GRNstruct.controlParams.MaxFunEval;
TolFun         = GRNstruct.controlParams.TolFun;
TolX           = GRNstruct.controlParams.TolX;
wtmat          = GRNstruct.GRNParams.wtmat;

b              = GRNstruct.GRNParams.b;

% initial_guesses contains all weights, and optionally the threshholds for
% controlled genes and optionally the production rates
initial_guesses = zeros(num_edges + num_forced * (1 - fix_b) + num_genes * (1- fix_P),1);

% We read across the weight matrix row by row and add all nonzero entries
% to the initial_guesses vector.

for ii = 1:num_edges
    initial_guesses(ii) = wtmat(positions(ii,1),positions(ii,2));
end
offset = num_edges;
if ~fix_b
    for ii = 1:num_forced
        initial_guesses(ii+offset) = b(is_forced(ii));
    end
end

% If the production rates aren't fixed
% We add the production rates to the initial_guesses vector.
offset = num_forced*(1-fix_b) + num_edges;
if ~fix_P
    for ii = 1:num_genes
        initial_guesses(ii+offset) = prorate(ii);
    end
end

% We set upper and lower bounds 
lb              = zeros(size(initial_guesses));
lb(1:num_edges) = -10 * ones(num_edges,1);
ub              = 10 * ones(size(initial_guesses));


if ~fix_b
    lb(num_edges+1:num_forced+num_edges) = -10 * ones(num_forced,1);
end

% Call the least squares error program, store the sum of the squares of the
% errors in lse_0
populateGlobals(GRNstruct);

counter = 0;
GRNstruct.GRNOutput.lse_0   = general_least_squares_error(initial_guesses);
GRNstruct.GRNOutput.lse_out = lse_out;
estimated_guesses           = initial_guesses;
GRNstruct.GRNOutput.reg_out = penalty_out;
GRNstruct.GRNOutput.counter = counter;

if estimate_params
    % This performs the optimization
    for kk = 1:kk_max
        options = optimset('Algorithm','interior-point','MaxIter',MaxIter,'MaxFunEval',MaxFunEval,'TolX',TolX,'TolFun',TolFun);
        estimated_guesses = fmincon(@general_least_squares_error,estimated_guesses,[],[],[],[],lb,ub,[],options);
        [GRNstruct.GRNOutput.lse_final, strain_data] = general_least_squares_error(estimated_guesses);
        GRNstruct.GRNOutput.lse_out = lse_out;
        % lse_1   = L;
        % pen     = penalty_out;
    end
    GRNstruct.GRNOutput.reg_out = penalty_out;
    GRNstruct.GRNOutput.counter = counter;
else
    GRNstruct.GRNOutput.reg_out = NaN;
    GRNstruct.GRNOutput.counter = 0;
end

% Make optimization diagnostic ih the counter is
% less than 100.

               
if counter < 100 && estimate_params
    graphData = struct('strain_data',strain_data,...
                   'estimated_guesses',estimated_guesses,...
                   'log2FC',log2FC,...
                   'num_of_strains', length(Strain),...
                   'LSE',GRNstruct.GRNOutput.lse_final);
               
    createDiagnosticsGraph(graphData, counter);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This is the forward simulation, which is performed for every single strain
% The simulation gives the gene expression at each of the time 
% points specified by simulation_timepoints
runForwardSimulation(GRNstruct);

% We need initial_guesses and w1 later on, so we'll append them to the structure.
GRNstruct.locals.initial_guesses = initial_guesses;

GRNstruct.locals.estimated_guesses = estimated_guesses;

GRNstruct.GRNOutput.SSE = SSE;
