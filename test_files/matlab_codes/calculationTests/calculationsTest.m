classdef calculationsTest < matlab.unittest.TestCase
    properties
        GRNstruct
        minLSECalculation

    end

    methods (TestClassSetup)
        function addGRNmapPath (testCase) %#ok<MANU>
            addpath([pwd '\..\..\..\matlab'])
            addpath([pwd '\..\testStructs'])
        end
    end

    methods (Test)
        function testWithNoMissingData (testCase)
            constantStruct = ConstantGRNstructs.MM_estimation_fixP0_graph;
            testCase.GRNstruct =

            testCase.GRNstruct = compressMissingData(testStruct);
            expectedMinLSE = constantStruct.GRNParams.minLSE;
            expectedStdev = constantStruct.expressionData.stdev;
            expectedAvg = constantStruct.expressionData.avg;

            actualMinLSE = testStruct.GRNParams.minLSE;
            actualStdev = testStruct.expressionData.stdev;
            actualAvg = testStruct.expressionData.avg;

            testCase.verifyEqual(actualMinLSE, expectedMinLSE);
            testCase.verifyEqual(actualStdev, expectedStdev);
            testCase.verifyEqual(actualAvg, expectedAvg);

        end

        function testWithOneMissingDataPoint (testCase)
            constantStruct = ConstantGRNstructs.MM_estimation_fixP0_graph;
            testCase.GRNstruct =

            testCase.GRNstruct = compressMissingData(testStruct);
            expectedMinLSE = constantStruct.GRNParams.minLSE;
            expectedStdev = constantStruct.expressionData.stdev;
            expectedAvg = constantStruct.expressionData.avg;

            actualMinLSE = testStruct.GRNParams.minLSE;
            actualStdev = testStruct.expressionData.stdev;
            actualAvg = testStruct.expressionData.avg;

            testCase.verifyEqual(actualMinLSE, expectedMinLSE);
            testCase.verifyEqual(actualStdev, expectedStdev);
            testCase.verifyEqual(actualAvg, expectedAvg);

        end

        function testWithMultipleMissingDataPoints (testCase)
            constantStruct = ConstantGRNstructs.MM_estimation_fixP0_graph;
            testCase.GRNstruct = 

            testCase.GRNstruct = compressMissingData(testStruct);
            expectedMinLSE = constantStruct.GRNParams.minLSE;
            expectedStdev = constantStruct.expressionData.stdev;
            expectedAvg = constantStruct.expressionData.avg;

            actualMinLSE = testStruct.GRNParams.minLSE;
            actualStdev = testStruct.expressionData.stdev;
            actualAvg = testStruct.expressionData.avg;

            testCase.verifyEqual(actualMinLSE, expectedMinLSE);
            testCase.verifyEqual(actualStdev, expectedStdev);
            testCase.verifyEqual(actualAvg, expectedAvg);

        end
    end
end
