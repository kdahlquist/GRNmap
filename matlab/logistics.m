
function outputDiag = logisitics(outputDiag, lseRuntime, timestamp)
% USAGE: outputDiag = logisitics(outputDiag, lseRuntime, timestamp);

% Purpose: (1) Appends GRNmap version number to the diagnostic struct
%          (2) Appends date of completion to the diagnostic struct
%          (3) Appends the total run time gotten from LSE to the diagnostic struct

% To parse the version number from the text file we do the following:
fileID = fopen('version.txt','r');
text = textscan(fileID,'%s',1,'Delimiter','\n');
versionNumber = text{1};

outputDiag{2, 1} = 'GRNmap Version';
outputDiag{2, 2} = versionNumber;
outputDiag{3, 1} = 'run length';
outputDiag{3, 2} = lseRuntime
outputDiag{4, 1} = 'time completed';
outputDiag{4, 2} = timestamp
