classdef deletedStrainTest < matlab.unittest.TestCase

    properties
        test_dir = '..\deleted_strains_tests\'
    end
    
    methods(TestClassSetup)
        function addPath(testCase)
            addpath([pwd '/../../matlab']);
        end
    end
    
    methods (Test)
        function testIdentifyDeletedStrainLowerCaseToLowerCase(testCase)
            GRNstruct.inputFile = [testCase.test_dir 'strain_names_lower_case_in_optim_lower_case_in_expression_test_sheet'];
            addpath([pwd '/../../matlab']);
            GRNstruct = readInputSheet(GRNstruct);            
            testCase.assertEqual(GRNstruct.microData(1).deletion, 0, GRNstruct.inputFile);
            testCase.assertEqual(GRNstruct.microData(2).deletion, 3, GRNstruct.inputFile);    
        end
        
        function testIdentifyDeletedStrainLowerCaseToUpperCase(testCase)
            GRNstruct.inputFile = [testCase.test_dir 'strain_names_lower_case_in_optim_upper_case_in_expression_test_sheet'];
            addpath([pwd '/../../matlab']);
            GRNstruct = readInputSheet(GRNstruct);            
            testCase.assertEqual(GRNstruct.microData(1).deletion, 0, GRNstruct.inputFile);
            testCase.assertEqual(GRNstruct.microData(2).deletion, 3, GRNstruct.inputFile);    
        end
        
        function testIdentifyDeletedStrainLowerCaseToMixedCase(testCase)
            GRNstruct.inputFile = [testCase.test_dir 'strain_names_lower_case_in_optim_mixed_case_in_expression_test_sheet'];
            addpath([pwd '/../../matlab']);
            GRNstruct = readInputSheet(GRNstruct);            
            testCase.assertEqual(GRNstruct.microData(1).deletion, 0, GRNstruct.inputFile);
            testCase.assertEqual(GRNstruct.microData(2).deletion, 3, GRNstruct.inputFile);    
        end
        
        function testIdentifyDeletedStrainUpperCaseToLowerCase(testCase)
            GRNstruct.inputFile = [testCase.test_dir 'strain_names_upper_case_in_optim_lower_case_in_expression_test_sheet'];
            addpath([pwd '/../../matlab']);
            GRNstruct = readInputSheet(GRNstruct);            
            testCase.assertEqual(GRNstruct.microData(1).deletion, 0, GRNstruct.inputFile);
            testCase.assertEqual(GRNstruct.microData(2).deletion, 3, GRNstruct.inputFile);    
        end
        
        function testIdentifyDeletedStrainUpperCaseToUpperCase(testCase)
            GRNstruct.inputFile = [testCase.test_dir 'strain_names_upper_case_in_optim_upper_case_in_expression_test_sheet'];
            addpath([pwd '/../../matlab']);
            GRNstruct = readInputSheet(GRNstruct);            
            testCase.assertEqual(GRNstruct.microData(1).deletion, 0, GRNstruct.inputFile);
            testCase.assertEqual(GRNstruct.microData(2).deletion, 3, GRNstruct.inputFile);    
        end
        
        function testIdentifyDeletedStrainUpperCaseToMixedCase(testCase)
            GRNstruct.inputFile = [testCase.test_dir 'strain_names_upper_case_in_optim_mixed_case_in_expression_test_sheet'];
            addpath([pwd '/../../matlab']);
            GRNstruct = readInputSheet(GRNstruct);            
            testCase.assertEqual(GRNstruct.microData(1).deletion, 0, GRNstruct.inputFile);
            testCase.assertEqual(GRNstruct.microData(2).deletion, 3, GRNstruct.inputFile);    
        end
        
        function testIdentifyDeletedStrainMixedCaseToLowerCase(testCase)
            GRNstruct.inputFile = [testCase.test_dir 'strain_names_mixed_case_in_optim_lower_case_in_expression_test_sheet'];
            addpath([pwd '/../../matlab']);
            GRNstruct = readInputSheet(GRNstruct);            
            testCase.assertEqual(GRNstruct.microData(1).deletion, 0,GRNstruct.inputFile);
            testCase.assertEqual(GRNstruct.microData(2).deletion, 3,GRNstruct.inputFile);    
        end
        
        function testIdentifyDeletedStrainMixedCaseToUpperCase(testCase)
            GRNstruct.inputFile = [testCase.test_dir 'strain_names_mixed_case_in_optim_upper_case_in_expression_test_sheet'];
            addpath([pwd '/../../matlab']);
            GRNstruct = readInputSheet(GRNstruct);            
            testCase.assertEqual(GRNstruct.microData(1).deletion, 0,GRNstruct.inputFile);
            testCase.assertEqual(GRNstruct.microData(2).deletion, 3,GRNstruct.inputFile);    
        end
        
        function testIdentifyDeletedStrainMixedCaseToMixedCase(testCase)
            GRNstruct.inputFile = [testCase.test_dir 'strain_names_mixed_case_in_optim_mixed_case_in_expression_test_sheet'];
            addpath([pwd '/../../matlab']);
            GRNstruct = readInputSheet(GRNstruct);            
            testCase.assertEqual(GRNstruct.microData(1).deletion, 0, GRNstruct.inputFile);
            testCase.assertEqual(GRNstruct.microData(2).deletion, 3, GRNstruct.inputFile);    
        end
        
        function testDeletionParameterRowIgnored(testCase)
            GRNstruct.inputFile = [testCase.test_dir 'deletion_parameter_ignored_test_sheet'];
            GRNstruct = readInputSheet(GRNstruct);            
            testCase.assertEqual(GRNstruct.microData(1).deletion, 0,GRNstruct.inputFile);
            testCase.assertEqual(GRNstruct.microData(2).deletion, 3,GRNstruct.inputFile);
        end
        
        function testLeadingOrTrailingWhiteSpaceDoesNotMatter(testCase)
            GRNstruct.inputFile = [testCase.test_dir 'white_space_test_sheet'];
            GRNstruct = readInputSheet(GRNstruct);            
            testCase.assertEqual(GRNstruct.microData(1).deletion, 0,GRNstruct.inputFile);
            testCase.assertEqual(GRNstruct.microData(2).deletion, 3,GRNstruct.inputFile);
        end
        
    end
end
