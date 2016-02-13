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
all_files = [];
starting_dir = pwd;

test_results = [];

%test_results = [test_results allReadInputSheetTest()];

% Juancho's tests first
%test_results = [test_results runtests('deletedStrainTest.m')];
%test_results = [test_results runtests('optimizationDiagnosticTest.m')];

% % Iterate through the 16 test files
GRNstruct = struct();
GRNstruct.directory     = sixteen_tests_path;
GRNstruct.tempdir       = tempdir;

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
    test_results = [test_results runtests({'readInputSheetTest'})];
    runGRNstructSimulation;
    test_results = [test_results runtests({'outputTest'})];
    deleteAllTempsCreated;
    close all
    
end

%test_results = [test_results runtests('LCurveTest')];

num_of_failed_tests = 0;
total_num_of_tests = length(test_results);

for test = 1:total_num_of_tests
    if(test_results(test).Failed)
        disp(table(test_results(test)))
        num_of_failed_tests = num_of_failed_tests + 1;
    end
end

num_of_passed_tests = total_num_of_tests - num_of_failed_tests;

fprintf('We passed %i/%i tests.\n',num_of_passed_tests,total_num_of_tests)