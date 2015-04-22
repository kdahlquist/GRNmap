function GRNstruct = graphs(GRNstruct)

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

for qq = 1:length(log2FC)
    td  = log2FC(qq).data(1,:);
    if GRNstruct.controlParams.makeGraphs
        error_up = (log2FC(qq).avg + 1.96*log2FC(qq).stdev);
        error_dn = (log2FC(qq).avg - 1.96*log2FC(qq).stdev);
        for ii=1:GRNstruct.GRNParams.num_active_genes
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

for kk = 1:GRNstruct.GRNParams.num_active_genes
    eval(['figure(' num2str(kk + offset) ')'])
    eval(['print -djpeg ' directory 'figure_' num2str(kk)]);
end
