function GRNstruct = output(GRNstruct)

global A alpha b degrate fix_b i_forced log2FC n_genes n_times no_inputs prorate Sigmoid Strain time wts

if GRNstruct.controlParams.igraph == 1
    GRNstruct = graphs(GRNstruct);
end

positions   = GRNstruct.GRNParams.positions;
nedges      = GRNstruct.GRNParams.nedges;
n_forced    = GRNstruct.GRNParams.n_forced;
simtime     = GRNstruct.controlParams.simtime;
w0          = GRNstruct.locals.w0;
w1          = GRNstruct.locals.w1;

[~,input_file,ext] = fileparts(GRNstruct.inputFile);
output_file = [input_file '_estimation_output' ext];
output_mat  = [input_file '_estimation_output.mat'];
copyfile([input_file ext], output_file);

for qq = 1:length(Strain)
    
    for ik = 1:n_genes+1
        
        outputnet{1,ik} = GRNstruct.labels.TX2{1,ik};
        outputnet{ik,1} = GRNstruct.labels.TX2{1,ik};
        outputcells{ik,1} = GRNstruct.labels.TX0{ik,1};
        outputcells{ik,2} = GRNstruct.labels.TX0{ik,2};
        outputdata{ik,1} = GRNstruct.labels.TX0{ik,1};
        outputdata{ik,2} = GRNstruct.labels.TX0{ik,2};
        outputdeg{ik,1} = GRNstruct.labels.TX0{ik,1};
        outputdeg{ik,2} = GRNstruct.labels.TX0{ik,2};
        outputpro{ik,1} = GRNstruct.labels.TX0{ik,1};
        outputpro{ik,2} = GRNstruct.labels.TX0{ik,2};
        
        if ik>=2
            for jj = 2:length(simtime)+1
                outputcells{ik,jj+1} = log2FC(qq).model(ik-1,jj-1);
            end
            for jj = 2:n_times+1
                outputdata{ik,jj+1} = log2FC(qq).data(ik,jj-1);
            end
            for jj = 2:n_genes+1
                outputnet{jj,ik} = A(jj-1,ik-1);
            end
            outputpro{ik,3} = prorate(ik-1);
            outputdeg{ik,3} = degrate(ik-1);
        else
            outputdeg{ik,3} = GRNstruct.labels.TX0{ik,3};
            outputpro{ik,3} = 'prorate';
            
            for jj = 2:length(simtime)+1
                outputcells{ik,jj+1} = simtime(jj-1);
            end
            for jj = 2:n_times+1
                outputdata{ik,jj+1} = time(jj-1);
                outputtimes{1,jj} = time(jj-1);
            end
        end
    end
    
    GRNstruct.GRNOutput.d        = log2FC(qq).data(2:end,:);
    xlswrite(output_file,outputcells,[Strain{qq} '_log2_optimized_expression']);
end
    
    
% output_file = [input_file_name '_estimation_output_' num2str(alpha) '_' Strain{qq} '.xls'];
% output_mat  = [input_file_name '_estimation_output_' num2str(alpha) '_' Strain{qq} '.mat'];
% xlswrite(output_file,outputdeg,'out_degradation_rates');
xlswrite(output_file,outputpro,'out_production_rates');
xlswrite(output_file,outputtimes,'out_measurement_times');
xlswrite(output_file,outputnet,'out_network');

for ii = 1:nedges
    outputnet{positions(ii,1)+1,positions(ii,2)+1} = w0(ii);
end

xlswrite(output_file,outputnet,'out_network_weights');

if Sigmoid == 1
    outputpro{1,3} = 'b';
    if fix_b == 0
        for ii = 1:n_forced
            outputpro{i_forced(ii)+1,3} = w1(ii+nedges);
        end
        for ii = 1:length(no_inputs)
            outputpro{no_inputs(ii)+1,3} = 0;
        end
        xlswrite(output_file,outputpro,'out_network_optimized_b');
    end
    if fix_b == 1
        for ii = 1:n_forced
            outputpro{i_forced(ii)+1,3} = b(ii);
        end
        for ii = 1:length(no_inputs)
            outputpro{no_inputs(ii)+1,3} = 0;
        end
        xlswrite(output_file,outputpro,'out_network_b');
    end
end

for ii = 1:nedges
    outputnet{positions(ii,1)+1,positions(ii,2)+1} = w1(ii);
end

xlswrite(output_file,outputnet,'out_network_optimized_weights');


GRNstruct.GRNOutput.name     = GRNstruct.inputFile;
GRNstruct.GRNOutput.prorate  = prorate;
GRNstruct.GRNOutput.degrate  = degrate;
GRNstruct.GRNOutput.wts      = wts;
GRNstruct.GRNOutput.b        = b;
GRNstruct.GRNOutput.A        = A;
GRNstruct.GRNOutput.active   = GRNstruct.GRNParams.active;
GRNstruct.GRNOutput.tspan    = time;
GRNstruct.GRNOutput.alpha    = alpha;

my_string = ['save(''' output_mat ''')'];
eval(my_string);