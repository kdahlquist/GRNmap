classdef lseTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function test01SteadyState (testCase)
            GRNstruct.inputFile = '../data-samples/Test01SteadyState.xls';
            
            %For some reason, a .jpg file for Figure 1 counter = 100 pops up when lse is run
            GRNstruct = lse(readInputSheet(GRNstruct));
            
            testCase.assertEqual(GRNstruct.GRNParams.positions, [1, 1; 2, 2; 3, 3]);
            
            %testCase.assertEqual(GRNstruct.GRNOutput.lse_0, 
        end
            
    end
    
end