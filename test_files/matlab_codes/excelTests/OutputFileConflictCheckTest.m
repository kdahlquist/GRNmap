classdef OutputFileConflictCheckTest < matlab.unittest.TestCase
 
    properties
        file = 'test_input.xlsx';
        test_dir = '\..\..\output_file_conflict_check_test';
    end
 
    methods (TestClassSetup)
        function addGRNmapPath (testCase) %#ok<MANU>
            addpath([pwd '\..\..\..\matlab'])
        end        
    end

    methods (Test)
        function testOutputFileCheckWithoutConflict(testCase)
            directory = [pwd testCase.test_dir '\without_output_conflict'];
            testCase.assertFalse(outputFileConflictCheck(directory, testCase.file));
        end

        function testOutputFileCheckWithConflict(testCase)
            directory = [pwd testCase.test_dir '\with_output_conflict'];
            testCase.assertTrue(outputFileConflictCheck(directory, testCase.file));
        end
    end
end
