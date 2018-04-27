function [L,strain_x1] = general_least_squares_error(theta)
% USAGE  L = general_least_squares_error(theta)
%
% Purpose: compute fit criterion for minimization purposes
%          designed to be called by MATLAB minimization functions
%          all parameters (weights, b's, production rates) must be
%          stacked into a single input vector (theta)
%
% Input:  theta = vector of parameters we modify to fit data to model
% Output: L     = penalized least squares fit criterion

global adjacency_mat alpha b is_forced counter deletion fix_b fix_P log2FC lse_out penalty_out prorate production_function strain_length expression_timepoints wts
global MSE

counter = counter + 1;

num_edges = sum(adjacency_mat(:));

num_forced  = sum(sum(adjacency_mat,2)>0);

num_genes = length(adjacency_mat(1,:));

wts = theta(1:num_edges);

% We read the values for b and P from the initial_guesses vector
P_offset = num_forced*(1-fix_b)+num_edges;
if ~fix_b
    b(is_forced) = theta(num_edges + 1:num_forced + num_edges);
end
if ~fix_P
    prorate = theta(P_offset + 1:P_offset + num_genes);
end

% Initial concentrations
x0 = ones(num_genes,1);

if expression_timepoints(1) > 1e-6
    tspan1 = [0;expression_timepoints(:)];
    addzero = 1;
else
    tspan1 = expression_timepoints;
    addzero = 0;
end

nData           = 0;
errorWholeModel = 0;
MSE             = zeros(num_genes, strain_length);

% This needs to be outputed to create the graph.
strain_x1 = [];

for qq = 1: strain_length

    deletion = log2FC(qq).deletion;
    nGSE     = zeros(num_genes, 1);

    errorMatStrain = zeros(num_genes, 1);

    % % Matlab uses the o.d.e. solver function to obtain the data from our model
    %     [t,x] = ode45('general_network_dynamics_sigmoid',tspan1,x0);
    if strcmpi(production_function, 'Sigmoid')
        % The ~ was previously a t, which was previously unused
        [~,x] = ode45('general_network_dynamics_sigmoid',tspan1,x0);
    else if strcmpi(production_function, 'MM')
        % Currently disabled until testing for Michaelis-Menten is completed!
        % [~,x] = ode45('general_network_dynamics_mm',tspan1,x0);
        disp('Warning: MM detected for GLSE');
    end

    if addzero == 1;
        x1 = x(2:end,:);
    else
        x1 = x;
    end

    strain_x1 = [strain_x1;x1];

    for timepointIndex = 1:length(expression_timepoints)
        for geneIndex = 1:num_genes
            truncatedData = log2FC(qq).compressed(2:end, :);
            dataCell = truncatedData{geneIndex, timepointIndex};

            for replicateIndex = 1:size(dataCell, 2)
                errorMatStrain(geneIndex) = errorMatStrain(geneIndex) + ...
                    (log2(x1(timepointIndex, geneIndex)) - dataCell(1, replicateIndex))^2;
                nGSE(geneIndex) = nGSE(geneIndex) + 1;
                nData = nData + 1;
            end
        end
    end

    errorWholeModel = errorWholeModel + errorMatStrain;

    for geneIndex = 1:num_genes
        MSE(geneIndex, qq) = errorMatStrain(geneIndex) / nGSE(geneIndex);
    end
end

graphData = struct('strain_data',strain_x1,...
                   'estimated_guesses',theta,...
                   'log2FC',log2FC,...
                   'num_of_strains', strain_length,...
                   'LSE',  sum(errorWholeModel(:))/nData);

% Output graph every 100 iterations.
if rem(counter,100) ==  0
    createDiagnosticsGraph(graphData, counter)
end

% %%Set alpha for L curves
% alpha = 0.01;


% This is the sum of all the errors
L        = sum(errorWholeModel(:))/nData;
lse_out  = L;

% Add the penalty term to get the bowl shape for better optimization

bp = 0;
if fix_b == 1
    bp = b;
end

proratep = prorate;

if fix_P == 1
    proratep = 0*prorate;
end

penalty_out = ( wts'*wts + (b-bp)'*(b-bp) + proratep(:)'*proratep(:) )/length(theta);

L = L + alpha*penalty_out;

% L           = L + alpha*(wts')*wts + alpha*(b-bp)'*(b-bp) + alpha*sum(proratep(:))^2;
% L           = L + alpha*(wts')*wts + alpha*sum(proratep(:))^2;
% Store the penalty value
% penalty_out = (wts'*wts + (b-bp)'*(b-bp) + sum(proratep(:))^2)/length(theta);
% penalty_out = ((wts')*wts + sum(proratep(:))^2)/length(theta);

end
