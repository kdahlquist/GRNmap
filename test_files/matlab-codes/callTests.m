clear all
clc

%Adds necessary directories to search path
addpath(('..\..\matlab'));

%Begin running tests
run(readInputSheetTest);
run(lseTest);