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
[p,n,ext] = fileparts(GRNstruct.inputFile);
if ~strcmp(ext,'.xls') && ~strcmp(ext,'.xlsx')
    msgbox('Select An .xls or .xlsx File To Run GRNmap.','Invalid Input Error');
    return
end

if outputFileConflictCheck(GRNstruct.directory, GRNstruct.inputFile)
    question = ['Warning: the output file that will be created for the chosen input file ' ...
        'will have the same name as an existing output file. Click OK to proceed with the ' ...
        'model run, overwriting the existing output file. Click Cancel to stop the run so ' ... 
        'that you can rename the file.'];
    title = 'Output File Name Conflict';
    answer = questdlg(question, title, 'OK', 'Cancel', 'Cancel');
    % We will get back 'Cancel' if the user clicks cancel or an empty character vector if they click
    % X or press ESC.
    if strcmp(answer, 'Cancel') || strcmp(answer, '')
        return;
    end
end
% Begin timing the run here

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
