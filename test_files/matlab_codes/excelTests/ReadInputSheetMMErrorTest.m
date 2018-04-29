classdef ReadInputSheetMMErrorTest < matlab.unittest.TestCase
    properties
        GRNstruct
        test_dir = '\..\..\sixteen_tests\'
        mmInputFile = '4-genes_6-edges_artificial-data_MM_estimation_fixP-0_graph'
        sigmoidInputFile = '4-genes_6-edges_artificial-data_Sigmoidal_estimation_fixb-0_fixP-0_graph'
    end

    methods(TestMethodSetup)
        function clearGRNstructBeforeEachTest(testCase)
            testCase.GRNstruct = struct();
        end
    end

    methods (Test)
        function testErrorThrownWhenGivenMMSheet(testCase)
            testCase.GRNstruct.fileName = testCase.mmInputFile;
            testCase.GRNstruct.directory = testCase.test_dir;
            testCase.GRNstruct.inputFile = [testCase.GRNstruct.directory testCase.GRNstruct.fileName];
            testCase.verifyError(@()readInputSheet(testCase.GRNstruct),'readInputSheet:mmDetected');

            % Close the msgbox after test executes.
            handles = allchild(0);
            tags = get(handles,'Tag');
            isMsg = strncmp(tags,'Msgbox_',7);
            delete(handles(isMsg));
        end
        % We simply see if this test runs to completion without any problems.
        % If it runs to completion, success!
        function testNoErrorThrownWhenGivenSigmoidalSheet(testCase)
            testCase.GRNstruct.fileName = testCase.sigmoidInputFile;
            testCase.GRNstruct.directory = testCase.test_dir;
            testCase.GRNstruct.inputFile = [testCase.GRNstruct.directory testCase.GRNstruct.fileName];
        end
    end

end
