function GRNstruct = graphs(GRNstruct)
% USAGE: GRNstruct = graphs(GRNstruct)
% 
% Purpose: generate and print expression profiles
%
% Input and output: GRNstruct, a data structure containing all relevant
%                   GRNmap data
%
% Change log
%
%   2015 06 05, bgf
%               modified graph file names to gene standard names
%               added print command to save the final running opt diag
%               graph
%
global log2FC Strain expression_timepoints

directory = GRNstruct.directory;

tmin = 0;
tmax = max(expression_timepoints);
figHandles  = findobj('Type','figure');
offset      = size(figHandles,1);



plot_colors = [
    0.6510    0.8078    0.8902;
    0.1216    0.4706    0.7059;
    0.6980    0.8745    0.5412;
    0.2000    0.6275    0.1725;
    0.9843    0.6039    0.6000;
    0.8902    0.1020    0.1098;
    0.9922    0.7490    0.4353;
    1.0000    0.4980         0;
    0.7922    0.6980    0.8392;
    0.4157    0.2392    0.6039;
    1.0000    1.0000    0.6000;
    0.6941    0.3490    0.1569;   
];

if length(Strain) == 1
    Targets = {[Strain{1} ' data'],[Strain{1} ' model']};
else
    Targets = cell(1,(length(Strain)*2));
    for i = 0:(length(Strain)-1)
        Targets{2*(i)+1} = [Strain{i+1} ' data'];
        Targets{(i+1)*2} = [Strain{i+1} ' model'];
    end
end

for qq = 1:length(Strain)
    td  = log2FC(qq).data(1,:);
    % Remove the if line and its corresponding end
    if GRNstruct.controlParams.make_graphs
        % Delete these two statements, maybe. They are not
        % being used.
        error_up = (log2FC(qq).avg + 1.96*log2FC(qq).stdev);
        error_dn = (log2FC(qq).avg - 1.96*log2FC(qq).stdev);
        for ii=1:GRNstruct.GRNParams.num_genes
            figure(ii+offset),hold on
            plot(td,log2FC(qq).data(ii+1,:),'o','Color',plot_colors(qq,:),'LineWidth',3),axis([tmin tmax -3 3]);
            plot(log2FC(qq).simulation_timepoints,log2FC(qq).model(ii,:),'-','Color',plot_colors(qq,:));
            legend(Targets,'Location','NorthEastOutside');
            title(GRNstruct.labels.TX1{1+(ii),1},'FontSize',16)
            xlabel('Time (minutes)','FontSize',16)
            ylabel('Expression (log2 fold change)','FontSize',16)
        end
    end
end

for kk = 1:GRNstruct.GRNParams.num_genes
    figure(kk + offset)
    filename = [directory GRNstruct.labels.TX0{1+kk,1}];
    print(filename,'-djpeg')
end