classdef readInputSheetTest < matlab.unittest.TestCase
    
    methods (Test)
        %Testing if the inputs from test01SteadyState are read correctly
        function test01SteadyState (testCase)
            GRNstruct.inputFile = '../test_files/data-samples/Test01SteadyState.xls';
            GRNstruct = readInputSheet(GRNstruct);
            
            % Tests for populating the structure
            testCase.assertEqual(GRNstruct.degRates, [0.5, 0.8, 1]);
            testCase.assertEqual(GRNstruct.GRNParams.wtmat, [0.1, 0, 0; 0, 0.1, 0; 0, 0, 0.1]);
            testCase.assertEqual(GRNstruct.GRNParams.A, [1, 0, 0; 0, 1, 0; 0, 0, 1]);
            testCase.assertEqual(GRNstruct.GRNParams.prorate, [1; 1.6; 2]);
            testCase.assertEqual(GRNstruct.GRNParams.nedges, 3);
            testCase.assertEqual(GRNstruct.GRNParams.n_active_genes, 3);
            testCase.assertEqual(GRNstruct.GRNParams.active, [1, 2, 3]);
            testCase.assertEqual(GRNstruct.GRNParams.alpha, 0.00000001);
            testCase.assertEqual(GRNstruct.GRNParams.time, [5, 10, 20]);
            testCase.assertEqual(GRNstruct.GRNParams.n_genes, 3);
            testCase.assertEqual(GRNstruct.GRNParams.n_times, 3);
            
            % Tests for setting the control parameters
            testCase.assertEqual(GRNstruct.controlParams.simtime, [0:20]);
            testCase.assertEqual(GRNstruct.controlParams.kk_max, 1);
            testCase.assertEqual(GRNstruct.controlParams.MaxIter, 1.00E+06);
            testCase.assertEqual(GRNstruct.controlParams.MaxFunEval, 1.00E+06);
            testCase.assertEqual(GRNstruct.controlParams.TolFun, 1.00E-05);
            testCase.assertEqual(GRNstruct.controlParams.TolX, 0.00001);
            testCase.assertEqual(GRNstruct.controlParams.iestimate, 1.00E+00);
            testCase.assertEqual(GRNstruct.controlParams.igraph, 1.00E+00);
            testCase.assertEqual(GRNstruct.controlParams.Sigmoid, 1);
            testCase.assertEqual(GRNstruct.controlParams.fix_b, 1);
            testCase.assertEqual(GRNstruct.controlParams.fix_P, 1);
            
            % Tests for setting global variables
            testCase.assertEqual(GRNstruct.GRNParams.b, [0; 0; 0]);
            

            
        end
        
    end
    
end