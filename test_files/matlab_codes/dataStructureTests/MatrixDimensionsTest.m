classdef MatrixDimensionsTest < matlab.unittest.TestCase

    properties
        test_dir = '..\..\matrix_dimensions_test\'
        GRNstruct
    end
    
    methods(TestClassSetup)
        function readInputWithThreeStrains(testCase)
            testCase.GRNstruct.inputFile = [testCase.test_dir '4-gene_6-edges_wt-dcin5-dfhl1'];
            testCase.GRNstruct = readInputSheet(testCase.GRNstruct);
        end
    end
    
    methods (Test)
        function testCorrectlyReadsStrains(testCase)
            testCase.GRNstruct.inputFile = [testCase.test_dir '4-gene_6-edges_wt-dcin5'];
            testCase.GRNstruct = readInputSheet(testCase.GRNstruct);
            testCase.verifyFalse(length(testCase.GRNstruct.rawExpressionData) == 3);
        end
        
        function testCorrectlyReadsNetwork(testCase)
            testCase.GRNstruct.inputFile = [testCase.test_dir '3-gene_6-edges_wt-dcin5'];
            testCase.GRNstruct = readInputSheet(testCase.GRNstruct);
            testCase.verifyEqual(size(testCase.GRNstruct.rawExpressionData(1).data), [4 12]);
            testCase.verifyEqual(size(testCase.GRNstruct.rawExpressionData(2).data), [4 12]);
        end
    end
end
