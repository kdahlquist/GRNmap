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
%         function testAverageSize(testCase)
%             testCase.GRNstruct = initializeArrays(testCase.GRNstruct);            
%             testCase.verifyTrue(isequal(testCase.GRNstruct.microData(1).avg, [0 0 0 0; 0 0 0 0; 0 0 0 0; 0 0 0 0]));
%             testCase.verifyTrue(isequal(testCase.GRNstruct.microData(2).avg, [0 0 0 0; 0 0 0 0; 0 0 0 0; 0 0 0 0]));
%         end
%         
%         function testStandardDevSize(testCase)
%             testCase.GRNstruct = initializeArrays(testCase.GRNstruct);            
%             testCase.verifyTrue(isequal(testCase.GRNstruct.microData(1).stdev, [0 0 0 0; 0 0 0 0; 0 0 0 0; 0 0 0 0]));
%             testCase.verifyTrue(isequal(testCase.GRNstruct.microData(2).stdev, [0 0 0 0; 0 0 0 0; 0 0 0 0; 0 0 0 0]));
%         end
        
        function testInitialAndEstimatedGuessesSize(testCase)
            testCase.GRNstruct = initializeArrays(testCase.GRNstruct);            
            testCase.verifyTrue(isequal(testCase.GRNstruct.locals.initial_guesses, [0; 0; 0; 0; 0; 0; 0; 0; 0; 0]));
            testCase.verifyTrue(isequal(testCase.GRNstruct.locals.estimated_guesses, [0; 0; 0; 0; 0; 0; 0; 0; 0; 0]));
        end

        function testGRNOutputSSESize(testCase)
            testCase.GRNstruct = initializeArrays(testCase.GRNstruct);            
            testCase.verifyTrue(isequal(testCase.GRNstruct.GRNOutput.SSE, [0 0; 0 0; 0 0; 0 0]));
        end
        
        function testGRNOutputDSize(testCase)
            testCase.GRNstruct = initializeArrays(testCase.GRNstruct);            
            testCase.verifyTrue(isequal(testCase.GRNstruct.GRNOutput.d, [0 0 0 0 0 0 0 0 0 0 0 0; ...
                                                                         0 0 0 0 0 0 0 0 0 0 0 0; ...
                                                                         0 0 0 0 0 0 0 0 0 0 0 0; ...
                                                                         0 0 0 0 0 0 0 0 0 0 0 0]));          
        end
        
        function testGRNOutputProrateSize(testCase)
            testCase.GRNstruct = initializeArrays(testCase.GRNstruct);            
            testCase.verifyTrue(isequal(testCase.GRNstruct.GRNOutput.prorate, [0; 0; 0; 0]));
        end
        
        function testGRNOutputDegrateSize(testCase)
            testCase.GRNstruct = initializeArrays(testCase.GRNstruct);            
            testCase.verifyTrue(isequal(testCase.GRNstruct.GRNOutput.degrate, [0; 0; 0; 0]));
        end
        
        function testGRNOutputWtsSize(testCase)
            testCase.GRNstruct = initializeArrays(testCase.GRNstruct);            
            testCase.verifyTrue(isequal(testCase.GRNstruct.GRNOutput.wts, [0; 0; 0; 0; 0 ;0]));
        end
        
        function testGRNOutputBSize(testCase)
            testCase.GRNstruct = initializeArrays(testCase.GRNstruct);            
            testCase.verifyTrue(isequal(testCase.GRNstruct.GRNOutput.b, [0; 0; 0; 0]));
        end
        
        function testGRNOutputAdjacencyMatSize(testCase)
            testCase.GRNstruct = initializeArrays(testCase.GRNstruct);            
            testCase.verifyTrue(isequal(testCase.GRNstruct.GRNOutput.adjacency_mat, [0 0 0 0; 0 0 0 0; 0 0 0 0; 0 0 0 0]));
        end
        
        function testGRNOutputActiveSize(testCase)
            testCase.GRNstruct = initializeArrays(testCase.GRNstruct);            
            testCase.verifyTrue(isequal(testCase.GRNstruct.GRNOutput.active, [0 0 0 0]));
        end
        
        function testGRNOutputTspanSize(testCase)
            testCase.GRNstruct = initializeArrays(testCase.GRNstruct);            
            testCase.verifyTrue(isequal(testCase.GRNstruct.GRNOutput.tspan, [0 0 0 0]));
        end
        
        function testGRNModelModelSize(testCase)
            testCase.GRNstruct = initializeArrays(testCase.GRNstruct);    
            testCase.verifyTrue(isequal(testCase.GRNstruct.GRNModel(1).model, [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ...
                                                                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ...
                                                                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ...
                                                                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]));
            testCase.verifyTrue(isequal(testCase.GRNstruct.GRNModel(2).model, [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ...
                                                                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ...
                                                                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ...
                                                                            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]));
        end
        
        function testGRNModelSimulationTimepointsSize(testCase)
            testCase.GRNstruct = initializeArrays(testCase.GRNstruct);    
            testCase.verifyTrue(isequal(testCase.GRNstruct.GRNModel(1).simulation_timepoints, [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0]));
            testCase.verifyTrue(isequal(testCase.GRNstruct.GRNModel(2).simulation_timepoints, [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0]));
        end
        
    end
end