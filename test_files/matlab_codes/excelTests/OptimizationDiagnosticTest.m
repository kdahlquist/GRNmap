classdef OptimizationDiagnosticTest < matlab.unittest.TestCase

    properties
        test_dir = '..\..\optimization_diagnostic_test\'
    end

    methods (Test)
        function testDiagnosticCreatedIfCounterLessThan100(testCase)
            close all
            GRNstruct.inputFile = [testCase.test_dir 'optimization_diagnostic_under_100_iterations_test'];
            GRNstruct = readInputSheet(GRNstruct);
            lse(GRNstruct);
            % We verify that the figure was indeed created.
            testCase.verifyFalse(isempty(findall(0,'Type','Figure')));
            close all
        end

    end
end
