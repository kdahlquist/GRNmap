classdef globalsToLocalTest < matlab.unittest.TestCase
    
    properties
        GRNstruct = struct()
    end
   
    methods(TestClassSetup)
        function setupGRNstruct(testCase)
            global adjacency_mat alpha b counter expression_timepoints ...
            degrate lse_out penalty_out SSE wts prorate log2FC
       
            addpath([pwd '/../../matlab']);
            
            adjacency_mat = [1 0 0 0; 0 1 0 0; 0 0 1 1; 0 0 1 1];
            alpha =  0.001;
            b = [0;0;0;0];
            counter = 1012;
            expression_timepoints = [0.4 0.8 1.2 1.6];
            degrate = [1; 1; 1; 1];
            prorate = [0.5;
                       1.0;
                       2.0;
                       1.0];
            lse_out = 0.00562059511211463;
            penalty_out = 2.12482998305364;
            SSE = [0.00893765262173037	0.0178753052434607;...
                   0.00558249174067118	0.0111649834813424;...
                   0.00395421020246958	0.00395421020246958;...
                   0.275044443910378	0.506582631835732];
            wts = [1; 1;...
                   1; 1;...
                   1; 1
                  ];
            log2FC = struct('model', {[0	-0.0898003214492152	-0.177837235669622	-0.264143175465653; ...
                                       0	-0.0535544725451915	-0.105340331017462	-0.155412951361923; ...
                                       0	 0.0743459203142814	 0.138786287342172	 0.195043980758031; ...
                                       0	-0.0586045566610957	-0.116780839243491	-0.174488024612268]; ...
                                      [0	-0.0898003214492152	-0.177837235669622	-0.264143175465653; ...
                                       0	-0.0535544725451915	-0.105340331017462	-0.155412951361923; ...
                                       0	 0	                 0                   0	; ...
                                       0	-0.0458513259283481	-0.0908341460604173	-0.134976605186563]} ...
             );
            
            testCase.GRNstruct.controlParams.estimate_params = 1;
            testCase.GRNstruct.microData(1).data = [1 2 3];
            testCase.GRNstruct.microData(2).data = [1 3 5];
            testCase.GRNstruct = globalToStruct(testCase.GRNstruct);
        end
    end
    
    methods (TestClassTeardown)
        function teardownGlobals (testCase)
           clearvars -global adjacency_mat alpha b counter expression_timepoints degrate lse_out penalty_out SSE wts prorate
        end
    end
    
    methods(Test)
        function testAdjacencyMatAssignedCorrectly(testCase)
            testCase.verifyEqual(testCase.GRNstruct.GRNOutput.adjacency_mat, [1 0 0 0; 0 1 0 0; 0 0 1 1; 0 0 1 1]);
        end
        
        function testAlphaAssignedCorrectly(testCase)
            testCase.verifyEqual(testCase.GRNstruct.GRNOutput.alpha, 0.001);
        end
        
        function testBAssignedCorrectly(testCase)
            testCase.verifyEqual(testCase.GRNstruct.GRNOutput.b, [0;0;0;0]);
        end
        
        function testCounterAssignedCorrectly(testCase)
            testCase.verifyEqual(testCase.GRNstruct.GRNOutput.counter, 1012);
        end
        
%         function testDeletionAssignedCorrectly(testCase)
%             testCase.verifyEqual(testCase.GRNstruct.microData(1).deletion, 'wt');
%             testCase.verifyEqual(testCase.GRNstruct.microData(2).deletion, 'dcin5');
%         end
        
        function testExpressionTimepointsAssignedCorrectly(testCase)
            testCase.verifyEqual(testCase.GRNstruct.GRNOutput.tspan, [0.4 0.8 1.2 1.6]);
        end
        
        function testProrateAssignedCorrectly(testCase)
            testCase.verifyEqual(testCase.GRNstruct.GRNOutput.prorate, [0.5; 1.0; 2.0; 1.0]);
        end
        
        function testDegrateAssignedCorrectly(testCase)
           testCase.verifyEqual(testCase.GRNstruct.GRNOutput.degrate, [1; 1; 1; 1]);
        end
        
        function testLSEOutAssignedCorrectly(testCase)
           testCase.verifyEqual(testCase.GRNstruct.GRNOutput.lse_out, 0.00562059511211463);
        end
        
        function testPenaltyOutAssignedCorrectly(testCase)
           testCase.verifyEqual(testCase.GRNstruct.GRNOutput.reg_out, 2.12482998305364);
        end
        
        function testSSEAssignedCorrectly(testCase)
           testCase.verifyEqual(testCase.GRNstruct.GRNOutput.SSE, [0.00893765262173037	0.0178753052434607;...
                                                                   0.00558249174067118	0.0111649834813424;...
                                                                   0.00395421020246958	0.00395421020246958;...
                                                                   0.275044443910378	0.506582631835732]);
        end
        
        function testWtsAssignedCorrectly(testCase)
           testCase.verifyEqual(testCase.GRNstruct.GRNOutput.wts, [1; 1; 1; 1; 1; 1]);
        end
                
    end
end
