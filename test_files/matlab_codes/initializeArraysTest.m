classdef initializeArraysTest < matlab.unittest.TestCase
   
    properties
        test_dir = '..\initialize_arrays_test\'
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
        function testAverageSize(testCase)
            testCase.GRNstruct = initializeArrays(testCase.GRNstruct);            
            testCase.verifyTrue(isequal(testCase.GRNstruct.microData(1).avg, [0 0 0 0; 0 0 0 0; 0 0 0 0; 0 0 0 0]));
            testCase.verifyTrue(isequal(testCase.GRNstruct.microData(2).avg, [0 0 0 0; 0 0 0 0; 0 0 0 0; 0 0 0 0]));
        end
        
        function testStandardDevSize(testCase)
            testCase.GRNstruct = initializeArrays(testCase.GRNstruct);            
            testCase.verifyTrue(isequal(testCase.GRNstruct.microData(1).stdev, [0 0 0 0; 0 0 0 0; 0 0 0 0; 0 0 0 0]));
            testCase.verifyTrue(isequal(testCase.GRNstruct.microData(2).stdev, [0 0 0 0; 0 0 0 0; 0 0 0 0; 0 0 0 0]));
        end
        
        function testInitialAndEstimatedGuessesSize(testCase)
            testCase.GRNstruct = initializeArrays(testCase.GRNstruct);            
            testCase.verifyTrue(isequal(testCase.GRNstruct.locals.initial_guesses, [0; 0; 0; 0; 0; 0; 0; 0; 0; 0]));
            testCase.verifyTrue(isequal(testCase.GRNstruct.locals.estimated_guesses, [0; 0; 0; 0; 0; 0; 0; 0; 0; 0]));
        end
        
        function testSSESize(testCase)
            testCase.GRNstruct = initializeArrays(testCase.GRNstruct);            
            testCase.verifyTrue(isequal(testCase.GRNstruct.GRNOutput.SSE, [0 0; 0 0; 0 0; 0 0]));
        end
        
    end
end