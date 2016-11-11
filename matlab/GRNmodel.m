GRNstruct = struct();
clearvars -global

% Allows user to choose an .xls or .xlsx file. If unsupported file is chosen
% the program is aborted. The dialog box defaults to .xlsx files.
[GRNstruct.fileName, GRNstruct.directory, ~] = uigetfile({'*.xlsx'},'Select Input Worksheet for Simulation.');

GRNstruct.inputFile = [GRNstruct.directory GRNstruct.fileName];

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
GRNstruct = initializeArrays(GRNstruct);
if (GRNstruct.controlParams.L_curve) 
   GRNstruct = GRNLCurve(GRNstruct);
else
    % Do the forward simulation and parameter estimation
    GRNstruct = lse(GRNstruct);
    % Output plots, .mat files, and excel sheet
    GRNstruct = output(GRNstruct);
end