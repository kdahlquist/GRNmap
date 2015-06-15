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
global log2FC Strain time

directory = GRNstruct.directory;

tmin = 0;
tmax = max(time);
figHandles  = findobj('Type','figure');
offset      = size(figHandles,1);

plot_colors = 'kbrcm';

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
    if GRNstruct.controlParams.makeGraphs
        % Delete these two statements, maybe. They are not
        % being used.
        error_up = (log2FC(qq).avg + 1.96*log2FC(qq).stdev);
        error_dn = (log2FC(qq).avg - 1.96*log2FC(qq).stdev);
        for ii=1:GRNstruct.GRNParams.num_genes
            figure(ii+offset),hold on
            plot(td,log2FC(qq).data(ii+1,:),[plot_colors(qq) 'o'],'LineWidth',3),axis([tmin tmax -3 3]);
            plot(log2FC(qq).simtime,log2FC(qq).model(ii,:),[plot_colors(qq) '-']);
            legend(Targets,'Location','NorthEastOutside');
            title(GRNstruct.labels.TX1{1+(ii),2},'FontSize',16)
            xlabel('Time (minutes)','FontSize',16)
            ylabel('Expression (log2 fold change)','FontSize',16)
        end
    end
end

for kk = 1:GRNstruct.GRNParams.num_genes
    eval(['figure(' num2str(kk + offset) ')'])
%     eval(['print -djpeg ' directory 'figure_' num2str(kk)]);
    eval(['print -djpeg ' directory  GRNstruct.labels.TX0{1+kk,2}]);
end
figure(1)
eval(['print -djpeg ' directory  'optimization_diagnostic']);

