classdef outputTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function test01SteadyState (testCase)
            GRNstruct.filename = '3-genes_3-edges_artificial-data_Sigmoid_estimation_1.xls';
            GRNstruct.inputFile = which(GRNstruct.filename);
            [~, GRNstruct.sheets] = xlsfinfo(GRNstruct.inputFile);
            
            testOutputFile = '3-genes_3-edges_artificial-data_Sigmoid_estimation_1_output.xls';
            [~, output_sheets] = xlsfinfo(testOutputFile);
            
            j = 1;
            for index = 1:length(output_sheets)
                
                if strcmp(output_sheets(index), GRNstruct.sheets(j))
                    [input_num, input_txt] = xlsread(GRNstruct.filename, j);
                    [output_num, output_txt] = xlsread(testOutputFile, j);
                    testCase.assertEqual(input_num, output_num);
                    testCase.assertEqual(input_txt, output_txt);
                end
            end
            
        end
        
    end
    
end