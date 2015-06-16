clear all
clc

%Adds necessary directories to search path
path = which('callTests.m');
[p, ~, ~] = fileparts(path);
p = strrep(p, 'test_files\matlab_codes', '');
addpath(genpath(p));

% filename = '3-genes_3-edges_artificial-data_Sigmoid_estimation_1.xls';
% inputFile = which(filename);
% [A, B] = xlsfinfo(inputFile);

%[path, name, ext] = fileparts(filename)

%Begin running tests
% readInputSheetTestResult = run(readInputSheetTest);
% lseTestResult = run(lseTest);
runtests({'readInputSheetTest', 'lseTest'});