classdef CompressMissingDataTest < matlab.unittest.TestCase
    
    properties
        GRNstruct
    end

    methods (TestClassTeardown)
        function closeErrorDialogBoxes(testCase)
            close(findall(0, 'Type', 'figure', 'Name', 'Missing Data'));
        end
        
        function closeWarningDialogBoxes(testCase)
            close(findall(0, 'Type', 'figure', 'Name', 'Single Replicate Data'));
        end
    end

    methods (Test)
        function testExpressionDataStructureWithoutMissingData(testCase)
            testCase.GRNstruct = CompressMissingDataStruct.GRNstruct_with_no_NaN;
            expected = CompressMissingDataStruct.expected_output_for_GRNstruct_with_no_NaN;
            actual = compressMissingData(testCase.GRNstruct);
            testCase.verifyEqual(actual.expressionData(1).data, expected.expressionData(1).data);
            testCase.verifyEqual(actual.expressionData(2).data, expected.expressionData(2).data);
        end
        
        function testGRNstructWithOneNaN(testCase)
            testCase.GRNstruct = CompressMissingDataStruct.GRNstruct_with_one_NaN;
            expected = CompressMissingDataStruct.expected_output_for_GRNstruct_with_one_NaN;
            actual = compressMissingData(testCase.GRNstruct);
            testCase.verifyEqual(actual.expressionData(1).data, expected.expressionData(1).data);
            testCase.verifyEqual(actual.expressionData(2).data, expected.expressionData(2).data);
        end
        
        function testGRNstructWithMultipleNaN(testCase)
            testCase.GRNstruct = CompressMissingDataStruct.GRNstruct_with_multiple_NaN;
            expected = CompressMissingDataStruct.expected_output_for_GRNstruct_with_multiple_NaN;
            actual = compressMissingData(testCase.GRNstruct);
            testCase.verifyEqual(actual.expressionData(1).data, expected.expressionData(1).data);
            testCase.verifyEqual(actual.expressionData(2).data, expected.expressionData(2).data);
        end
                
        function testExpressionDataStructureWithInconsistentTimepointData(testCase)
            testCase.GRNstruct = CompressMissingDataStruct.GRNstruct_with_inconsistent_timepoint;
            expected = CompressMissingDataStruct.expected_output_for_GRNstruct_with_inconsistent_timepoint;
            actual = compressMissingData(testCase.GRNstruct);
            testCase.verifyEqual(actual.expressionData(1).data, expected.expressionData(1).data);
            testCase.verifyEqual(actual.expressionData(2).data, expected.expressionData(2).data);
        end
        
        function testExpressionDataStructureWithTooMuchMissingData(testCase)
            testCase.GRNstruct = CompressMissingDataStruct.GRNstruct_with_too_much_missing_data;
            testCase.verifyError(@()compressMissingData(testCase.GRNstruct), 'convertToNestedStructure:MissingData');
        end
    end
end
