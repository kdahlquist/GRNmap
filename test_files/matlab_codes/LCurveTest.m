classdef LCurveTest < matlab.unittest.TestCase
   properties
       test_dir = [pwd '\..\perturbation_tests\math_post_L-curve_corrected\']
       previous_dir = pwd
       GRNstruct
       alphaList
   end
   
   methods (TestClassSetup)
       function runGRNmap (testCase)
           addpath([pwd '/../../matlab']);
           testCase.alphaList = [0.8,0.5,0.2,0.1,0.08,0.05,0.02,0.01,0.008,0.005,0.002,0.001,0.0008,0.0005,0.0002,0.0001];
           testCase.GRNstruct.inputFile = [testCase.test_dir '4-genes_6-edges_artificial-data_Sigmoidal_estimation_fixb-1_fixP-1_no-graph_test1_LCurve.xlsx'];
           testCase.GRNstruct.directory = tempdir;
           cd(tempdir);
           testCase.GRNstruct = readInputSheet(testCase.GRNstruct);
           GRNLCurve(testCase.GRNstruct);
       end 
   end
   
   methods (TestClassTeardown)
       function revertPath (testCase)
           cd (testCase.previous_dir);
           deleteAllTempsCreated;
       end
   end
   
   methods (Test)
       function testProductionRatesCopiedCorrectly (testCase)
           [~, fileName, ~] = fileparts(testCase.GRNstruct.inputFile);
           if ~testCase.GRNstruct.controlParams.fix_P
               for i = 1:length(testCase.alphaList) - 1
                   [output_values, output_texts] = xlsread([tempdir fileName '_' num2str(i) '_output.xlsx'], 'optimized_production_rates');
                   [input_values, input_texts] = xlsread([tempdir fileName '_' num2str(i+1) '.xlsx'], 'production_rates');
                   testCase.verifyEqual(output_values, input_values, testCase.GRNstruct.input_file);
                   testCase.verifyEqual(output_texts, input_texts, testCase.GRNstruct.input_file);
               end
           end
       end
       
       function testThresholdCopiedCorrectly (testCase)
           [~, fileName, ~] = fileparts(testCase.GRNstruct.inputFile);
           if ~testCase.GRNstruct.controlParams.fix_b
               for i = 1:length(testCase.alphaList) - 1
                   [output_values, output_texts] = xlsread([tempdir fileName '_' num2str(i) '_output.xlsx'], 'optimized_threshold_b');
                   [input_values, input_texts] = xlsread([tempdir fileName '_' num2str(i+1) '.xlsx'], 'threshold_b');
                   testCase.verifyEqual(output_values, input_values, testCase.GRNstruct.input_file);
                   testCase.verifyEqual(output_texts, input_texts, testCase.GRNstruct.input_file);
               end
           end
       end
       
       function testNetworkWeightsCopiedCorrectly (testCase)
           [~, fileName, ~] = fileparts(testCase.GRNstruct.inputFile);
           for i = 1:length(testCase.alphaList) - 1
               [output_values, output_texts] = xlsread([tempdir fileName '_' num2str(i) '_output.xlsx'], 'network_optimized_weights');
               [input_values, input_texts] = xlsread([tempdir fileName '_' num2str(i+1) '.xlsx'], 'network_weights');
               testCase.verifyEqual(output_values, input_values, testCase.GRNstruct.input_file);
               testCase.verifyEqual(output_texts, input_texts, testCase.GRNstruct.input_file);
           end
       end
       
       function testOptimizationParametersCopiedCorrectly (testCase)
           [~, fileName, ~] = fileparts(testCase.GRNstruct.inputFile);
           for i = 1:length(testCase.alphaList)
               [input_values, ~] = xlsread([tempdir fileName '_' num2str(i) '.xlsx'], 'optimization_parameters');
               alpha = input_values(1);
               testCase.verifyEqual(alpha, testCase.alphaList(i), testCase.GRNstruct.input_file);
           end
       end
   end
end