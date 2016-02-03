classdef readInputSheetTest < matlab.unittest.TestCase
    
    properties 
        GRNstruct
        GRNstruct_params
    end
    
    methods(TestClassSetup)
        
        function readInputSheet(testCase)
            global GRNstruct
            
            GRNstruct.test_file = GRNstruct.inputFile;
            [~, GRNstruct.sheets] = xlsfinfo(GRNstruct.test_file);
            disp(GRNstruct.inputFile)
            GRNstruct = readInputSheet(GRNstruct);
            testCase.GRNstruct = GRNstruct;
            testCase.GRNstruct_params = fieldnames(GRNstruct.controlParams);
            testCase.GRNstruct_params = [testCase.GRNstruct_params; fieldnames(GRNstruct.GRNParams)];
        end
    end
    
    methods(TestClassTeardown)
        
    end
    
    methods (Test)
        
%       Test to see if input worksheets have correct names
        function testReadInputs (testCase)
%           Check to see if input worksheets exist.  
            sheetNames = {'production_rates', 'degradation_rates', 'wt_log2_expression', 'dcin5_log2_expression', 'network','network_weights', 'optimization_parameters', 'threshold_b', 'wt_log2_optimized_expression', 'optimized_production_rates', 'optimized_threshold_b', 'network_optimized_weights'};
            testCase.assertTrue(any(ismember(testCase.GRNstruct.sheets, sheetNames))); 
        end
        
%       Test to see if timepoints match
        function testSimTime(testCase)
           for strain_index = 1:length(testCase.GRNstruct.microData)
                testCase.assertEqual(length(testCase.GRNstruct.GRNParams.expression_timepoints), length(testCase.GRNstruct.microData(strain_index).t));
                for timepoint = 1: length(testCase.GRNstruct.GRNParams.expression_timepoints)
                   testCase.assertEqual(testCase.GRNstruct.GRNParams.expression_timepoints(timepoint), testCase.GRNstruct.microData(strain_index).t(timepoint).t); 
                end
           end
        end
        
%       Test if number of genes is correct
        function testNumGenes(testCase)
             testCase.assertEqual(testCase.GRNstruct.GRNParams.num_genes, 4);
        end
        
        function testProductionFunctionIsSigmoidOrMichaelisMenten (testCase)
            testCase.assertTrue(strcmpi(testCase.GRNstruct.controlParams.production_function, 'MM') | strcmpi(testCase.GRNstruct.controlParams.production_function, 'Sigmoid'));
        end
        
        function testProductionFunctionNotNumeric (testCase)
           testCase.assertTrue (~isa(testCase.GRNstruct.controlParams.production_function, 'numeric'));
        end
        
        function testProductionFunctionIsInOptimizationParameters (testCase)
            testCase.assertTrue(any(ismember('production_function', testCase.GRNstruct_params)));
        end
        
        function testSimulationTimepointIsInOptimizationParameters (testCase)
            testCase.assertTrue(any(ismember('simulation_timepoints', testCase.GRNstruct_params)));
        end
        
        function testExpressionTimepointIsInOptimizationParameters (testCase)
            testCase.assertTrue(any(ismember(testCase.GRNstruct_params, 'expression_timepoints')));
        end
        
        function testMakeGraphsIsInOptimizationParameters (testCase)
            testCase.verifyTrue(any(ismember(testCase.GRNstruct_params,'make_graphs')));
        end
        
        function testEstimateParamsIsInOptimizationParameters (testCase)
            testCase.assertTrue(any(ismember(testCase.GRNstruct_params, 'estimate_params')));            
        end
        
        function testLCurve (testCase)
            testCase.assertTrue(any(ismember(testCase.GRNstruct_params, 'L_curve')));
        end
        
        function testLCurveValueIsValid (testCase)
           testCase.assertTrue(ismember(testCase.GRNstruct.controlParams.L_curve, [0,1]));
        end
        
        function testDeletionDoesNotExist(testCase)
           testCase.assertTrue(~any(ismember(testCase.GRNstruct_params, 'Deletion'))); 
        end
        
    end
    
end