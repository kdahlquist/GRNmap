function L = general_least_squares_error(theta)
% USAGE  L = general_least_squares_error(theta)
% 
% Purpose: compute fit criterion for minimization purposes
%          designed to be called by MATLAB minimization functions
%          all parameters (weights, b's, production rates) must be
%          stacked into a single input vector (theta)
%
% Input:  theta = vector of parameters we modify to fit data to model
% Output: L     = penalized least squares fit criterion
%
% Change log
%
%   2015 06 04, bgf
%               added functionality to compute total sum of sq of error
%               (SSE) for output diagnostics
%               required new global variable to communicate with 
%               lse
%               corrected an error in the way the penalty is computed
%               for the production rates -- sum(p^2) replaced (sum of p)^2
%
global adjacency_mat alpha b is_forced counter deletion fix_b fix_P log2FC lse_out penalty_out prorate Sigmoid Strain time wts 
global SSE   

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

if time(1) > 1e-6
    tspan1 = [0;time(:)];
    addzero = 1;
else
    tspan1 = time;
    addzero = 0;
end

errormat = 0;
SSE      = zeros(num_genes,length(Strain));

% % Call for all deletion strains simultaneously

nData = 0;
for qq = 1:length(Strain)
    
    deletion = log2FC(qq).deletion;
    d        = log2FC(qq).data(2:end,:);
    
    nData = nData + length(d(:));
    
    % % Matlab uses the o.d.e. solver function to obtain the data from our model
    %     [t,x] = ode45('general_network_dynamics_sigmoid',tspan1,x0);
    if Sigmoid == 1
        % The ~ was previously a t, which was previously unused
        [~,x] = ode45('general_network_dynamics_sigmoid',tspan1,x0);
    else
        [~,x] = ode45('general_network_dynamics_mm',tspan1,x0);
    end
    
    if addzero == 1;
        x1 = x(2:end,:);
    else
        x1 = x;
    end
    
    nSE = 0;
    errMatStrain = 0;
    for iT = 1:length(time)
        for iF =  1:length(log2FC(qq).t(iT).indx)
            errMatStrain = errMatStrain+((log2(x1(iT,:)))'-d(:,log2FC(qq).t(iT).indx(iF))).^2;
            nSE      = nSE + 1;
        end
    end
    errormat = errormat + errMatStrain;
    
    SSE(:,qq) = errormat/nSE;
    
    % Output graph every 100 iterations.
    if rem(counter,100) ==  0
        figure(1),subplot(211),plot(theta,'d'), title(['counter = ' num2str(counter) ', LSE = ', num2str(sum(errormat(:))/nData)])
        subplot(212),plot(log2FC(qq).avg','*'),hold on,plot(log2(x1)), hold off,pause(.1)
    end
    
end

% %%Set alpha for L curves
% alpha = 0.01;


% This is the sum of all the errors
L        = sum(errormat(:))/nData;
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
