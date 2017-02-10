classdef ForwardSimulationTest < matlab.unittest.TestCase
    
    methods (TestClassSetup)
        function addpath(testCase)
           addpath('../../matlab')
           addpath('../utils')
        end
    end
    
    methods(Test)

        function testFourByFourInputsHaveTheCorrectSolutions(testCase)
            global deletion
% We are using the file
% 4-genes_6-edges_artificial-data_Sigmoidal_forward_graph

            GRNstruct = struct();
            GRNstruct.GRNParams.prorate = [0.5 1 2 1]';
            GRNstruct.degRates = [1 1 1 1]';
            GRNstruct.GRNParams.b = [0 0 0 0]';
            GRNstruct.GRNParams.adjacency_mat = [
                1 0 0 0
                0 1 0 0
                0 0 1 1
                0 0 1 1
            ];                                    
            GRNstruct.GRNParams.wtmat = [
                1 0 0 0
                0 1 0 0
                0 0 1 1
                0 0 1 1
            ];       
            GRNstruct.controlParams.production_function = 'Sigmoid';
            GRNstruct.controlParams.simulation_timepoints = 0:0.1:0.5;
            GRNstruct.GRNParams.x0 = ones(4,1);
            GRNstruct.microData(1).deletion = 0;
            GRNstruct.microData(2).deletion = 3;
            GRNstruct.GRNParams.is_forced = ones(4,1);

            deletion = 0;
            
            resultGRNstruct = runForwardSimulation(GRNstruct);
            
            expected_wt_expression = [ 
                0 -0.090301262 -0.178094353 -0.263319186 -0.345920382 -0.425846555
                0 -0.03777407  -0.073540345 -0.107366367 -0.139321505 -0.16947611
                0  0.101788348  0.189529115  0.265789663  0.332522487  0.39124623
                0 -0.016001145 -0.029792749 -0.041630801 -0.051748249 -0.06035476
            ];
            expected_dcin5_expression = [
                0 -0.090301262 -0.178094353	-0.263319186 -0.345920382 -0.425846555
                0 -0.03777407  -0.073540345	-0.107366367 -0.139321505 -0.16947611
                0  0	        0	         0	          0	           0
                0 -0.03777407  -0.073540345	-0.107366367 -0.139321505 -0.16947611
            ];
        
            testCase.assertTrue(matricesWithinAbsoluteRange(expected_wt_expression, resultGRNstruct.GRNModel(1).model, 0.01));
            testCase.assertTrue(matricesWithinAbsoluteRange(expected_dcin5_expression, resultGRNstruct.GRNModel(2).model, 0.01));
            
        end
                
    end

end