clear all
clc

global GRNstruct

%Adds necessary directories to search path
path = which('callTests.m');
[p, ~, ~] = fileparts(path);
p = strrep(p, 'test_files\matlab_codes', '');
addpath(genpath(p));

d = dir([p, 'test_files\', 'sixteen_tests\', '*.xlsx']);
num_files = length(d(not([d.isdir])));

for file_index = 1:2:num_files
    GRNstruct.inputFile = d(file_index).name;

%   Begin running tests
%     results = runtests({'readInputSheetTest',  'outputTest'});
end

results = runtests({'readInputSheetTest', 'outputTest'});

