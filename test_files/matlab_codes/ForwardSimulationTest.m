classdef ForwardSimulationTest < matlab.unittest.TestCase
    
    methods (TestClassSetup)
        function addpath(testCase)
           addpath('../../matlab') 
        end
    end
    
    methods(Test)

        function testFourByFourInputsHaveTheCorrectSolutions(testCase)
            global adjacency_mat b degrate deletion fix_b is_forced num_genes prorate wts 

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

            adjacency_mat = GRNstruct.GRNParams.adjacency_mat;
            b = GRNstruct.GRNParams.b;
            degrate = GRNstruct.degRates;
            fix_b = 1;
            is_forced = GRNstruct.GRNParams.is_forced;
            num_genes = 4;
            prorate = GRNstruct.GRNParams.prorate;
            wts = GRNstruct.GRNParams.wtmat;
            
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
                0  0	        0	         0	          0  	       0
                0 -0.03777407  -0.073540345	-0.107366367 -0.139321505 -0.16947611
            ];
            disp(resultGRNstruct.GRNModel(1).model)
            disp(resultGRNstruct.GRNModel(2).model)
            testCase.assertTrue(matricesWithinAbsoluteRange(expected_wt_expression, resultGRNstruct.GRNModel(1).model, 0.01));
            testCase.assertTrue(matricesWithinAbsoluteRange(expected_dcin5_expression, resultGRNstruct.GRNModel(2).model, 0.01));
            
        end
        
    end

end