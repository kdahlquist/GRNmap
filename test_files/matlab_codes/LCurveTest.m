classdef LCurveTest < matlab.unittest.TestCase
   properties
       test_dir = [pwd '\..\perturbation_tests\math_post_L-curve_corrected\']
       previous_dir = pwd
       GRNstruct
   end
   
   methods (TestClassSetup)
       function runGRNmap (testCase)
           addpath([pwd '/../../matlab']);
           testCase.GRNstruct.inputFile = [testCase.test_dir '4-genes_6-edges_artificial-data_Sigmoidal_estimation_fixb-1_fixP-1_no-graph_test1_LCurve.xlsx'];
           testCase.GRNstruct.directory = tempdir;
           cd(tempdir);
           GRNLCurve(testCase.GRNstruct);
       end 
   end
   
   methods (TestMethodTeardown)
       function revertPath (testCase)
           cd (testCase.previous_dir);
       end
   end
   
   methods (Test)
       function testIfLCurveAlphaIsCorrect (testCase)
           [~, fileName, ~] = fileparts(testCase.GRNstruct.inputFile);
           [expected_values, expected_texts] = xlsread([fileName '_4_output.xlsx'], 'optimization_parameters');
           [actual_values, actual_texts] = xlsread([tempdir '4-genes_6-edges_artificial-data_Sigmoidal_estimation_fixb-1_fixP-1_no-graph_test1_LCurve_4_output.xlsx'], 'optimization_parameters');
           testCase.verifyEqual(expected_values, actual_values);
           testCase.verifyEqual(expected_texts, actual_texts);
       end
   end
end