classdef readInputSheetTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function testReadInputs (testCase)
            
            GRNstruct.filename = '3-genes_3-edges_artificial-data_Sigmoid_estimation_1.xls';
            GRNstruct.inputFile = which(GRNstruct.filename);
            [~, GRNstruct.sheets] = xlsfinfo(GRNstruct.inputFile);
            
            testOutputFile = '3-genes_3-edges_artificial-data_Sigmoid_estimation_1_output.xls';
            [~, output_sheets] = xlsfinfo(testOutputFile);
            
            sheetNames = {'production_rates', 'degradation_rates', 'wt_log2_expression', 'network','network_weights', 'optimization_parameters', 'threshold_b', 'wt_log2_optimized_expression', 'optimized_production_rates', 'optimized_threshold_b', 'network_optimized_weights'};
            testCase.assertEqual(any(ismember(GRNstruct.sheets, sheetNames)), true); 
            testCase.assertEqual(any(ismember(output_sheets, sheetNames)), true); 
           
%           Test for comparing input with corresponding output sheets
            j = 1;
            for index = 1:length(GRNstruct.sheets)
                
                if strcmp(output_sheets(index), GRNstruct.sheets(j))
                    [input_num, input_txt] = xlsread(GRNstruct.filename, j);
                    [output_num, output_txt] = xlsread(testOutputFile, j);
                    testCase.assertEqual(input_num, output_num);
                    disp(input_num);
                    disp(output_num);
                    testCase.assertEqual(input_txt, output_txt);
                end
%                 if strcmp(output_sheets(index), 'degradation_rates')
%                     [input_num, input_txt] = xlsread(GRNstruct.filename, 'degradation_rates');
%                     [output_num, output_txt] = xlsread(testOutputFile, 'degradation_rates');
%                     testCase.assertEqual(input_num, output_num);
%                     testCase.assertEqual(input_txt, output_txt);
%                 end
%                 if strcmp(output_sheets(index), 'wt_log2_expression')
%                     [input_num, input_txt] = xlsread(GRNstruct.filename, 'wt_log2_expression');
%                     [output_num, output_txt] = xlsread(testOutputFile, 'wt_log2_expression');
%                     testCase.assertEqual(input_num, output_num);
%                     testCase.assertEqual(input_txt, output_txt);
%                 end
%                 if strcmp(output_sheets(index), 'network')
%                     [input_num, input_txt] = xlsread(GRNstruct.filename, 'network');
%                     [output_num, output_txt] = xlsread(testOutputFile, 'network');
%                     testCase.assertEqual(input_num, output_num);
%                     testCase.assertEqual(input_txt, output_txt);
%                 end
%                 if strcmp(output_sheets(index), 'network_weights')
%                     [input_num, input_txt] = xlsread(GRNstruct.filename, 'network_weights');
%                     [output_num, output_txt] = xlsread(testOutputFile, 'network_weights');
%                     testCase.assertEqual(input_num, output_num);
%                     testCase.assertEqual(input_txt, output_txt);
%                 end
%                 if strcmp(output_sheets(index), 'optimization_parameters')
%                     [input_num, input_txt] = xlsread(GRNstruct.filename, 'optimization_parameters');
%                     [output_num, output_txt] = xlsread(testOutputFile, 'optimization_parameters');
%                     testCase.assertEqual(input_num, output_num);
%                     testCase.assertEqual(input_txt, output_txt);
%                 end
%                 if strcmp(output_sheets(index), 'threshold_b')
%                     [input_num, input_txt] = xlsread(GRNstruct.filename, 'threshold_b');
%                     [output_num, output_txt] = xlsread(testOutputFile, 'threshold_b');
%                     testCase.assertEqual(input_num, output_num);
%                     testCase.assertEqual(input_txt, output_txt);
%                 end
                j = j + 1;
            end
            
%         function test02SteadyState (testCase)
%             GRNstruct.filename = '3-genes_3-edges_artificial-data_Sigmoid_estimation_2.xls';
%             GRNstruct.inputFile = which(GRNstruct.filename);
%             [~, GRNstruct.sheets] = xlsfinfo(GRNstruct.inputFile);
%             
%             testCase.assertEqual(any(strcmp(GRNstruct.sheets, 'production_rates')), true);
%             testCase.assertEqual(any(strcmp(GRNstruct.sheets, 'degradation_rates')), true);
%             testCase.assertEqual(any(strcmp(GRNstruct.sheets, 'wt')), true);
%             testCase.assertEqual(any(strcmp(GRNstruct.sheets, 'network')), true);
%             testCase.assertEqual(any(strcmp(GRNstruct.sheets, 'network_weights')), true);
%             testCase.assertEqual(any(strcmp(GRNstruct.sheets, 'optimization_parameters')), true);
%             testCase.assertEqual(any(strcmp(GRNstruct.sheets, 'network_b')), true);
%             testCase.assertEqual(any(strcmp(GRNstruct.sheets, 'notes')), true);
%             
%             GRNstruct = readInputSheet(GRNstruct);
%             
%             %These are just copies of the ones above so are they really
%             %needed?
%             testCase.assertEqual(GRNstruct.degRates, [0.5,0.8,1]);
%             testCase.assertEqual(GRNstruct.GRNParams.wtmat, [0.1, 0, 0; 0, 0.1, 0; 0, 0, 0.1]);
%             testCase.assertEqual(GRNstruct.GRNParams.A, [1, 0, 0; 0, 1, 0; 0, 0, 1]);
%             testCase.assertEqual(GRNstruct.GRNParams.prorate, [1; 1.6; 2]);
%             testCase.assertEqual(GRNstruct.GRNParams.nedges, 3);
%             testCase.assertEqual(GRNstruct.GRNParams.n_active_genes, 3);
%             testCase.assertEqual(GRNstruct.GRNParams.active, [1, 2, 3]);
%             testCase.assertEqual(GRNstruct.GRNParams.alpha, 0.00000001);
%             testCase.assertEqual(GRNstruct.GRNParams.time, [5, 10, 20]);
%             testCase.assertEqual(GRNstruct.GRNParams.n_genes, 3);
%             testCase.assertEqual(GRNstruct.GRNParams.n_times, 3);
%             
%             testCase.assertEqual(GRNstruct.controlParams.simtime, (0:20));
%             testCase.assertEqual(GRNstruct.controlParams.kk_max, 1);
%             testCase.assertEqual(GRNstruct.controlParams.MaxIter, 1.00E+06);
%             testCase.assertEqual(GRNstruct.controlParams.MaxFunEval, 1.00E+06);
%             testCase.assertEqual(GRNstruct.controlParams.TolFun, 1.00E-05);
%             testCase.assertEqual(GRNstruct.controlParams.TolX, 0.00001);
%             testCase.assertEqual(GRNstruct.controlParams.estimateParams, 1.00E+00);
%             testCase.assertEqual(GRNstruct.controlParams.makeGraphs, 1.00E+00);
%             testCase.assertEqual(GRNstruct.controlParams.Sigmoid, 1);
%             testCase.assertEqual(GRNstruct.controlParams.fix_b, 1);
%             
%             %Only this one (so far) is different from the test above
%             testCase.assertEqual(GRNstruct.controlParams.fix_P, 0);
%             
    end
        
    end
    
end