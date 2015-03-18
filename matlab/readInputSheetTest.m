classdef readInputSheetTest < matlab.unittest.TestCase
    
    methods (Test)
        function test01SteadyState (testCase)
            GRNstruct.inputFile = '../test_files/data-samples/Test01SteadyState.xls';
            GRNstruct = readInputSheet(GRNstruct);
            
            testCase.assertEqual(GRNstruct.degRates, [0.5, 0.8, 1])
        end
    end
    
end