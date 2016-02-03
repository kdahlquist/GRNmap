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

data_samples             = dir([[pwd '/../data_samples/'], '*.xlsx']);
cd([pwd '/../data_samples/'])
for k = find(not([data_samples.isdir]))
    all_files{end + 1} = {which(data_samples(k).name)};
end
cd(starting_dir)

deleted_strains_tests    = dir([[pwd '/../deleted_strains_tests/'], '*.xlsx']);
cd([pwd '/../deleted_strains_tests/'])
for k = find(not([deleted_strains_tests.isdir]))
    all_files{end + 1} = {which(deleted_strains_tests(k).name)};
end
cd(starting_dir)

MSE_tests    = dir([[pwd '/../MSE_tests/'], '*.xlsx']);
cd([pwd '/../MSE_tests/'])
for k = find(not([MSE_tests.isdir]))
    all_files{end + 1} = {which(MSE_tests(k).name)};
end
cd(starting_dir)

math_L_curve_tests       = dir([[pwd '/../perturbation_tests/to_be_reformatted/math_L-curve/'], '*.xlsx']);
cd([pwd '/../perturbation_tests/to_be_reformatted/math_L-curve/'])
for k = find(not([math_L_curve_tests.isdir]))
    all_files{end + 1} = {which(math_L_curve_tests(k).name)};
end
cd(starting_dir)

seaver_L_curve_tests     = dir([[pwd '/../perturbation_tests/to_be_reformatted/seaver_L-curve/'], '*.xlsx']);
cd([pwd '/../perturbation_tests/to_be_reformatted/seaver_L-curve/'])
for k = find(not([seaver_L_curve_tests.isdir]))
    all_files{end + 1} = {which(seaver_L_curve_tests(k).name)};
end
cd(starting_dir)

estimation_tests         = dir([[pwd '/../estimation_tests/'], '*.xlsx']);
cd([pwd '/../estimation_tests/'])
for k = find(not([estimation_tests.isdir]))
    all_files{end + 1} = {which(estimation_tests(k).name)};
end
cd(starting_dir)

forward_tests            = dir([[pwd '/../forward_tests/'], '*.xlsx']);
cd([pwd '/../forward_tests/'])
for k = find(not([forward_tests.isdir]))
    all_files{end + 1} = {which(forward_tests(k).name)};
end
cd(starting_dir)

for file = 1:length(all_files)
    GRNstruct = struct();
   GRNstruct.inputFile = all_files{file}{1};
   runtests('readInputSheetTest');
end

% Juancho's tests first
deletionResults = runtests('deletedStrainTest.m')
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