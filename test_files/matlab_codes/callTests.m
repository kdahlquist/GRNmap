clear all
clc

global GRNstruct

% Adds necessary directories to search path
p = fileparts(pwd);
sixteen_tests = fullfile(p, 'sixteen_tests\');
addpath(sixteen_tests);
addpath(fullfile(fileparts(p), 'matlab\'));

d = dir([sixteen_tests, '*.xlsx']);
num_files = length(d(not([d.isdir])));

% for file_index = 1:num_files
%     if isempty(strfind (d(file_index).name, '_output'))
%       GRNstruct.inputFile = d(file_index).name;
%     end
% 
% %   Begin running tests
% %     results = runtests({'readInputSheetTest',  'outputTest'});
% end

GRNstruct.inputFile = '4-genes_6-edges_artificial-data_Sigmoidal_estimation_fixb-1_fixP-0_graph.xlsx';
results = runtests({'readInputSheetTest', 'outputTest'});

