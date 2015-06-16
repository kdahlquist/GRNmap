classdef outputTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function test01SteadyState (testCase)
            GRNstruct.filename = '3-genes_3-edges_artificial-data_Sigmoid_estimation_1.xls';
            GRNstruct.inputFile = which(GRNstruct.filename);
            [~, GRNstruct.sheets] = xlsfinfo(GRNstruct.inputFile);
            
            testOutputFile = '3-genes_3-edges_artificial-data_Sigmoid_estimation_1_output.xls';
            [~, output_sheets] = xlsfinfo(testOutputFile);
            
        end
        
    end
    
end