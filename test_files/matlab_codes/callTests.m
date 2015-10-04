clear all
clc

global GRNstruct

% Adds necessary directories to search path
test_files_path = which('callTests.m');

% Not very good looking right now. Will think of some way to clean this up.
test_codes_path = fileparts(test_files_path);
general_path    = fileparts(test_codes_path);
addpath(fullfile(fileparts(general_path), 'matlab\'));
sixteen_tests_path   = fullfile(general_path, 'sixteen_tests\');
GRNstruct.directory = sixteen_tests_path;
addpath(sixteen_tests_path);

% Count the number of files in the test_files folder
d = dir([sixteen_tests_path, '*.xlsx']);
num_files = length(d(not([d.isdir])));

% Iterate through the test files
for file_index = 1:2:num_files
%     if isempty(strfind (d(file_index).name, '_output'))
      GRNstruct.inputFile = d(file_index).name;
%     end

%   Begin running tests
    results = runtests({'readInputSheetTest',  'outputTest'});
end

delete([GRNstruct.directory '*.jpg']);
% runtests({'parameterEstimationTest'})

% Since @bengfitzpatrick has only verified the outputs for the file written below, I
% will use this file to draft tests and then apply them to the sixteen
% cases.
% GRNstruct.inputFile = '4-genes_6-edges_artificial-data_Sigmoidal_estimation_fixb-1_fixP-0_graph.xlsx';
% results = runtests({'readInputSheetTest', 'outputTest'});