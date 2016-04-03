classdef outputTest < matlab.unittest.TestCase
    
    properties (ClassSetupParameter)
        filename = {'4-genes_6-edges_artificial-data_MM_estimation_fixP-0_graph',...
                    '4-genes_6-edges_artificial-data_MM_estimation_fixP-0_no-graph',...
                    '4-genes_6-edges_artificial-data_MM_estimation_fixP-1_graph',...
                    '4-genes_6-edges_artificial-data_MM_estimation_fixP-1_no-graph',...
                    '4-genes_6-edges_artificial-data_MM_forward_graph',...
                    '4-genes_6-edges_artificial-data_MM_forward_no-graph',...
                    '4-genes_6-edges_artificial-data_Sigmoidal_estimation_fixb-0_fixP-0_graph',...
                    '4-genes_6-edges_artificial-data_Sigmoidal_estimation_fixb-0_fixP-0_no-graph',...
                    '4-genes_6-edges_artificial-data_Sigmoidal_estimation_fixb-0_fixP-1_graph',...
                    '4-genes_6-edges_artificial-data_Sigmoidal_estimation_fixb-0_fixP-1_no-graph',...
                    '4-genes_6-edges_artificial-data_Sigmoidal_estimation_fixb-1_fixP-0_graph',...
                    '4-genes_6-edges_artificial-data_Sigmoidal_estimation_fixb-1_fixP-0_no-graph',...
                    '4-genes_6-edges_artificial-data_Sigmoidal_estimation_fixb-1_fixP-1_graph',...
                    '4-genes_6-edges_artificial-data_Sigmoidal_estimation_fixb-1_fixP-1_no-graph',...
                    '4-genes_6-edges_artificial-data_Sigmoidal_forward_graph',...
                    '4-genes_6-edges_artificial-data_Sigmoidal_forward_no-graph'} 
    end
    
    properties
        GRNstruct
        previous_dir
        input_file
        expected_output_values
        expected_output_texts
        test_dir = '\..\sixteen_tests\'
    end
    
    methods (TestClassSetup)
        function setupGRNstruct(testCase, filename)
            testCase.GRNstruct.output_file = [pwd testCase.test_dir filename '_output'];
%             global GRNstruct
%             testCase.GRNstruct = GRNstruct;
%             [~, name, ext] = fileparts(testCase.GRNstruct.test_file);
%             testCase.GRNstruct.output_file = [name '_output' ext];
            [~, testCase.GRNstruct.output_sheets] = xlsfinfo(testCase.GRNstruct.output_file);
            disp(testCase.GRNstruct.output_file)
            testCase.previous_dir = pwd;
            disp('a')
            testCase.input_file = [pwd testCase.test_dir filename];
                        disp('b')
            testCase.GRNstruct.directory = tempdir;
                        disp('c')
            cd(tempdir);
            
            output(testCase.GRNstruct);
                        disp('e')
            [~, testCase.GRNstruct.output_sheets] = xlsfinfo (testCase.GRNstruct.output_file);
                        disp('f')

        end
    end
    
    methods (TestMethodTeardown)
        function resetPath (testCase)
            testCase.GRNstruct.directory = testCase.previous_dir;
            testCase.GRNstruct.inputFile = testCase.input_file;
            cd(testCase.previous_dir);
        end
    end
    
    methods (Test)
%       Test for finding out if worksheets exist
        function testOutputSheetsExist (testCase)
                        
%           Check to see if original input worksheets are copied over
            sheet_counter = 1;
            for index = 1:length(testCase.GRNstruct.sheets)
                if strcmp(testCase.GRNstruct.output_sheets(index), testCase.GRNstruct.sheets(sheet_counter))
                    [input_num, input_txt] = xlsread(testCase.GRNstruct.inputFile, sheet_counter);
                    [output_num, output_txt] = xlsread(testCase.GRNstruct.output_file, sheet_counter);
                    testCase.assertEqual(input_num, output_num, testCase.GRNstruct.inputFile);
                    testCase.assertEqual(input_txt, output_txt, testCase.GRNstruct.inputFile);
                end
                sheet_counter = sheet_counter + 1;
            end
        end
        
%       Test for finding out if the correct numbers are outputted
        function testSigmaValues(testCase)
           for timepoint_index = 1:length(testCase.GRNstruct.GRNParams.num_times)
               for strain_index = 1:length(testCase.GRNstruct.microData)
                   expected_sigmas = zeros(testCase.GRNstruct.GRNParams.num_genes, testCase.GRNstruct.GRNParams.num_times);
                   output_sigmas  = xlsread(testCase.GRNstruct.output_file, ...
                                            [testCase.GRNstruct.microData(strain_index).Strain '_sigmas']);
                   testCase.assertEqual(round(output_sigmas(1,:), 6),...
                                        round((0.4:0.4:1.6), 6),...
                                        testCase.GRNstruct.inputFile);
                   testCase.assertEqual(round(output_sigmas(2:end,:), 6),...
                                        expected_sigmas,...
                                        testCase.GRNstruct.inputFile);
               end
           end
        end
        
%       Test if correct simtime is outputted to log2_optimized_expression        
        function testSimTime(testCase)
            for strain_index = 1:length(testCase.GRNstruct.microData)
                if testCase.GRNstruct.controlParams.simulation_timepoints(1) == 0
                    testCase.assertEqual(round(testCase.GRNstruct.controlParams.simulation_timepoints, 6),...
                                         round((0:0.1:2), 6),...
                                         testCase.GRNstruct.inputFile);
                end
                % What if there is no timepoint = 0?
                
            end
        end
        
%       This function will need to be separated eventually into its own file
        
                        
        function testGraphsExist (testCase)
%           Test if graphs are made only when they're supposed to
            if testCase.GRNstruct.controlParams.make_graphs
                for genes = 1:length(testCase.GRNstruct.labels)
                    testCase.verifyEqual(exist([tempdir '\' testCase.GRNstruct.labels(genes) '.jpg'], 'file'),...
                                     2,...
                                     testCase.GRNstruct.inputFile);
                end
            else
                 for genes = 1:length(testCase.GRNstruct.labels)
                    testCase.verifyEqual(exist([tempdir '\' testCase.GRNstruct.labels(genes) '.jpg'], 'file'),...
                                     0,...
                                     testCase.GRNstruct.inputFile);
                end
            end
                     
            % Test if there is an optimization diagnostics image
            if testCase.GRNstruct.GRNOutput.counter >= 100
                testCase.verifyEqual(exist([tempdir '\optimization_diagnostic.jpg'], 'file'),...
                                     2,...
                                     testCase.GRNstruct.inputFile);
            else
                testCase.verifyEqual(exist([tempdir '\optimization_diagnostic.jpg'], 'file'),...
                                     0,...
                                     testCase.GRNstruct.inputFile);
            end
        end
         
        function testNetworkWeightExists (testCase)
            testCase.verifyTrue(any(ismember('network_optimized_weights', testCase.GRNstruct.output_sheets)),...
                                testCase.GRNstruct.inputFile);
        end
        
        function testDiagnosticExists (testCase)
            testCase.verifyTrue(any(ismember('optimization_diagnostics', testCase.GRNstruct.output_sheets)),...
                                testCase.GRNstruct.inputFile);
        end
        
        function testoptimizedExpressionExists (testCase)
            for strain_index = 1:length(testCase.GRNstruct.microData)
                testCase.verifyTrue(any(ismember([testCase.GRNstruct.microData(strain_index).Strain '_log2_optimized_expression'],...
                                     testCase.GRNstruct.output_sheets)),...
                                     testCase.GRNstruct.inputFile);
            end
        end
        
        function testSigmaExists (testCase)
            for strain_index = 1:length(testCase.GRNstruct.microData)
                testCase.verifyTrue(any(ismember([testCase.GRNstruct.microData(strain_index).Strain '_sigmas'],...
                                    testCase.GRNstruct.output_sheets)),...
                                    testCase.GRNstruct.inputFile);
            end
        end
        
        function testOptimizedThresholdExists (testCase)
            if ~testCase.GRNstruct.controlParams.fix_b
               testCase.verifyTrue(any(ismember('optimized_threshold_b',...
                                   testCase.GRNstruct.output_sheets)),...
                                   testCase.GRNstruct.inputFile); 
            else
               testCase.verifyTrue(not(ismember('optimized_threshold_b',...
                                   testCase.GRNstruct.output_sheets)),...
                                   testCase.GRNstruct.inputFile);
            end
        end
            
        function testOptimizedProductionRateExists (testCase)
            if ~testCase.GRNstruct.controlParams.fix_P
               testCase.verifyTrue(any(ismember('optimized_production_rates',...
                                   testCase.GRNstruct.output_sheets)),...
                                   testCase.GRNstruct.inputFile); 
            else
               testCase.verifyTrue(not(ismember('optimized_production_rates',...
                                   testCase.GRNstruct.output_sheets)),...
                                   testCase.GRNstruct.inputFile);
            end
        end
        
        function testMatFileExistsWhenEstimateParamsZero (testCase)
            [~,file_name] = fileparts(testCase.GRNstruct.inputFile);
            testCase.verifyEqual(exist([tempdir file_name '_output.mat'], 'file'),2,...
                                 testCase.GRNstruct.inputFile);
        end
        
        function testOutputThresholdCorrect (testCase)
            if ~testCase.GRNstruct.controlParams.fix_b
                [expected_output_data, ~] = xlsread (testCase.GRNstruct.output_file, 'optimized_threshold_b');
                [actual_output_data, ~] = xlsread ([tempdir '\' testCase.GRNstruct.output_file], 'optimized_threshold_b');
                testCase.verifyEqual (round(actual_output_data, 6),...
                                      round(expected_output_data, 6),...
                                      testCase.GRNstruct.inputFile);
            end
        end
        
        function testOutputThresholdNamesCorrect (testCase)
            if ~testCase.GRNstruct.controlParams.fix_b
                [~, expected_output_names] = xlsread (testCase.GRNstruct.output_file, 'optimized_threshold_b');
                [~, actual_output_names] = xlsread ([tempdir '\' testCase.GRNstruct.output_file], 'optimized_threshold_b');
                testCase.verifyEqual (actual_output_names, expected_output_names,...
                                      testCase.GRNstruct.inputFile);
            end
        end
        
        function testOutputWildTypeExpressionCorrect (testCase)            
            [expected_output_data, ~] = xlsread (testCase.GRNstruct.output_file, 'wt_log2_optimized_expression');
            [actual_output_data, ~] = xlsread ([tempdir '\' testCase.GRNstruct.output_file], 'wt_log2_optimized_expression');
            testCase.verifyEqual (round(actual_output_data, 6),...
                                  round(expected_output_data, 6),...
                                  testCase.GRNstruct.inputFile);
        end
        
        function testOutputWildTypeExpressionNamesCorrect (testCase)            
            [~, expected_output_names] = xlsread (testCase.GRNstruct.output_file, 'wt_log2_optimized_expression');
            [~, actual_output_names] = xlsread ([tempdir '\' testCase.GRNstruct.output_file], 'wt_log2_optimized_expression');
            testCase.verifyEqual (actual_output_names, expected_output_names,...
                                  testCase.GRNstruct.inputFile);
        end
        
        function testOutputCin5ExpressionCorrect (testCase)            
            [expected_output_data, ~] = xlsread (testCase.GRNstruct.output_file, 'dcin5_log2_optimized_expression');
            [actual_output_data, ~] = xlsread ([tempdir '\' testCase.GRNstruct.output_file], 'dcin5_log2_optimized_expression');
            testCase.verifyEqual (round(actual_output_data, 6), round(expected_output_data, 6),...
                                  testCase.GRNstruct.inputFile);
        end
        
        function testOutputCin5ExpressionNamesCorrect (testCase)            
            [~, expected_output_names] = xlsread (testCase.GRNstruct.output_file, 'dcin5_log2_optimized_expression');
            [~, actual_output_names] = xlsread ([tempdir '\' testCase.GRNstruct.output_file], 'dcin5_log2_optimized_expression');
            testCase.verifyEqual (actual_output_names, expected_output_names,...
                                  testCase.GRNstruct.inputFile);
        end
        
        function testOutputWildTypeSigmasCorrect (testCase)            
            [expected_output_data, ~] = xlsread (testCase.GRNstruct.output_file, 'wt_sigmas');
            [actual_output_data, ~] = xlsread ([tempdir '\' testCase.GRNstruct.output_file], 'wt_sigmas');
            testCase.verifyEqual (round(actual_output_data, 6), round(expected_output_data, 6),...
                                  testCase.GRNstruct.inputFile);
        end
        
        function testOutputWildTypeSigmasNamesCorrect (testCase)
            [~, expected_output_names] = xlsread (testCase.GRNstruct.output_file, 'wt_sigmas');
            [~, actual_output_names] = xlsread ([tempdir '\' testCase.GRNstruct.output_file], 'wt_sigmas');
            testCase.verifyEqual (actual_output_names, expected_output_names,...
                                  testCase.GRNstruct.inputFile);
        end
        
        function testOutputCin5SigmasCorrect (testCase)
            [expected_output_data, ~] = xlsread (testCase.GRNstruct.output_file, 'dcin5_sigmas');
            [actual_output_data, ~] = xlsread ([tempdir '\' testCase.GRNstruct.output_file], 'dcin5_sigmas');
            testCase.verifyEqual (round(actual_output_data, 6), ...
                                  round(expected_output_data, 6),...
                                  testCase.GRNstruct.inputFile);
        end
        
        function testOutputCin5SigmasNamesCorrect (testCase)
            [~, expected_output_names] = xlsread (testCase.GRNstruct.output_file, 'dcin5_sigmas');
            [~, actual_output_names] = xlsread ([tempdir '\' testCase.GRNstruct.output_file], 'dcin5_sigmas');
            testCase.verifyEqual (actual_output_names, expected_output_names,...
                                  testCase.GRNstruct.inputFile);
        end
        
        function testOutputOptimizedProductionRatesCorrect (testCase)
            if ~testCase.GRNstruct.controlParams.fix_P
                [expected_output_data, ~] = xlsread (testCase.GRNstruct.output_file, 'optimized_production_rates');
                [actual_output_data, ~] = xlsread ([tempdir '\' testCase.GRNstruct.output_file], 'optimized_production_rates');
                testCase.verifyEqual (round(actual_output_data, 6),...
                                      round(expected_output_data, 6),...
                                      testCase.GRNstruct.inputFile);
            end
        end
        
        function testOutputOptimizedProductionRatesNamesCorrect (testCase)
            if ~testCase.GRNstruct.controlParams.fix_P
                [~, expected_output_names] = xlsread (testCase.GRNstruct.output_file, 'optimized_production_rates');
                [~, actual_output_names] = xlsread ([tempdir '\' testCase.GRNstruct.output_file], 'optimized_production_rates');
                testCase.verifyEqual (actual_output_names, expected_output_names,...
                                      testCase.GRNstruct.inputFile);
            end
        end
        
        function testOutputNetworkOptimizedWeightsCorrect (testCase)            
            [expected_output_data, ~] = xlsread (testCase.GRNstruct.output_file, 'network_optimized_weights');
            [actual_output_data, ~] = xlsread ([tempdir '\' testCase.GRNstruct.output_file], 'network_optimized_weights');
            testCase.verifyEqual (round(actual_output_data, 6), round(expected_output_data, 6),...
                                  testCase.GRNstruct.inputFile);
        end
        
        function testOutputNetworkOptimizedWeightsNamesCorrect (testCase)            
            [~, expected_output_names] = xlsread (testCase.GRNstruct.output_file, 'network_optimized_weights');
            [~, actual_output_names] = xlsread ([tempdir '\' testCase.GRNstruct.output_file], 'network_optimized_weights');
            testCase.verifyEqual (actual_output_names, expected_output_names,...
                                  testCase.GRNstruct.inputFile);
        end
        
         function testOutputOptimizationDiagnostics (testCase)            
            [expected_output_data, ~] = xlsread (testCase.GRNstruct.output_file, 'optimization_diagnostics');
            [actual_output_data, ~] = xlsread ([tempdir '\' testCase.GRNstruct.output_file], 'optimization_diagnostics');
            testCase.verifyEqual (round(actual_output_data, 6), ...
                                  round(expected_output_data, 6),...
                                  testCase.GRNstruct.inputFile);
         end
         
         function testOutputOptimizationDiagnosticsTextCorrect (testCase)            
            [~, expected_output_names] = xlsread (testCase.GRNstruct.output_file, 'optimization_diagnostics');
            [~, actual_output_names] = xlsread ([tempdir '\' testCase.GRNstruct.output_file], 'optimization_diagnostics');
            testCase.verifyEqual (actual_output_names, expected_output_names,...
                                  testCase.GRNstruct.inputFile);
         end
         
         function testOutputOptimizationDiagnosticsNotSSE (testCase)
            expected_text_values = {'wt MSE', 'dcin5 MSE'};
            [~, actual_text_values] = xlsread ([tempdir '\' testCase.GRNstruct.output_file], 'optimization_diagnostics');
            testCase.verifyTrue(any(ismember(expected_text_values, actual_text_values)),...
                                testCase.GRNstruct.inputFile);
         end
    end
       
end