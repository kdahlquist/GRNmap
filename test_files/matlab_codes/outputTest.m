classdef outputTest < matlab.unittest.TestCase
    
    methods (Test)
                
%       Test for finding out if worksheets exist
        function testOutputSheetsExist (testCase)
            
            global GRNstruct 
            
%           Check to see if original input worksheets are copied over
            sheet_counter = 1;
            for index = 1:length(GRNstruct.sheets)
                if strcmp(GRNstruct.output_sheets(index), GRNstruct.sheets(sheet_counter))
                    [input_num, input_txt] = xlsread(GRNstruct.inputFile, sheet_counter);
                    [output_num, output_txt] = xlsread(GRNstruct.output_file, sheet_counter);
                    testCase.assertEqual(input_num, output_num);
                    testCase.assertEqual(input_txt, output_txt);
                end
                sheet_counter = sheet_counter + 1;
            end
        end
        
%       Test for finding out if the correct numbers are outputted
        function testSigmaValues(testCase)
           global GRNstruct
           for timepoint_index = 1:length(GRNstruct.GRNParams.num_times)
               for strain_index = 1:length(GRNstruct.microData)
                   expected_sigmas = zeros(GRNstruct.GRNParams.num_genes, GRNstruct.GRNParams.num_times);
                   output_sigmas  = xlsread(GRNstruct.output_file, [GRNstruct.microData(strain_index).Strain '_sigmas']);
                   testCase.assertEqual(round(output_sigmas(1,:), 6), round((0.4:0.4:1.6), 6));
                   testCase.assertEqual(round(output_sigmas(2:end,:), 6), expected_sigmas);
               end
           end
        end
        
%       Test if correct simtime is outputted to log2_optimized_expression        
        function testSimTime(testCase)
            global GRNstruct
            for strain_index = 1:length(GRNstruct.microData)
                if GRNstruct.controlParams.simulation_timepoints(1) == 0
                    testCase.assertEqual(round(GRNstruct.controlParams.simulation_timepoints, 6), round((0:0.1:2), 6));
                end
                % What if there is no timepoint = 0?
                
            end
        end
        
%       This function will need to be separated eventually into its own file
        
                        
        function testGraphsExist (testCase)
            global GRNstruct
           
            previous_dir = pwd;
            previous_file = GRNstruct.inputFile;
            GRNstruct.directory = tempdir;
            GRNstruct.inputFile = GRNstruct.test_file;
            cd(tempdir);
            
            output (GRNstruct);
            
%           Test if graphs are made only when they're supposed to
            if GRNstruct.controlParams.make_graphs
                testCase.verifyEqual(exist('ACE2.jpg', 'file'), 2);
                testCase.verifyEqual(exist('AFT2.jpg', 'file'), 2);
                testCase.verifyEqual(exist('CIN5.jpg', 'file'), 2);
                testCase.verifyEqual(exist('FHL1.jpg', 'file'), 2);
            else
                testCase.verifyEqual(exist('ACE2.jpg', 'file'), 0);
                testCase.verifyEqual(exist('AFT2.jpg', 'file'), 0);
                testCase.verifyEqual(exist('CIN5.jpg', 'file'), 0);
                testCase.verifyEqual(exist('FHL1.jpg', 'file'), 0);
            end
                     
            % Test if there is an optimization diagnostics image
            if GRNstruct.GRNOutput.counter >= 100
                testCase.verifyEqual(exist('optimization_diagnostic.jpg', 'file'), 2);
            else
                testCase.verifyEqual(exist('optimization_diagnostic.jpg', 'file'), 0);
            end
            
            GRNstruct.directory = previous_dir;
            GRNstruct.inputFile = previous_file;
            cd(previous_dir);
        end
         
        function testNetworkWeightExists (testCase)
            global GRNstruct
            previous_dir = pwd;
            cd(tempdir);
            [~, GRNstruct.output_sheets] = xlsfinfo (GRNstruct.output_file);
            testCase.verifyTrue(any(ismember('network_optimized_weights', GRNstruct.output_sheets)));
            cd(previous_dir);
        end
        
        function testDiagnosticExists (testCase)
            global GRNstruct
            previous_dir = pwd;
            cd(tempdir);
            [~, GRNstruct.output_sheets] = xlsfinfo (GRNstruct.output_file);
            testCase.verifyTrue(any(ismember('optimization_diagnostics', GRNstruct.output_sheets)));
            cd(previous_dir);
        end
        
        function testoptimizedExpressionExists (testCase)
            global GRNstruct
            previous_dir = pwd;
            cd(tempdir);
            [~, GRNstruct.output_sheets] = xlsfinfo (GRNstruct.output_file);
            
            for strain_index = 1:length(GRNstruct.microData)
                testCase.verifyTrue(any(ismember([GRNstruct.microData(strain_index).Strain '_log2_optimized_expression'], GRNstruct.output_sheets)));
            end
            cd(previous_dir);
        end
        
        function testSigmaExists (testCase)
            global GRNstruct
            previous_dir = pwd;
            cd(tempdir);
            [~, GRNstruct.output_sheets] = xlsfinfo (GRNstruct.output_file);
            
            for strain_index = 1:length(GRNstruct.microData)
                testCase.verifyTrue(any(ismember([GRNstruct.microData(strain_index).Strain '_sigmas'], GRNstruct.output_sheets)));
            end
            cd(previous_dir);
        end
        
        function testOptimizedThresholdExists (testCase)
            global GRNstruct
            previous_dir = pwd;
            cd(tempdir);
            [~, GRNstruct.output_sheets] = xlsfinfo (GRNstruct.output_file);
            
            if ~GRNstruct.controlParams.fix_b
               testCase.verifyTrue(any(ismember('optimized_threshold_b', GRNstruct.output_sheets))); 
            else
               testCase.verifyTrue(not(ismember('optimized_threshold_b', GRNstruct.output_sheets)));
            end
            cd(previous_dir);
        end
            
        function testOptimizedProductionRateExists (testCase)
            global GRNstruct
            previous_dir = pwd;
            cd(tempdir);
            [~, GRNstruct.output_sheets] = xlsfinfo (GRNstruct.output_file);
            if ~GRNstruct.controlParams.fix_P
               testCase.verifyTrue(any(ismember('optimized_production_rates', GRNstruct.output_sheets))); 
            else
               testCase.verifyTrue(not(ismember('optimized_production_rates', GRNstruct.output_sheets)));
            end
            
            GRNstruct.directory = previous_dir;
            cd(previous_dir);
        end
        
        function testMatFileExistsWhenEstimateParamsZero (testCase)
            global GRNstruct
            previous_dir = pwd;
            cd(tempdir);
            [~,file_name] = fileparts(GRNstruct.inputFile);
            testCase.verifyEqual(exist([tempdir file_name '_output.mat'], 'file'), 2);
            cd(previous_dir);
        end
        
        function testOutputThresholdCorrect (testCase)
            global GRNstruct
            if ~GRNstruct.controlParams.fix_b
                [expected_output_data, ~] = xlsread (GRNstruct.output_file, 'optimized_threshold_b');
                previous_dir = pwd;
                cd (tempdir);
                [actual_output_data, ~] = xlsread (GRNstruct.output_file, 'optimized_threshold_b');
                testCase.verifyEqual (round(actual_output_data, 6), round(expected_output_data, 6));
                cd (previous_dir);
            end
        end
        
        function testOutputThresholdNamesCorrect (testCase)
            global GRNstruct
            if ~GRNstruct.controlParams.fix_b
                [~, expected_output_names] = xlsread (GRNstruct.output_file, 'optimized_threshold_b');
                previous_dir = pwd;
                cd (tempdir);
                [~, actual_output_names] = xlsread (GRNstruct.output_file, 'optimized_threshold_b');
                testCase.verifyEqual (actual_output_names, expected_output_names);
                cd (previous_dir);
            end
        end
        
        function testOutputWildTypeExpressionCorrect (testCase)
            global GRNstruct
            
            [expected_output_data, ~] = xlsread (GRNstruct.output_file, 'wt_log2_optimized_expression');
            previous_dir = pwd;
            cd (tempdir);
            [actual_output_data, ~] = xlsread (GRNstruct.output_file, 'wt_log2_optimized_expression');
            testCase.verifyEqual (round(actual_output_data, 6), round(expected_output_data, 6));
            cd (previous_dir);
        end
        
        function testOutputWildTypeExpressionNamesCorrect (testCase)
            global GRNstruct
            
            [~, expected_output_names] = xlsread (GRNstruct.output_file, 'wt_log2_optimized_expression');
            previous_dir = pwd;
            cd (tempdir);
            [~, actual_output_names] = xlsread (GRNstruct.output_file, 'wt_log2_optimized_expression');
            testCase.verifyEqual (actual_output_names, expected_output_names);
            cd (previous_dir);
        end
        
        function testOutputCin5ExpressionCorrect (testCase)
            global GRNstruct
            
            [expected_output_data, ~] = xlsread (GRNstruct.output_file, 'dcin5_log2_optimized_expression');
            previous_dir = pwd;
            cd (tempdir);
            [actual_output_data, ~] = xlsread (GRNstruct.output_file, 'dcin5_log2_optimized_expression');
            testCase.verifyEqual (round(actual_output_data, 6), round(expected_output_data, 6));
            cd (previous_dir);
        end
        
        function testOutputCin5ExpressionNamesCorrect (testCase)
            global GRNstruct
            
            [~, expected_output_names] = xlsread (GRNstruct.output_file, 'dcin5_log2_optimized_expression');
            previous_dir = pwd;
            cd (tempdir);
            [~, actual_output_names] = xlsread (GRNstruct.output_file, 'dcin5_log2_optimized_expression');
            testCase.verifyEqual (actual_output_names, expected_output_names);
            cd (previous_dir);
        end
        
        function testOutputWildTypeSigmasCorrect (testCase)
            global GRNstruct
            
            [expected_output_data, ~] = xlsread (GRNstruct.output_file, 'wt_sigmas');
            previous_dir = pwd;
            cd (tempdir);
            [actual_output_data, ~] = xlsread (GRNstruct.output_file, 'wt_sigmas');
            testCase.verifyEqual (round(actual_output_data, 6), round(expected_output_data, 6));
            cd (previous_dir);
        end
        
        function testOutputWildTypeSigmasNamesCorrect (testCase)
            global GRNstruct
            
            [~, expected_output_names] = xlsread (GRNstruct.output_file, 'wt_sigmas');
            previous_dir = pwd;
            cd (tempdir);
            [~, actual_output_names] = xlsread (GRNstruct.output_file, 'wt_sigmas');
            testCase.verifyEqual (actual_output_names, expected_output_names);
            cd (previous_dir);
        end
        
        function testOutputCin5SigmasCorrect (testCase)
            global GRNstruct
            
            [expected_output_data, ~] = xlsread (GRNstruct.output_file, 'dcin5_sigmas');
            previous_dir = pwd;
            cd (tempdir);
            [actual_output_data, ~] = xlsread (GRNstruct.output_file, 'dcin5_sigmas');
            testCase.verifyEqual (round(actual_output_data, 6), round(expected_output_data, 6));
            cd (previous_dir);
        end
        
        function testOutputCin5SigmasNamesCorrect (testCase)
            global GRNstruct
            
            [~, expected_output_names] = xlsread (GRNstruct.output_file, 'dcin5_sigmas');
            previous_dir = pwd;
            cd (tempdir);
            [~, actual_output_names] = xlsread (GRNstruct.output_file, 'dcin5_sigmas');
            testCase.verifyEqual (actual_output_names, expected_output_names);
            cd (previous_dir);
        end
        
        function testOutputOptimizedProductionRatesCorrect (testCase)
            global GRNstruct
            if ~GRNstruct.controlParams.fix_P
                [expected_output_data, ~] = xlsread (GRNstruct.output_file, 'optimized_production_rates');
                previous_dir = pwd;
                cd (tempdir);
                [actual_output_data, ~] = xlsread (GRNstruct.output_file, 'optimized_production_rates');
                testCase.verifyEqual (round(actual_output_data, 6), round(expected_output_data, 6));
                cd (previous_dir);
            end
        end
        
        function testOutputOptimizedProductionRatesNamesCorrect (testCase)
            global GRNstruct
            if ~GRNstruct.controlParams.fix_P
                [~, expected_output_names] = xlsread (GRNstruct.output_file, 'optimized_production_rates');
                previous_dir = pwd;
                cd (tempdir);
                [~, actual_output_names] = xlsread (GRNstruct.output_file, 'optimized_production_rates');
                testCase.verifyEqual (actual_output_names, expected_output_names);
                cd (previous_dir);
            end
        end
        
        function testOutputNetworkOptimizedWeightsCorrect (testCase)
           global GRNstruct
            
            [expected_output_data, ~] = xlsread (GRNstruct.output_file, 'network_optimized_weights');
            previous_dir = pwd;
            cd (tempdir);
            [actual_output_data, ~] = xlsread (GRNstruct.output_file, 'network_optimized_weights');
            testCase.verifyEqual (round(actual_output_data, 6), round(expected_output_data, 6));
            cd (previous_dir);
        end
        
        function testOutputNetworkOptimizedWeightsNamesCorrect (testCase)
           global GRNstruct
            
            [~, expected_output_names] = xlsread (GRNstruct.output_file, 'network_optimized_weights');
            previous_dir = pwd;
            cd (tempdir);
            [~, actual_output_names] = xlsread (GRNstruct.output_file, 'network_optimized_weights');
            testCase.verifyEqual (actual_output_names, expected_output_names);
            cd (previous_dir);
        end
        
         function testOutputOptimizationDiagnostics (testCase)
           global GRNstruct
            
            [expected_output_data, ~] = xlsread (GRNstruct.output_file, 'optimization_diagnostics');
            previous_dir = pwd;
            cd (tempdir);
            [actual_output_data, ~] = xlsread (GRNstruct.output_file, 'optimization_diagnostics');
            testCase.verifyEqual (round(actual_output_data, 6), round(expected_output_data, 6));
            cd (previous_dir);
         end
         
         function testOutputOptimizationDiagnosticsTextCorrect (testCase)
           global GRNstruct
            
            [~, expected_output_names] = xlsread (GRNstruct.output_file, 'optimization_diagnostics');
            previous_dir = pwd;
            cd (tempdir);
            [~, actual_output_names] = xlsread (GRNstruct.output_file, 'optimization_diagnostics');
            testCase.verifyEqual (actual_output_names, expected_output_names);
            
            cd (previous_dir);
         end  
        
    end
       
end