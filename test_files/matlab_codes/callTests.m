clear all
clc

%Adds necessary directories to search path
path = which('exampleFunctionTest.m');
[p, name, ext] = fileparts(path);
p = strrep(p, 'matlab_codes', '');
addpath(strcat(p, 'estimation_tests'));

% filename = '3-genes_3-edges_artificial-data_Sigmoid_estimation_1.xls';
% inputFile = which(filename);
% [A, B] = xlsfinfo(inputFile);

%[path, name, ext] = fileparts(filename)

%Begin running tests
readInputSheetTestResult = run(readInputSheetTest);
lseTestResult = run(lseTest);