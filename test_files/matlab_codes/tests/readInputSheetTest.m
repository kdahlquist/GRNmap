classdef readInputSheetTest < matlab.unittest.TestCase
    
    properties (ClassSetupParameter)
        filename = {'4-genes_6-edges_artificial-data_MM_estimation_fixP-0_graph',...
                    '4-genes_6-edges_artificial-data_MM_estimation_fixP-0_no-graph',...
                    '4-genes_6-edges_artificial-data_MM_estimation_fixP-1_graph',...
                    '4-genes_6-edges_artificial-data_MM_estimation_fixP-1_no-graph',...
                    '4-genes_6-edges_artificial-data_MM_forward_graph',...
                    '4-genes_6-edges_artificial-data_MM_forward_no-graph',...
                    '4-genes_6-edges_artificial-data_Sigmoidal_estimation_fixb-0_fixP-0_graph',...
                    '4-genes_6-edges_artificial-data_Sigmoidal_estimation_fixb-0_fixP-0_no-graph',...
                    '4-genes_6-edges_artificial-data_Sigmoidal_estimation_fixb-0_fixP-1_graph',...
                    '4-genes_6-edges_artificial-data_Sigmoidal_estimation_fixb-0_fixP-1_no-graph',...
                    '4-genes_6-edges_artificial-data_Sigmoidal_estimation_fixb-1_fixP-0_graph',...
                    '4-genes_6-edges_artificial-data_Sigmoidal_estimation_fixb-1_fixP-0_no-graph',...
                    '4-genes_6-edges_artificial-data_Sigmoidal_estimation_fixb-1_fixP-1_graph',...
                    '4-genes_6-edges_artificial-data_Sigmoidal_estimation_fixb-1_fixP-1_no-graph',...
                    '4-genes_6-edges_artificial-data_Sigmoidal_forward_graph',...
                    '4-genes_6-edges_artificial-data_Sigmoidal_forward_no-graph'} 
    end
    
    properties 
        GRNstruct
        GRNstruct_params
        test_dir = '\..\..\sixteen_tests\'
    end
    
    methods(TestClassSetup)
        
        function setupGRNstruct(testCase, filename)
            testCase.GRNstruct.inputFile = [pwd testCase.test_dir filename];
            [~, testCase.GRNstruct.sheets] = xlsfinfo(testCase.GRNstruct.inputFile);
            fprintf('\n%s\n',testCase.GRNstruct.inputFile);
            testCase.GRNstruct = readInputSheet(testCase.GRNstruct);
            testCase.GRNstruct_params = fieldnames(testCase.GRNstruct.controlParams);
            testCase.GRNstruct_params = [testCase.GRNstruct_params; fieldnames(testCase.GRNstruct.GRNParams)];
        end
    end
    
    methods (Test)
        
%       Test to see if input worksheets have correct names
        function testReadInputs (testCase)
%           Check to see if input worksheets exist.  
            sheetNames = {'production_rates', 'degradation_rates', 'wt_log2_expression', 'dcin5_log2_expression', 'network','network_weights', 'optimization_parameters', 'threshold_b', 'wt_log2_optimized_expression', 'optimized_production_rates', 'optimized_threshold_b', 'network_optimized_weights'};
            testCase.assertTrue(any(ismember(testCase.GRNstruct.sheets, sheetNames)), testCase.GRNstruct.inputFile); 
        end
        
%       Test to see if timepoints match
        function testSimTime(testCase)
           for strain_index = 1:length(testCase.GRNstruct.microData)
                testCase.assertEqual(length(testCase.GRNstruct.GRNParams.expression_timepoints), length(testCase.GRNstruct.microData(strain_index).t),testCase.GRNstruct.inputFile);
                for timepoint = 1: length(testCase.GRNstruct.GRNParams.expression_timepoints)
                   testCase.assertEqual(testCase.GRNstruct.GRNParams.expression_timepoints(timepoint), testCase.GRNstruct.microData(strain_index).t(timepoint).t,testCase.GRNstruct.inputFile); 
                end
           end
        end
        
%       Test if number of genes is correct
        %function testNumGenes(testCase)
        %     testCase.assertEqual(testCase.GRNstruct.GRNParams.num_genes, 4);
        %end
        
        function testProductionFunctionIsSigmoidOrMichaelisMenten (testCase)
            testCase.assertTrue(strcmpi(testCase.GRNstruct.controlParams.production_function, 'MM') | strcmpi(testCase.GRNstruct.controlParams.production_function, 'Sigmoid'),testCase.GRNstruct.inputFile);
        end
        
        function testProductionFunctionNotNumeric (testCase)
           testCase.assertTrue (~isa(testCase.GRNstruct.controlParams.production_function, 'numeric'),testCase.GRNstruct.inputFile);
        end
        
        function testProductionFunctionIsInOptimizationParameters (testCase)
            testCase.assertTrue(any(ismember('production_function', testCase.GRNstruct_params)),testCase.GRNstruct.inputFile);
        end
        
        function testSimulationTimepointIsInOptimizationParameters (testCase)
            testCase.assertTrue(any(ismember('simulation_timepoints', testCase.GRNstruct_params)),testCase.GRNstruct.inputFile);
        end
        
        function testExpressionTimepointIsInOptimizationParameters (testCase)
            testCase.assertTrue(any(ismember(testCase.GRNstruct_params, 'expression_timepoints')),testCase.GRNstruct.inputFile);
        end
        
        function testMakeGraphsIsInOptimizationParameters (testCase)
            testCase.verifyTrue(any(ismember(testCase.GRNstruct_params,'make_graphs')),testCase.GRNstruct.inputFile);
        end
        
        function testEstimateParamsIsInOptimizationParameters (testCase)
            testCase.assertTrue(any(ismember(testCase.GRNstruct_params, 'estimate_params')),testCase.GRNstruct.inputFile);            
        end
        
        function testLCurve (testCase)
            testCase.assertTrue(any(ismember(testCase.GRNstruct_params, 'L_curve')),testCase.GRNstruct.inputFile);
        end
        
        function testLCurveValueIsValid (testCase)
           testCase.assertTrue(ismember(testCase.GRNstruct.controlParams.L_curve, [0,1]),testCase.GRNstruct.inputFile);
        end
        
        function testDeletionDoesNotExist(testCase)
           testCase.assertTrue(~any(ismember(testCase.GRNstruct_params, 'Deletion')),testCase.GRNstruct.inputFile); 
        end
        
    end
    
end