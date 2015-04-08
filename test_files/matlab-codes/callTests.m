clear all
clc

%Adds necessary directories to search path
addpath(('..\..\matlab'));

%Begin running tests
readInputSheetTestResult = run(readInputSheetTest);
lseTestResult = run(lseTest);