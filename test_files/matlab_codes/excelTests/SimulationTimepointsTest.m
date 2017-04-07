classdef SimulationTimepointsTest < matlab.unittest.TestCase

    properties
        test_dir = [pwd '\..\..\perturbation_tests\to_be_reformatted\math_L-curve\']
        GRNstruct
    end

    methods (TestClassSetup)
        function addPath (testCase)
            testCase.GRNstruct.inputFile = [testCase.test_dir '\4-genes_6-edges_artificial-data_Sigmoidal_estimation_fixb-1_fixP-1_no-graph_test1.xlsx'];
            testCase.GRNstruct = readInputSheet(testCase.GRNstruct);
        end
    end

    methods (Test)
        function testSimulationTimepoints(testCase)
            expected_timepoints = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
            for sheet = 1:length(testCase.GRNstruct.expressionData)
                timepoints = [];
                for repetitions = 1:size(testCase.GRNstruct.expressionData(sheet).t, 2);
                    timepoints = [timepoints testCase.GRNstruct.expressionData(sheet).t(repetitions).indx];
                end
                missing_cols = setdiff(expected_timepoints, timepoints);
                testCase.verifyEqual(missing_cols, zeros(1,0));
            end
        end

        function testSimTimepointsLength(testCase)
            cols_in_sheets = [12,12];
            for sheet = 1:length(testCase.GRNstruct.expressionData)
                count = 0;
                for timepoint = 1:size(testCase.GRNstruct.expressionData(sheet).t,2)
                    count = count + length(testCase.GRNstruct.expressionData(sheet).t(timepoint).indx);
                end
                testCase.verifyEqual(count,cols_in_sheets(sheet));
            end
        end
    end
end
