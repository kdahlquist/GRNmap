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

data_samples             = dir([[pwd '/../data_samples/'], '*.xlsx']);
num_data_samples         = length(data_samples);

math_L_curve_tests       = dir([[pwd '/../perturbation_tests/to_be_reformatted/math_L-curve/'], '*.xlsx']);
num_math_L_curve_files   = length(math_L_curve_test);

seaver_L_curve_tests     = dir([[pwd '/../perturbation_tests/to_be_reformatted/seaver_L-curve/'], '*.xlsx']);
num_seaver_L_curve_files = length(seaver_L_curve_files);

estimation_tests         = dir([[pwd '/../estimation_tests/'], '*.xlsx']);
num_estimation_tests     = length(estimation_tests);

forward_tests            = dir([[pwd '/../forward_tests/'], '*.xlsx']);
num_forward_tests        = length(forward_tests);

all_tests_struct         = [data_samples; math_L_curve_tests; seaver_L_curve_tests; estimation_tests; forward_tests];
num_all_tests            = length(all_tests_struct);

% Juancho's tests first
deletionResults = runtests('deletedStrainTest.m')
% Iterate through the 16 test files
for file_index          = 1:2:num_files
    cd(starting_dir);
    GRNstruct.inputFile = d(file_index).name;
    if not(isequal(strfind(GRNstruct.inputFile, '_output'), []))
       GRNstruct.inputFile = d(file_index + 1).name;
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

% % Iterate through estimation tests. The data in these files are outdated 
% % (e.g. production_rates sheet does not exist when it is supposed to).
% bgf_estimation_tests_dir = dir([estimation_tests_path, '*.xlsx']);
% estimation_tests_num_files = length(bgf_estimation_tests_dir(not([bgf_estimation_tests_dir.isdir])));
% for file_index          = 1:2:estimation_tests_num_files
%     cd(starting_dir);
%     GRNstruct.inputFile = bgf_estimation_tests_dir(file_index).name;
%     while not(isequal(strfind(GRNstruct.inputFile, '_output'), []))
%        GRNstruct.inputFile = bgf_estimation_tests_dir(file_index + 1).name;
%        file_index = file_index + 1;
%     end
% 
% %   Begin running tests
%     disp ('-------------------------------------------------------------');
%     fprintf ('Running tests on %s\n\n',GRNstruct.inputFile);
%     readInputResults = runtests({'readInputSheetTest'})
%     runGRNstructSimulation;
%     outputResults = runtests({'outputTest'})    
%     close all
% end

% runtests({'parameterEstimationTest'})