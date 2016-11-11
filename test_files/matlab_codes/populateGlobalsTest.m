classdef populateGlobalsTest < matlab.unittest.TestCase
    
    properties (ClassSetupParameter)
        test_files = {
                      struct('GRNstruct','MM_estimation_fixP0_graph','file','4-genes_6-edges_artificial-data_MM_estimation_fixP-0_graph');...
                      struct('GRNstruct','MM_estimation_fixP0_nograph','file','4-genes_6-edges_artificial-data_MM_estimation_fixP-0_no-graph');...
                      struct('GRNstruct','MM_forward_graph','file','4-genes_6-edges_artificial-data_MM_forward_graph');...
                      struct('GRNstruct','MM_forward_nograph','file','4-genes_6-edges_artificial-data_MM_forward_no-graph');...
                      struct('GRNstruct','MM_estimation_fixP1_graph','file','4-genes_6-edges_artificial-data_MM_estimation_fixP-1_graph');...
                      struct('GRNstruct','MM_estimation_fixP1_nograph','file','4-genes_6-edges_artificial-data_MM_estimation_fixP-1_no-graph');...
                      struct('GRNstruct','Sigmoidal_estimation_fixb0_fixP0_graph','file','4-genes_6-edges_artificial-data_Sigmoidal_estimation_fixb-0_fixP-0_graph');...
                      struct('GRNstruct','Sigmoidal_estimation_fixb0_fixP0_nograph','file','4-genes_6-edges_artificial-data_Sigmoidal_estimation_fixb-0_fixP-0_no-graph');...                      
                      struct('GRNstruct','Sigmoidal_estimation_fixb0_fixP1_graph','file','4-genes_6-edges_artificial-data_Sigmoidal_estimation_fixb-0_fixP-1_graph');...
                      struct('GRNstruct','Sigmoidal_estimation_fixb0_fixP1_nograph','file','4-genes_6-edges_artificial-data_Sigmoidal_estimation_fixb-0_fixP-1_no-graph');...
                      struct('GRNstruct','Sigmoidal_estimation_fixb1_fixP0_graph','file','4-genes_6-edges_artificial-data_Sigmoidal_estimation_fixb-1_fixP-0_graph');...
                      struct('GRNstruct','Sigmoidal_estimation_fixb1_fixP0_nograph','file','4-genes_6-edges_artificial-data_Sigmoidal_estimation_fixb-1_fixP-0_no-graph');...
                      struct('GRNstruct','Sigmoidal_estimation_fixb1_fixP1_graph','file','4-genes_6-edges_artificial-data_Sigmoidal_estimation_fixb-1_fixP-1_graph');...
                      struct('GRNstruct','Sigmoidal_estimation_fixb1_fixP1_nograph','file','4-genes_6-edges_artificial-data_Sigmoidal_estimation_fixb-1_fixP-1_no-graph');...
                      struct('GRNstruct','Sigmoidal_forward_graph','file','4-genes_6-edges_artificial-data_Sigmoidal_forward_graph');...
                      struct('GRNstruct','Sigmoidal_forward_nograph','file','4-genes_6-edges_artificial-data_Sigmoidal_forward_no-graph');...
                     };...
    end

    properties
        GRNstruct
        adjacency_mat
        b
        deletion
        degrate
        expression_timepoints
        fix_b
        fix_P
        num_genes
        prorate
        wts
        alpha
        is_forced
        production_function
        strain_length
    end
    
    methods(TestClassSetup)
        function makeGlobals(testCase, test_files)
            global alpha adjacency_mat b degrate expression_timepoints ... 
                fix_b fix_P num_genes prorate wts deletion is_forced ...
                production_function strain_length
            addpath([pwd '/../../matlab']);
            addpath('tests/')
            testCase.GRNstruct = getfield(ConstantGRNstructs, test_files.GRNstruct);
            populateGlobals(testCase.GRNstruct);
            testCase.adjacency_mat = adjacency_mat;
            testCase.b = b;
            testCase.degrate = degrate;
            testCase.deletion = deletion;
            testCase.expression_timepoints = expression_timepoints;
            testCase.fix_b = fix_b;
            testCase.fix_P = fix_P;
            testCase.num_genes = num_genes;
            testCase.prorate = prorate;
            testCase.wts = wts;
            testCase.alpha = alpha;
            testCase.is_forced = is_forced;
            testCase.production_function = production_function;
            testCase.strain_length = strain_length;
         end
    end
    
    methods(TestClassTeardown)
        function clearGlobals(testCase)
           clearvars -global
        end
    end
    
    methods(Test)
        function testAdjacencyMat(testCase)
            testCase.verifyEqual(testCase.adjacency_mat, [1 0 0 0; 0 1 0 0; 0 0 1 1; 0 0 1 1]);
        end
        %b depends on input%
        function testB(testCase)
            if strcmpi(testCase.GRNstruct.controlParams.production_function, 'Sigmoid') 
                if testCase.GRNstruct.controlParams.fix_b
                    testCase.verifyEqual(testCase.b, [0;0;0;0]);
                else
                    testCase.verifyEqual(testCase.b, [1;1;1;1]);
                end
            else
                testCase.verifyEqual(testCase.b, [0;0;0;0]);
            end
            
        end
        
        function testDegrate(testCase)
            testCase.verifyEqual(testCase.degrate, [1; 1; 1; 1]);
        end
        
        %depends on input%
        function testFixB(testCase)
   
            if testCase.GRNstruct.controlParams.fix_b
                testCase.verifyEqual(testCase.fix_b, 1);
            else
                testCase.verifyEqual(testCase.fix_b, 0);
            end
        end
        
        function testFixP(testCase)
            if testCase.GRNstruct.controlParams.fix_P
                testCase.verifyEqual(testCase.fix_P, 1);
            else
                testCase.verifyEqual(testCase.fix_P, 0);
            end
        end
        
        function testNumGenes(testCase)
            testCase.verifyEqual(testCase.num_genes, 4);
        end
        

        function testProRate(testCase)
            testCase.verifyEqual(testCase.prorate, [0.5;
                             1.0;
                             2.0;
                             1.0]);
        end         
        function testAlpha(testCase)
            testCase.verifyEqual(testCase.alpha, 0.001);
        end
        
        function testExpressionTimepoints(testCase)
            testCase.verifyEqual(testCase.expression_timepoints,  [0.4000 0.8000 1.2000 1.6000]);
        end
        
        function testIsForced(testCase)
            testCase.verifyEqual(testCase.is_forced,  [1; 2; 3; 4]);
        end
        
        function testProductionFunction(testCase)
            if strcmpi(testCase.GRNstruct.controlParams.production_function, 'Sigmoid')
                testCase.verifyEqual(testCase.production_function, 'Sigmoid');
            else
                testCase.verifyEqual(testCase.production_function, 'MM');
            end
            
        end
        
        function testStrainLength(testCase)
           testCase.verifyEqual(testCase.strain_length, 2); 
        end
        
    end           
end
