classdef OptimizedThresholdBTest < matlab.unittest.TestCase
    properties
        test_dir = '\..\..\output_test\'
        filename = '4-genes_6-edges_artificial-data_Sigmoid_no_controller_on_ACE_5'
        GRNstruct
        output_values
        output_texts
    end
    methods (TestClassSetup)
        function addGRNmapPath (testCase) %#ok<MANU>
            addpath([pwd '\..\..\..\matlab'])
        end

        function setup (testCase)
            % Run through a typical run of GRNmap so we can test output
            testCase.GRNstruct.directory = [pwd testCase.test_dir];
            testCase.GRNstruct.inputFile = [pwd testCase.test_dir testCase.filename '.xlsx'];
            testCase.GRNstruct = readInputSheet(testCase.GRNstruct);
            testCase.GRNstruct = initializeArrays(testCase.GRNstruct);
            testCase.GRNstruct = lse(testCase.GRNstruct);
            testCase.GRNstruct = output(testCase.GRNstruct);

            [testCase.output_values, testCase.output_texts] = xlsread([testCase.test_dir testCase.filename '_output' '.xlsx'], 'optimized_threshold_b');



        end
    end
    methods(Test)
        function testACE2ShouldBe0WithNoControllers(testCase)
            testCase.verifyEqual(testCase.output_values(1), 0);
        end
        
        function testTheRestShouldBeNonZero(testCase)
            for i = 2:size(testCase.output_values, 1)
                testCase.verifyNotEqual(testCase.output_values(i), 0);
            end
        end

        function testShouldOnlyHaveTwoColumns(testCase)
             testCase.verifyEqual(size(testCase.output_values, 2), 1);
        end
    end

end
