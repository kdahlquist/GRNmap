function GRNstruct = graphs(GRNstruct)
% USAGE: GRNstruct = graphs(GRNstruct)
%
% Purpose: generate and print expression profiles
%
% Input and output: GRNstruct, a data structure containing all relevant
%                   GRNmap data

directory = GRNstruct.directory;
expression_timepoints = GRNstruct.GRNParams.expression_timepoints;
strain_length = length(GRNstruct.microData);

tmin = 0;
tmax = max(expression_timepoints);
figHandles  = findobj('Type','figure');
offset      = size(figHandles,1);


plot_colors = [
         0         0         0; % black
    0.1216    0.4706    0.7059; % blue
    0.8902    0.1020    0.1098; % red
    0.2000    0.6275    0.1725; % green
    1.0000    0.4980         0; % orange
    0.4157    0.2392    0.6039; % purple
    0.6941    0.3490    0.1569; % brown
    0.2667    0.2667    0.2667; % grey
    0.6510    0.8078    0.8902; % light blue
    0.9843    0.6039    0.6000; % pink
    0.6980    0.8745    0.5412; % light green
    0.9922    0.7490    0.4353; % light orange
    0.7922    0.6980    0.8392; % light purple
];

if strain_length == 1
    Targets = {[cell2mat(GRNstruct.microData(1).strain) ' data'],[cell2mat(GRNstruct.microData(1).strain) ' model']};
else
    Targets = cell(1,(strain_length * 2));
    for i = 0:(strain_length-1)
        Targets{2*(i)+1} = [cell2mat(GRNstruct.microData(i+1).strain) ' data'];
        Targets{(i+1)*2} = [cell2mat(GRNstruct.microData(i+1).strain) ' model'];
    end
end

for qq = 1: strain_length;
    td  = GRNstruct.microData(qq).data(1,:);
    % Remove the if line and its corresponding end
    if GRNstruct.controlParams.make_graphs
        % Delete these two statements, maybe. They are not
        % being used.

%         error_up = (log2FC(qq).avg + 1.96*log2FC(qq).stdev);
%         error_dn = (log2FC(qq).avg - 1.96*log2FC(qq).stdev);
        for ii=1:GRNstruct.GRNParams.num_genes
            figure(ii+offset),hold on
            plot(td,GRNstruct.microData(qq).data(ii+1,:),'o','Color',plot_colors(qq,:),'LineWidth',3),axis([tmin tmax -3 3]);
            plot(GRNstruct.controlParams.simulation_timepoints,GRNstruct.GRNModel(qq).model(ii,:),'-','Color',plot_colors(qq,:));
            legend(Targets,'Location','NorthEastOutside');
            title(GRNstruct.labels.TX1{1+(ii),1},'FontSize',16)
            xlabel('Time (minutes)','FontSize',16)
            ylabel('Expression (log2 fold change)','FontSize',16)
        end
    end
end
for kk = 1:GRNstruct.GRNParams.num_genes
    figure(kk + offset)
    if GRNstruct.controlParams.L_curve && GRNstruct.controlParams.make_graphs
        filename = [directory GRNstruct.labels.TX0{1+kk,1} '_' num2str(GRNstruct.copy_counter)];
    else
        filename = [directory GRNstruct.labels.TX0{1+kk,1}];
    end
    print(filename,'-djpeg')
end
