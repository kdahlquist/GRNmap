classdef LocalizedVariablesReadInputSheetTest < matlab.unittest.TestCase

    
    properties
        test_dir = '..\..\sixteen_tests\'
        GRNstruct
    end
    
    methods (TestClassSetup)
        function testLocalizedVariablesReadInputSheet(testCase)
            testCase.GRNstruct.inputFile = [testCase.test_dir '4-genes_6-edges_artificial-data_Sigmoidal_estimation_fixb-0_fixP-0_graph.xlsx'];
            testCase.GRNstruct = readInputSheet(testCase.GRNstruct);             
        end
    end
    
%these values need to be localized and tested
%log2FC Strain expression_timepoints

    methods(Test)
        function testAdjacencyMat(testCase)
            testCase.verifyEqual(testCase.GRNstruct.GRNParams.adjacency_mat, [1 0 0 0; 0 1 0 0; 0 0 1 1; 0 0 1 1]);
        end    
        
        function testAlpha(testCase)
            testCase.verifyEqual(testCase.GRNstruct.GRNParams.alpha, 0.001);
        end 
        
        function testExpressionTimepoints(testCase)
            testCase.verifyEqual(testCase.GRNstruct.GRNParams.expression_timepoints, [0.4000 0.8000 1.2000 1.6000]);
        end  
        
        function testB(testCase)
            testCase.verifyEqual(testCase.GRNstruct.GRNParams.b, [0;0;0;0]);
        end  
        
        function testDegRates(testCase)
            testCase.verifyEqual(testCase.GRNstruct.degRates, [1 1 1 1]);
        end  
        function testFixB(testCase)
            testCase.verifyEqual(testCase.GRNstruct.controlParams.fix_b, 0);
        end    
        
        function testFixP(testCase)
            testCase.verifyEqual(testCase.GRNstruct.controlParams.fix_P, 0);
        end  
        
        function testIsForced(testCase)
            testCase.verifyEqual(testCase.GRNstruct.GRNParams.is_forced, [1; 2; 3; 4]);
        end  
        
%        function testMicroData(testCase)
%             testStructMicroData = struct(...
%                  'Strain', {{'wt'}, {'dcin5'}},...
%                  'data', {[0.4	0.4	0.4	0.8	0.8	0.8	1.2	1.2	1.2	1.6	1.6	1.6;...
%                                 -0.376334306292052	-0.376334306292052	-0.376334306292052	-0.706666467343382	-0.706666467343382	-0.706666467343382	-0.987239299670092	-0.987239299670092	-0.987239299670092	-1.21744326547615	-1.21744326547615	-1.21744326547615;...
%                                 -0.227718654239836	-0.227718654239836	-0.227718654239836	-0.408017743026565	-0.408017743026565	-0.408017743026565	-0.546412653239117	-0.546412653239117	-0.546412653239117	-0.649843860182989	-0.649843860182989	-0.649843860182989;...
%                                  0.269293821322375	0.269293821322375	0.269293821322375	0.415935372482249	0.415935372482249	0.415935372482249	0.497511633589691	0.497511633589691	0.497511633589691	0.541599938412416	0.541599938412416	0.541599938412416;...
%                                 -0.290936155220703	-0.290936155220703	-0.290936155220703	-0.579771801563864	-0.579771801563864	-0.579771801563864	-0.85583465653557	-0.85583465653557	-0.85583465653557	-1.10972623205696	-1.10972623205696	-1.10972623205696...
%                               ],
%                               [0.4	0.4	0.4	0.8	0.8	0.8	1.2	1.2	1.2	1.6	1.6	1.6;...
%                                 -0.376334306292052	-0.376334306292052	-0.376334306292052	-0.706666467343382	-0.706666467343382	-0.706666467343382	-0.987239299670092	-0.987239299670092	-0.987239299670092	-1.21744326547615	-1.21744326547615	-1.21744326547615;...
%                                 -0.227718654239836	-0.227718654239836	-0.227718654239836	-0.408017743026565	-0.408017743026565	-0.408017743026565	-0.546412653239117	-0.546412653239117	-0.546412653239117	-0.649843860182989	-0.649843860182989	-0.649843860182989;...
%                                  0	0	0	0	0	0	0	0	0	0	0	0;...
%                                 -0.13932150464649	-0.13932150464649	-0.13932150464649	-0.249851730445413	-0.249851730445413	-0.249851730445413	-0.336140688374095	-0.336140688374095	-0.336140688374095	-0.402590113617106	-0.402590113617106	-0.402590113617106 ...
%                               ]},...
%                  'stdev', {[6.79869977755259E-17	1.35973995551052E-16	0	0
%                             3.3993498887763E-17	0	0	0
%                             0	0	0	0
%                             0	0	0	0],...
%                             [6.79869977755259E-17	1.35973995551052E-16	0	0
%                              3.3993498887763E-17	0	0	0
%                              0	0	0	0
%                              0	0	0	0]}...
%              );
%         
%            testCase.verifyEqual(testCase.GRNstruct.microData, testStructMicroData);
%       end  
        
        function testnumGenes(testCase)
            testCase.verifyEqual(testCase.GRNstruct.GRNParams.num_genes, 4);
        end  
        
         function testProrate(testCase)
            testCase.verifyEqual(testCase.GRNstruct.GRNParams.prorate, [0.5; 1.0; 2.0; 1.0]);
         end  
         
        function testProductionFunction(testCase)
            testCase.verifyEqual(testCase.GRNstruct.controlParams.production_function, {'Sigmoid'});
        end  
        
    %    function testStrain(testCase)
     %       testCase.verifyEqual(testCase.GRNstruct.microData.Strain,  {{'wt'};{'dcin5'}});
      %  end  
        

    end
end
