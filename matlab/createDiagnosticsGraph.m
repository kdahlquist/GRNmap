function createDiagnosticsGraph(graphData, counter)
    strain_data = graphData.strain_data;
    estimated_guesses = graphData.estimated_guesses;
    log2FC = graphData.log2FC;
    
    for i = 1:size(strain_data,1)
        x1 = strain_data(i,:);
        figure(1),subplot(211),plot(estimated_guesses,'d'), title(['counter = ' num2str(counter)])
        subplot(212),plot(log2FC(i).avg','*'),hold on,plot(log2(x1)), hold off,pause(.1)
    end
end