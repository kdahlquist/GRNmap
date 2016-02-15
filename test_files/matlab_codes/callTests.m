clear all
clc
import matlab.unittest.TestSuite
import matlab.unittest.TestRunner
runner = TestRunner.withNoPlugins;
p = DiagnosticRecorderPlugin;
runner.addPlugin(p)

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
deletedStrainTest_suite = TestSuite.fromClass(?deletedStrainTest);
optimizationDiagnosticTest_suite = TestSuite.fromClass(?optimizationDiagnosticTest);

test_results = [test_results runner.run(deletedStrainTest_suite)];
test_results = [test_results runner.run(optimizationDiagnosticTest_suite)];

% % Iterate through the 16 test files
GRNstruct = struct();
GRNstruct.directory     = sixteen_tests_path;
GRNstruct.tempdir       = tempdir;

readInputSheetTest_suite = TestSuite.fromClass(?readInputSheetTest);
outputTest_suite = TestSuite.fromClass(?outputTest);

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
    test_results = [test_results runner.run(readInputSheetTest_suite)];
    runGRNstructSimulation;
    test_results = [test_results runner.run(outputTest_suite)];
    deleteAllTempsCreated;
    close all
    
end

%LCurveTest_suite = TestSuite.fromClass(?LCurveTest);
%test_results = [test_results runner.run(LCurveTest_suite)];

total_num_of_tests = length(test_results);
num_of_failed_tests = sum(cat(1,test_results.Failed));
num_of_passed_tests = total_num_of_tests - num_of_failed_tests;

fprintf('We passed %i/%i tests.\n',num_of_passed_tests,total_num_of_tests)