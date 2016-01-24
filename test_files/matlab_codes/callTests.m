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
d                       = dir([sixteen_tests_path, '*.xlsx']);
num_files               = length(d(not([d.isdir])));

starting_dir = pwd;

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