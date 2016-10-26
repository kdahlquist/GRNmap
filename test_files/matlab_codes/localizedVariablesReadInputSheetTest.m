classdef localizedVariablesReadInputSheetTest < matlab.unittest.TestCase

    properties(ClassSetupParameter)
        test_files = {
            struct('GRNstruct','MM_estimation_fixP0_graph','file','4-genes_6-edges_artificial-data_MM_estimation_fixP-0_graph');...
        };...
    end
    
    properties
        test_dir = '..\localized_variables_read_input_sheet\'
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
    
    methods (TestClassSetup)
        function testLocalizedVariablesReadInputSheet(testCase, test_files)
            addpath([pwd '/../../matlab']);
            addpath('tests/')
            testCase.GRNstruct = getfield(ConstantGRNstructs, test_files.GRNstruct);
            testCase.GRNstruct = readInputSheet(testCase.GRNstruct);             
        end
    end
    
%these values need to be localized and tested
%alpha b degrate fix_b fix_P log2FC num_genes prorate production_function Strain expression_timepoints

    methods(Test)
        function testAdjacencyMat(testCase)
            testCase.verifyEqual(testCase.GRNstruct.GRNParams.adjacency_mat, [1 0 0 0; 0 1 0 0; 0 0 1 1; 0 0 1 1]);
        end        
    end
end
