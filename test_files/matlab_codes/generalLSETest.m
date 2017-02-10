% This is to test that one run of general_least_squares_error produces the
% correct outputs.

classdef generalLSETest < matlab.unittest.TestCase
    properties
        % [L, strain_data] = general_least_squares_error(theta)
        theta
        L
        strain_data
        
        % global variables in general_least_squares_error.m
        adjacency_mat 
        alpha 
        b 
        is_forced 
        counter 
        deletion 
        fix_b 
        fix_P 
        log2FC 
        lse_out 
        penalty_out 
        prorate 
        production_function 
        strain_length 
        expression_timepoints 
        wts
        
        % global variables in general_network_dynamics___
        degrate
        num_genes
    end
    
    methods (TestClassSetup)
        function addpath (testCase) %#ok<MANU>
            addpath([pwd '/../../matlab']);
        end
        
        function setupConstantVariables (testCase)
            % This is just to setup 1 instance of the 16 tests:
            % i.e., Sigmoidal estimation fix-b=0, fix-P=0
            
            % Need to use the data from ConstantGRNstructs to test all 16 cases later
            % Can't do it right now since gLSE does not use GRNstruct
            testCase.adjacency_mat = [1 0 0 0; 
                                      0 1 0 0; 
                                      0 0 1 1; 
                                      0 0 1 1];
            testCase.alpha = 0.001;
            testCase.b = [0; 0; 0; 0];
            testCase.is_forced = [1; 2; 3; 4];
            testCase.counter = 0;
            testCase.fix_b = 0;
            testCase.fix_P = 0;
            
            testCase.log2FC = struct (...
                 'Strain', {{'wt'};{'dcin5'}},...
                 'deletion', {0; 3}, ...
                 'model', {[];[]},...
                 't', struct ('indx', {[1 2 3]; [4 5 6]; [7 8 9]; [10 11 12]}, 't', {0.4; 0.8; 1.2; 1.6}), ...
                 'data', {[0.4	0.4	0.4	0.8	0.8	0.8	1.2	1.2	1.2	1.6	1.6	1.6;...
                                -0.376334306292052	-0.376334306292052	-0.376334306292052	-0.706666467343382	-0.706666467343382	-0.706666467343382	-0.987239299670092	-0.987239299670092	-0.987239299670092	-1.21744326547615	-1.21744326547615	-1.21744326547615;...
                                -0.227718654239836	-0.227718654239836	-0.227718654239836	-0.408017743026565	-0.408017743026565	-0.408017743026565	-0.546412653239117	-0.546412653239117	-0.546412653239117	-0.649843860182989	-0.649843860182989	-0.649843860182989;...
                                 0.269293821322375	0.269293821322375	0.269293821322375	0.415935372482249	0.415935372482249	0.415935372482249	0.497511633589691	0.497511633589691	0.497511633589691	0.541599938412416	0.541599938412416	0.541599938412416;...
                                -0.290936155220703	-0.290936155220703	-0.290936155220703	-0.579771801563864	-0.579771801563864	-0.579771801563864	-0.85583465653557	-0.85583465653557	-0.85583465653557	-1.10972623205696	-1.10972623205696	-1.10972623205696...
                              ];
                              [0.4	0.4	0.4	0.8	0.8	0.8	1.2	1.2	1.2	1.6	1.6	1.6;...
                                -0.376334306292052	-0.376334306292052	-0.376334306292052	-0.706666467343382	-0.706666467343382	-0.706666467343382	-0.987239299670092	-0.987239299670092	-0.987239299670092	-1.21744326547615	-1.21744326547615	-1.21744326547615;...
                                -0.227718654239836	-0.227718654239836	-0.227718654239836	-0.408017743026565	-0.408017743026565	-0.408017743026565	-0.546412653239117	-0.546412653239117	-0.546412653239117	-0.649843860182989	-0.649843860182989	-0.649843860182989;...
                                 0	0	0	0	0	0	0	0	0	0	0	0;...
                                -0.13932150464649	-0.13932150464649	-0.13932150464649	-0.249851730445413	-0.249851730445413	-0.249851730445413	-0.336140688374095	-0.336140688374095	-0.336140688374095	-0.402590113617106	-0.402590113617106	-0.402590113617106 ...
                              ]});
                              
            testCase.production_function = 'Sigmoid';
            testCase.strain_length = 2;
            testCase.expression_timepoints = [0.4 0.8 1.2 1.6];
            
            testCase.degrate = [1; 1; 1; 1];
            testCase.num_genes = 4;
            
            testCase.theta = [1;1;1;1;1;1;0;0;0;0;0.5;1;2;1];
        end
        
        function runGLSE (testCase)
            global adjacency_mat alpha b is_forced counter deletion ...
                fix_b fix_P log2FC production_function strain_length ...
                expression_timepoints
            
            % these are globals inside general_network_dynamics___
            global degrate num_genes
            
            adjacency_mat         = testCase.adjacency_mat;
            alpha                 = testCase.alpha;
            b                     = testCase.b;
            is_forced             = testCase.is_forced;
            counter               = testCase.counter;
            deletion              = testCase.deletion;
            fix_b                 = testCase.fix_b;
            fix_P                 = testCase.fix_P;
            log2FC                = testCase.log2FC;
            production_function   = testCase.production_function;
            strain_length         = testCase.strain_length;
            expression_timepoints = testCase.expression_timepoints;
            
            degrate               = testCase.degrate;
            num_genes             = testCase.num_genes;
            
            [testCase.L, testCase.strain_data] = general_least_squares_error(testCase.theta); 
        end
    end
    
    methods (TestClassTeardown)
        function teardown (testCase)
            clearvars -global
        end
    end
    
    methods (Test)
       
        function testLIsCorrect (testCase)
            
        end
        
        function testStrain_X1IsCorrect (testCase)
            
        end
        
        function testGlobalSSEIsCorrect (testCase)
            
        end
        
        function testGlobalProrateIsCorrect (testCase)
            global prorate
            disp(prorate)
            % if ~fix_b then b changes
        end
        
        function testGlobalPenalty_OutIsCorrect (testCase)
            global penalty_out
            disp(penalty_out)
        end
        
        function testGlobalLSE_OutIsCorrect (testCase)
            global lse_out
            disp(lse_out)
        end
        
        function testGlobalDeletionIsCorrect (testCase)
            % deletion might not need to be tested
        end
        
        function testGlobalBIsCorrect (testCase)
            % if ~fix_b then b changes
        end
    end
end