function L = general_least_squares_error(theta)
% USAGE  L = general_least_squares_error(theta)
% This program is used with fminsearch to find the optimum weights vector.
global adjacency_mat alpha b counter deletion fix_b fix_P log2FC lse_out penalty_out prorate Sigmoid Strain time wts      

counter = counter + 1;

num_edges = sum(adjacency_mat(:));
Ar = sum(adjacency_mat,2);
Ai = Ar>0;
num_forced  = sum(Ai);

num_genes = length(adjacency_mat(1,:));

wts = theta(1:num_edges);

% We read the values for b and P from the initial_guesses vector
P_offset = num_forced*(1-fix_b)+num_edges;
if ~fix_b
    b = theta(num_edges + 1:num_forced + num_edges);
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

% % Call for all deletion strains simultaneously
for qq = 1:length(Strain)
    
    deletion = log2FC(qq).deletion;
    d        = log2FC(qq).data(2:end,:);
    
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
    
    for iT = 1:length(time)
        for iF =  1:length(log2FC(qq).t(iT).indx)
            errormat = errormat+((log2(x1(iT,:)))'-d(:,log2FC(qq).t(iT).indx(iF))).^2;
        end
    end
    
    % Output graph every 100 iterations.
    if rem(counter,100) ==  0
        figure(1),subplot(211),plot(theta,'d'), title(['counter = ' num2str(counter)])
        subplot(212),plot(log2FC(qq).avg','*'),hold on,plot(log2(x1)), hold off,pause(.1)
    end
    
end

% %%Set alpha for L curves
% alpha = 0.01;


% This is the sum of all the errors
L        = sum(errormat(:))/length(errormat(:));
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

L           = L + alpha*(wts')*wts + alpha*(b-bp)'*(b-bp) + alpha*sum(proratep(:))^2;
% L           = L + alpha*(wts')*wts + alpha*sum(proratep(:))^2;
% Store the penalty value
penalty_out = (wts'*wts + (b-bp)'*(b-bp) + sum(proratep(:))^2)/length(theta);
% penalty_out = ((wts')*wts + sum(proratep(:))^2)/length(theta);

end