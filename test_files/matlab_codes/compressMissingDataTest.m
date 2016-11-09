classdef compressMissingData < matlab.unittest.TestCase

    properties
        test_dir = '..\compress_missing_data_tests\'
        GRNstruct
    end

    methods(TestClassSetup)
        function addPath(testCase)
            addpath([pwd '/../../matlab']);
            testCase.GRNstruct.inputFile = [testCase.test_dir '4-genes_6-edges_artificial-data_MM_estimation_fixP-0_graph.xlsx'];
            testCase.GRNstruct = readInputSheet(testCase.GRNstruct);
        end
    end

    methods (Test)
        function testExpressionDataStructure(testCase)
            testCase.GRNstruct = compressMissingData(testCase.GRNstruct);
            % Need to figure out how data structure will be formatted before testing structure
            % testCase.verifyTrue(isequal(testCase.GRNstruct.expressionData(1).data, ));
            % testCase.verifyTrue(isequal(testCase.GRNstruct.expressionData(2).data, ));
        end
    end
end
