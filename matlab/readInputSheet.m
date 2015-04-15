% Notes: Include everything that is created into the structure. We will
% have to take log2FC apart and put it into different parts of GRNstruct

function GRNstruct = readInputSheet( GRNstruct )

global A alpha b degrate fix_b fix_P i_forced log2FC n_genes n_times prorate Sigmoid Strain wtmat time

alpha = 0;

input_file      = GRNstruct.inputFile;
[type, sheets]  = xlsfinfo(input_file);

[parms0,parmnames0]  = xlsread(input_file,'optimization_parameters');
[np,mp] = size(parmnames0);

qq = 0;
for ii = 2:np
    inan = find(isnan(parms0(ii-1,:))==0);
    if ~isempty(inan)
        eval([parmnames0{ii,1} '= [' num2str(parms0(ii-1,inan)) '];']);
        if length(inan) == 1
            qq = qq + 1;
            parmnames{qq} = parmnames0{ii,1};
            parms(qq) = parms0(ii-1,1);
        end
    else
        ipe = 0;
        ife = 0;
        while ~ife
            ipe = ipe + 1;
            if ipe < mp
                parmstr = parmnames0{ii,1+ipe};
                if ~isempty(parmstr)
                    eval([parmnames0{ii,1} '{ipe}= parmstr;']);
                else
                    ife = 1;
                end
            else
                ife = 1;
            end
        end
    end
end 

% These varaibles call data from Excel files
for ii = 1:length(Strain)
    [GRNstruct.microData(ii).data,GRNstruct.labels.TX1] = xlsread(input_file,Strain{ii});
    GRNstruct.microData(ii).Strain = Strain(ii);
    log2FC(ii).data = xlsread(input_file,Strain{ii});
end

% Populate the structure
[GRNstruct.degRates,GRNstruct.labels.TX0]          = xlsread(input_file,'degradation_rates');
[GRNstruct.GRNParams.wtmat,GRNstruct.labels.TX2]   = xlsread(input_file,'network_weights');
[GRNstruct.GRNParams.A,GRNstruct.labels.TX3]       = xlsread(input_file,'network');
[GRNstruct.GRNParams.prorate,GRNstruct.labels.TX5] = xlsread(input_file,'production_rates');

GRNstruct.GRNParams.nedges          = sum(GRNstruct.GRNParams.A(:));
GRNstruct.GRNParams.n_active_genes  = length(GRNstruct.GRNParams.A(1,:));
GRNstruct.GRNParams.active          = 1:GRNstruct.GRNParams.n_active_genes;
GRNstruct.GRNParams.alpha           = alpha;
GRNstruct.GRNParams.time            = time;
GRNstruct.GRNParams.n_genes         = length(GRNstruct.microData(1).data(:,1))-1;
GRNstruct.GRNParams.n_times         = length(time);

% This sets the control paramenters
GRNstruct.controlParams.simtime        = simtime;
GRNstruct.controlParams.kk_max         = kk_max;
GRNstruct.controlParams.MaxIter        = MaxIter;
GRNstruct.controlParams.MaxFunEval     = MaxFunEval;
GRNstruct.controlParams.TolFun         = TolFun;
GRNstruct.controlParams.TolX           = TolX;
GRNstruct.controlParams.estimateParams = estimateParams;
GRNstruct.controlParams.makeGraphs     = makeGraphs;
GRNstruct.controlParams.Sigmoid        = Sigmoid;
GRNstruct.controlParams.fix_b          = fix_b;
GRNstruct.controlParams.fix_P          = fix_P;


% Populate the global variables

if GRNstruct.controlParams.Sigmoid
    [GRNstruct.GRNParams.b,GRNstruct.labels.TX6] = xlsread(input_file,'network_b');
    b = GRNstruct.GRNParams.b;
else
    GRNstruct.controlParams.fix_b = 1;
    fix_b = 1;
    GRNstruct.GRNParams.b = zeros(length(degrate),1);
    b = zeros(length(degrate),1);
end

%TX1 contains both the systemic and standard names
%TX11 is the list of standard (common) names
%%Revision to old way of computing TX11
for ii = 1:length(GRNstruct.microData(1).data(:,1));
    GRNstruct.labels.TX11{ii,1} = GRNstruct.labels.TX1{ii,2};
end

% To be read by the program correctly, prorate and degrate need to be row
% vectors instead of column vectors, so we use the transpose of the array
% obtained from the datafile
% prorate         = prorate';
GRNstruct.degRates = GRNstruct.degRates';

% We use variables wherever we would need numbers that might change if we
% are using a different network.

for i = 1:length(Strain)
    % % The first row of the GRNstruct.microData data indicating all of the replicate timepoints
    reps = (GRNstruct.microData(i).data(1,:));
    % % Finds the indices in reps that correspond to each timepoint in tspan.
    for jj = 1:length(time)
        log2FC(i).t(jj).indx = find(reps == time(jj));
        log2FC(i).t(jj).t    = time(jj); 
        GRNstruct.microData(i).t(jj).indx = find(reps == time(jj));
        GRNstruct.microData(i).t(jj).t    = time(jj);
    end
    % % GRNstruct.microData data for all strains
    %GRNstruct.microData(i).data  = (GRNstruct.microData(i).d(2:end,:));

    % % The average GRNstruct.microData for each timepoint for each gene.
    for iT = 1:GRNstruct.GRNParams.n_times
        data = GRNstruct.microData(i).data(2:end,GRNstruct.microData(i).t(iT).indx);
        GRNstruct.microData(i).avg(:,iT) = mean(data,2);
        GRNstruct.microData(i).stdev(:,iT) =  std(data,0,2);
        log2FC(i).avg(:,iT) = mean(log2FC(i).data(2:end,log2FC(i).t(iT).indx),2);
        log2FC(i).stdev(:,iT) =  std(log2FC(i).data(2:end,log2FC(i).t(iT).indx),0,2);
    end

    log2FC(i).deletion  = Deletion(i);
    log2FC(i).strain    = Strain(i);
    GRNstruct.microData(i).deletion = Deletion(i);
end

% # of interactions between controlling and affected TF's
% sum each row of matrix A (network)
Ar = sum(GRNstruct.GRNParams.A,2);

% Whether or not genes are affected T(1)/F(0)
Ai = Ar > 0;
GRNstruct.GRNParams.no_inputs = find(Ai == 0);
GRNstruct.GRNParams.i_forced  = find(Ai == 1);
GRNstruct.GRNParams.n_forced  = sum(Ai);

%Where the edges are in the network
%i corresponds to row (genes affected)
%j correspond to column (genes controlling)
[ig,jg] = find(GRNstruct.GRNParams.A == 1);
GRNstruct.GRNParams.positions = sortrows([ig,jg],1);

GRNstruct.GRNParams.x0 = ones(GRNstruct.GRNParams.n_genes,1);

% Populating the globals
i_forced  = GRNstruct.GRNParams.i_forced;
n_genes   = GRNstruct.GRNParams.n_genes;
n_times   = GRNstruct.GRNParams.n_times;
degrate   = GRNstruct.degRates;
A         = GRNstruct.GRNParams.A;
prorate   = GRNstruct.GRNParams.prorate;
wtmat     = GRNstruct.GRNParams.wtmat;


end