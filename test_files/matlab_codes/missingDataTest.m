classdef missingDataTest < matlab.unittest.TestCase
   
    properties
       test_dir = [pwd '\..\missing_data_tests\']
       GRNstruct
    end
    
    methods (TestClassSetup)
        function setup (testCase)
             addpath([pwd '/../../matlab']);
        end
    end
    
    methods (Test)
        function testMissingDataForEntireTimepoint (testCase)
            testCase.GRNstruct.inputFile = [testCase.test_dir 'missing_data_for_entire_timepoint'];
            testCase.GRNstruct = readInputSheet (testCase.GRNstruct);
            testCase.assertTrue(testCase.GRNstruct.errorFlag);
        end
        
        function testMissingDataForAllButOne (testCase)
            testCase.GRNstruct.inputFile = [testCase.test_dir 'all_but_one_missing_data_for_timepoint'];
            testCase.GRNstruct = readInputSheet (testCase.GRNstruct);
            testCase.assertTrue(testCase.GRNstruct.warningFlag);
        end
        
        % Do we need to check if it actually stopped running on an
        % errorFlag?
    end
end