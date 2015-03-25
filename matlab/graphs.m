function GRNstruct = graphs(GRNstruct)

global log2FC Strain time


tmin = 0;
tmax = max(time);

plot_colors = 'kbrcm';

if length(Strain) == 1
    Targets = {[Strain{1} ' data'],[Strain{1} ' model']};
else
    Targets = cell(1,(length(Strain)*2));
    for i = 0:((length(Strain))-1)
        Targets{2*(i)+1} = [Strain{i+1} ' data'];
        Targets{(i+1)*2} = [Strain{i+1} ' model'];
    end
end

for qq = 1:length(log2FC)
    td  = (log2FC(qq).data(1,:));
    if GRNstruct.controlParams.makeGraphs
        error_up = (log2FC(qq).avg + 1.96*log2FC(qq).stdev);
        error_dn = (log2FC(qq).avg - 1.96*log2FC(qq).stdev);
        for ii=1:GRNstruct.GRNParams.n_active_genes
            figure(ii+2),hold on
            plot(td,log2FC(qq).data(ii+1,:),[plot_colors(qq) 'o'],'LineWidth',3),axis([tmin tmax -3 3]);
            plot(log2FC(qq).simtime,log2FC(qq).model(ii,:),[plot_colors(qq) '-']);
            legend(Targets,'Location','NorthEastOutside');
            title(GRNstruct.labels.TX1{1+(ii),2},'FontSize',16)
            xlabel('Time (minutes)','FontSize',16)
            ylabel('Expression (log2 fold change)','FontSize',16)
        end
    end
end

figHandles  = findobj('Type','figure');
nfig        = size(figHandles,1);

for kk = 3:nfig
    eval(['figure(' num2str(kk) ')'])
    eval(['print -djpeg figure_' num2str(kk-2)]);
end
