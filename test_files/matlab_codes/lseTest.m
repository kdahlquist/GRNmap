classdef lseTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function test01SteadyState (testCase)
            
            GRNstruct.filename = '3-genes_3-edges_artificial-data_Sigmoid_estimation_1.xls';
            GRNstruct.inputFile = which(GRNstruct.filename);
            [~, GRNstruct.sheets] = xlsfinfo(GRNstruct.inputFile);
            
            testOutputFile = '3-genes_3-edges_artificial-data_Sigmoid_estimation_1_output.xls';
            [~, output_sheets] = xlsfinfo(testOutputFile);
            
            GRNstruct = lse(readInputSheet(GRNstruct));
            
            testCase.assertEqual(GRNstruct.GRNParams.positions, [1, 1; 2, 2; 3, 3]);
            
            %testCase.assertEqual(GRNstruct.GRNOutput.lse_0, 
        end
            
    end
    
end