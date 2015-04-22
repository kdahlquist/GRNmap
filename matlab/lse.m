function GRNstruct = lse (GRNstruct)

global counter deletion fix_b fix_P is_forced log2FC lse_out penalty_out prorate Sigmoid Strain wtmat      

% We store relevant values and matrices from
% the struct into local variables
positions      = GRNstruct.GRNParams.positions;
num_edges      = GRNstruct.GRNParams.num_edges;
num_active_genes = GRNstruct.GRNParams.num_active_genes;
num_forced     = GRNstruct.GRNParams.num_forced;
estimateParams = GRNstruct.controlParams.estimateParams;
kk_max         = GRNstruct.controlParams.kk_max;
simtime        = GRNstruct.controlParams.simtime;
x0             = GRNstruct.GRNParams.x0;
MaxIter        = GRNstruct.controlParams.MaxIter;
MaxFunEval     = GRNstruct.controlParams.MaxFunEval;
TolFun         = GRNstruct.controlParams.TolFun;
TolX           = GRNstruct.controlParams.TolX;


for ii = 1:num_edges
    w0(ii,1) = wtmat(positions(ii,1),positions(ii,2));
end

if ~fix_b
    for ii = is_forced
        w0(ii+num_edges,1) = 0;
    end
end

if ~fix_P
    for ii = 1:num_active_genes
        w0(ii+num_forced*(1-fix_b)+num_edges) = prorate(ii);
    end
end

lb           = zeros(size(w0));
ub           = 10*ones(size(w0));
lb(1:num_edges) = -10*ones(num_edges,1);

if ~fix_b
    lb(num_edges+1:num_forced+num_edges) = -10*ones(num_forced,1);
end

% Call the least squares error program, store the sum of the squares of the
% errors in lse_0
counter = 0;
GRNstruct.GRNOutput.lse_0   = general_least_squares_error(w0);
GRNstruct.GRNOutput.lse_out = lse_out;
w1      = w0;

if estimateParams
    % This performs the optimization
    for kk = 1:kk_max
        options = optimset('Algorithm','interior-point','MaxIter',MaxIter,'MaxFunEval',MaxFunEval,'TolX',TolX,'TolFun',TolFun);
        w1      = fmincon(@general_least_squares_error,w1,[],[],[],[],lb,ub,[],options);
        GRNstruct.GRNOutput.lse_final = general_least_squares_error(w1);
        GRNstruct.GRNOutput.lse_out = lse_out;
        %lse_1   = L;
        %pen     = penalty_out;
    end
    GRNstruct.GRNOutput.reg_out = penalty_out;
end

for qq = 1:length(Strain)
    
    deletion = GRNstruct.microData(qq).deletion;
    if Sigmoid
        [t,model] = ode45(@general_network_dynamics_sigmoid,simtime,x0);
    else
        [t,model] = ode45(@general_network_dynamics_mm,simtime,x0);
    end
    GRNstruct.GRNOutput.t          = t;
    GRNstruct.GRNOutput.model      = model;
    log2FC(qq).model               = (log2(model))';
    log2FC(qq).simtime             = simtime';
    GRNstruct.GRNModel(qq).model   = log2FC(qq).model;
    GRNstruct.GRNModel(qq).simtime = log2FC(qq).simtime;
end


% We need w0 and w1 later on, so we'll append them to the structure.
GRNstruct.locals.w0 = w0;
GRNstruct.locals.w1 = w1;