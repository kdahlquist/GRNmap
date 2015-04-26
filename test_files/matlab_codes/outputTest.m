classdef outputTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function test01SteadyState (testCase)
            %Need to ask questions about this: should I just make one whole
            %test file that checks each sample instead of for each matlab
            %file
            GRNstruct.inputFile = '../data-samples/Test01SteadyState.xls';
            GRNstruct = output(lse(readInputSheet(GRNstruct)));
        end
        
    end
    
end