clear all
clc

global GRNstruct

% Adds necessary directories to search path
test_files_path         = which('callTests.m');
sixteen_tests_path      = [pwd '\..\sixteen_tests\'];

addpath([pwd '\..\..\matlab\']);
addpath([pwd '\..\estimation_tests\']);
addpath(sixteen_tests_path);

GRNstruct.directory     = sixteen_tests_path;
GRNstruct.tempdir       = tempdir;

% Count the number of files in the test_files folder
sixteen_tests           = dir([sixteen_tests_path, '*.xlsx']);
num_files               = length(sixteen_tests(not([sixteen_tests.isdir])));
starting_dir            = pwd;
all_files = [];

allReadInputSheetTest;

% Juancho's tests first
deletion_results = runtests('deletedStrainTest.m')
optimization_diagnostic_results = runtests('optimizationDiagnosticTest.m')
% Iterate through the 16 test files
for file_index          = 1:2:num_files
    cd(starting_dir);
    GRNstruct.inputFile = which(sixteen_tests(file_index).name);
    if not(isequal(strfind(GRNstruct.inputFile, '_output'), []))
       GRNstruct.inputFile = sixteen_tests(file_index + 1).name;
       file_index = file_index + 1;
    end

%   Begin running tests
    disp ('-------------------------------------------------------------');
    fprintf ('Running tests on %s\n\n',GRNstruct.inputFile);
    readInputResults = runtests({'readInputSheetTest'})
    runGRNstructSimulation;
    outputResults = runtests({'outputTest'})
    deleteAllTempsCreated;
    close all
    
end

LCurveResults = runtests('LCurveTest');