classdef readInputSheetTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function testReadInputs (testCase)
            
            global input_file
            disp(input_file);
            
            filename = '3-genes_3-edges_artificial-data_Sigmoid_estimation_1.xls';
            inputFile = which(filename);
            [~, name, ~] = fileparts (filename);
            [~, sheets] = xlsfinfo(inputFile);
            
            testOutputFile = [name '_output.xls'];
            [~, output_sheets] = xlsfinfo(testOutputFile);
            
            sheetNames = {'production_rates', 'degradation_rates', 'wt_log2_expression', 'network','network_weights', 'optimization_parameters', 'threshold_b', 'wt_log2_optimized_expression', 'optimized_production_rates', 'optimized_threshold_b', 'network_optimized_weights'};
            testCase.assertEqual(any(ismember(sheets, sheetNames)), true); 
            testCase.assertEqual(any(ismember(output_sheets, sheetNames)), true); 
           
%           Test for comparing input with corresponding output sheets
            j = 1;
            for index = 1:length(sheets)
                
                if strcmp(output_sheets(index), sheets(j))
                    [input_num, input_txt] = xlsread(filename, j);
                    [output_num, output_txt] = xlsread(testOutputFile, j);
                    testCase.assertEqual(input_num, output_num);
                    testCase.assertEqual(input_txt, output_txt);
                end
%                 if strcmp(output_sheets(index), 'degradation_rates')
%                     [input_num, input_txt] = xlsread(filename, 'degradation_rates');
%                     [output_num, output_txt] = xlsread(testOutputFile, 'degradation_rates');
%                     testCase.assertEqual(input_num, output_num);
%                     testCase.assertEqual(input_txt, output_txt);
%                 end
%                 if strcmp(output_sheets(index), 'wt_log2_expression')
%                     [input_num, input_txt] = xlsread(filename, 'wt_log2_expression');
%                     [output_num, output_txt] = xlsread(testOutputFile, 'wt_log2_expression');
%                     testCase.assertEqual(input_num, output_num);
%                     testCase.assertEqual(input_txt, output_txt);
%                 end
%                 if strcmp(output_sheets(index), 'network')
%                     [input_num, input_txt] = xlsread(filename, 'network');
%                     [output_num, output_txt] = xlsread(testOutputFile, 'network');
%                     testCase.assertEqual(input_num, output_num);
%                     testCase.assertEqual(input_txt, output_txt);
%                 end
%                 if strcmp(output_sheets(index), 'network_weights')
%                     [input_num, input_txt] = xlsread(filename, 'network_weights');
%                     [output_num, output_txt] = xlsread(testOutputFile, 'network_weights');
%                     testCase.assertEqual(input_num, output_num);
%                     testCase.assertEqual(input_txt, output_txt);
%                 end
%                 if strcmp(output_sheets(index), 'optimization_parameters')
%                     [input_num, input_txt] = xlsread(filename, 'optimization_parameters');
%                     [output_num, output_txt] = xlsread(testOutputFile, 'optimization_parameters');
%                     testCase.assertEqual(input_num, output_num);
%                     testCase.assertEqual(input_txt, output_txt);
%                 end
%                 if strcmp(output_sheets(index), 'threshold_b')
%                     [input_num, input_txt] = xlsread(filename, 'threshold_b');
%                     [output_num, output_txt] = xlsread(testOutputFile, 'threshold_b');
%                     testCase.assertEqual(input_num, output_num);
%                     testCase.assertEqual(input_txt, output_txt);
%                 end
                j = j + 1;
            end
            
%             function test2 (testCase)
%                 
%                 filename = '3-genes_3-edges_artificial-data_Sigmoid_estimation_2.xls';
%                 inputFile = which(filename);
%                 [~, sheets] = xlsfinfo(inputFile);
%             
%                 testOutputFile = '3-genes_3-edges_artificial-data_Sigmoid_estimation_2_output.xls';
%                 [~, output_sheets] = xlsfinfo(testOutputFile);
%                 
%                 
%             end
            
        end
        
    end
    
end