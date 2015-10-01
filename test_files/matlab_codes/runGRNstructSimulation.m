function runGRNstructSimulation
    global GRNstruct

    % If no valid file is chosen, abort
    if ~GRNstruct.inputFile
        msgbox('Select An .xls or .xlsx File To Run Simulation.','Empty Input Error');
        return
    end

    % If the file is not an xls or xlsx file, abort
    [p,n,ext] = fileparts( GRNstruct.inputFile );
    if ~strcmp(ext,'.xls') && ~strcmp(ext,'.xlsx')
        msgbox('Select An .xls or .xlsx File To Run GRNmap.','Invalid Input Error');
        return
    end
    % Back Simulation
    % Populates the structure as well as the global variables
    GRNstruct = readInputSheet(GRNstruct);
    % Do the forward simulation and parameter estimation
    GRNstruct = lse(GRNstruct);
    % Output plots, .mat files, and excel sheet
    GRNstruct = output(GRNstruct);

end