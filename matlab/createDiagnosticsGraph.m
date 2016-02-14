function createDiagnosticsGraph(graphData, counter)
    strain_data = graphData.strain_data;
    estimated_guesses = graphData.estimated_guesses;
    log2FC = graphData.log2FC;
    number_of_strains = graphData.num_of_strains;
    LSE = graphData.LSE;
    
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

    for i = 1:number_of_strains
        x1 = strain_data(i,:);
        figure(1),subplot(211),plot(estimated_guesses,'d'), title(['counter = ' num2str(counter)])
        title(['counter = ' num2str(counter) ', LSE = ', num2str(LSE)])
        subplot(212),plot(log2FC(i).avg','*','Color',plot_colors(i,:));
        hold on;
        plot(log2(x1), 'Color',plot_colors(i,:))
        hold off
        pause(0.1)
    end
end