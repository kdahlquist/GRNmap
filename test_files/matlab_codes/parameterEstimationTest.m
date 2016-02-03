classdef parameterEstimationTest < matlab.unittest.TestCase

    methods (Test)
     
        function testEstimateParamsIsZeroProducesMatFile(testCase)
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
            
            GRNstruct.inputFile = [GRNstruct.directory '22-genes_47-edges_Dahlquist-data_Sigmoidal_forward_graph.xlsx'];
            
            runGRNstructSimulation;
                   
        end
        
    end
end