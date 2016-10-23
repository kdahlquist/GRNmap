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
        test_dir = '..\populate_globals_test\'
        GRNstruct
        adjacency_mat
        b
        deletion
        degrate
        fix_b
        num_genes
        prorate
        wts
    end
    
    methods(TestClassSetup)
        function makeGlobals(testCase, test_files)
            global adjacency_mat b degrate fix_b num_genes prorate wts deletion
            addpath([pwd '/../../matlab']);
            addpath('tests/')
            testCase.GRNstruct = getfield(ConstantGRNstructs, test_files.GRNstruct);
            populateGlobals(testCase.GRNstruct);
            testCase.adjacency_mat = adjacency_mat;
            testCase.b = b;
            testCase.degrate = degrate;
            testCase.deletion = deletion;
            testCase.fix_b = fix_b;
            testCase.num_genes = num_genes;
            testCase.prorate = prorate;
            testCase.wts = wts;
         end
    end
    
    methods(Test)
        function testAdjacencyMat(testCase)
            testCase.verifyEqual(testCase.adjacency_mat, [1 0 0 0; 0 1 0 0; 0 0 1 1; 0 0 1 1]);
        end

        function testB(testCase)
            testCase.verifyEqual(testCase.b, [0;0;0;0]);
        end
        
        function testDegrate(testCase)
            testCase.verifyEqual(testCase.degrate, [1; 1; 1; 1]);
        end
        %might depend on input%
        function testFixB(testCase)
            testCase.verifyEqual(testCase.fix_b, 0);
        end
        
        function testNumGenes(testCase)
            testCase.verifyEqual(testCase.num_genes, 4);
        end
        
        %prorates depend on input%
        function testProRate(testCase)
            testCase.verifyEqual(testCase.prorate, [0.697407193664997;
                             1.15680032250197; 
                             2.7591362546192;
                             2.37852370311734]);
        end    
    end           
end
