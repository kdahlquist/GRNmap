classdef LSETest < matlab.unittest.TestCase
    
    properties
        GRNstruct
        test_dir = '\..\lse_tests\'
    end
     
   methods (TestClassSetup)
       function addpath (testCase)
           addpath([pwd '/../../matlab']);
       end
       
       function setup (testCase)
           testCase.GRNstruct.inputFile = [testCase.test_dir '4-genes_6-edges_artificial-data_Sigmoidal_estimation_fixb-0_fixP-0_no-graph'];
           testCase.GRNstruct = readInputSheet(testCase.GRNstruct);
       end
   end
   
   methods (TestClassTeardown)
       function teardown(testCase)
          testCase.GRNstruct = {};
          clearvars -global
       end
   end
   
   methods (Test)
       function testLSE (testCase)
           testCase.GRNstruct = lse(testCase.GRNstruct);
       end
   end
end