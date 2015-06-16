clear all
clc

global input_file

%Adds necessary directories to search path
path = which('callTests.m');
[p, ~, ~] = fileparts(path);
p = strrep(p, 'test_files\matlab_codes', '');
addpath(genpath(p));

d = dir([p, 'test_files\', 'sixteen_tests\', '*.xlsx']);
num_files = length(d(not([d.isdir])));

for file_index = 1:2:num_files
    input_file = d(file_index).name;
end

%Begin running tests
results = runtests({'readInputSheetTest', 'lseTest', 'outputTest.m'});