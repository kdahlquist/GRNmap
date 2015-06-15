classdef readInputSheetTest < matlab.unittest.TestCase
    
    methods (Test)
        %Testing if the inputs from test01SteadyState are read correctly
        
        function test1 (testCase)
            
            GRNstruct.filename = '3-genes_3-edges_artificial-data_Sigmoid_estimation_1.xls';
            GRNstruct.inputFile = which(GRNstruct.filename);
            [~, GRNstruct.sheets] = xlsfinfo(GRNstruct.inputFile);
            
            testCase.assertEqual(any(strcmp(GRNstruct.sheets, 'production_rates')), true);
            testCase.assertEqual(any(strcmp(GRNstruct.sheets, 'degradation_rates')), true);
            testCase.assertEqual(any(strcmp(GRNstruct.sheets, 'wt')), true);
            testCase.assertEqual(any(strcmp(GRNstruct.sheets, 'network')), true);
            testCase.assertEqual(any(strcmp(GRNstruct.sheets, 'network_weights')), true);
            testCase.assertEqual(any(strcmp(GRNstruct.sheets, 'optimization_parameters')), true);
            testCase.assertEqual(any(strcmp(GRNstruct.sheets, 'network_b')), true);
            testCase.assertEqual(any(strcmp(GRNstruct.sheets, 'notes')), true);
            
            GRNstruct = readInputSheet(GRNstruct);
            
            % Tests for populating the structure
            testCase.assertEqual(GRNstruct.degRates, [0.5, 0.8, 1]);
            testCase.assertEqual(GRNstruct.labels.TX0, {'SystematicName','StandardName','DegradationRate';'sysGene1','QT1','';'sysGene2','SMRT1','';'sysGene3','WRD2',''})
            testCase.assertEqual(GRNstruct.GRNParams.wtmat, [0.1, 0, 0; 0, 0.1, 0; 0, 0, 0.1]);
            testCase.assertEqual(GRNstruct.labels.TX2, {'rows genes affected/cols genes controlling','QT1','SMRT1','WRD2';'QT1','','','';'SMRT1','','','';'WRD2','','',''});
            testCase.assertEqual(GRNstruct.GRNParams.A, [1, 0, 0; 0, 1, 0; 0, 0, 1]);
            testCase.assertEqual(GRNstruct.labels.TX3,{'rows genes affected/cols genes controlling','QT1','SMRT1','WRD2';'QT1','','','';'SMRT1','','','';'WRD2','','',''});
            testCase.assertEqual(GRNstruct.GRNParams.prorate, [1; 1.6; 2]);
            testCase.assertEqual(GRNstruct.labels.TX5, {'SystematicName','StandardName','production_rates';'sysGene1','QT1','';'sysGene2','SMRT1','';'sysGene3','WRD2',''});
            testCase.assertEqual(GRNstruct.GRNParams.nedges, 3);
            testCase.assertEqual(GRNstruct.GRNParams.n_active_genes, 3);
            testCase.assertEqual(GRNstruct.GRNParams.active, [1, 2, 3]);
            testCase.assertEqual(GRNstruct.GRNParams.alpha, 0.00000001);
            testCase.assertEqual(GRNstruct.GRNParams.time, [5, 10, 20]);
            testCase.assertEqual(GRNstruct.GRNParams.n_genes, 3);
            testCase.assertEqual(GRNstruct.GRNParams.n_times, 3);
            
            % Tests for setting the control parameters
            testCase.assertEqual(GRNstruct.controlParams.simtime, (0:20));
            testCase.assertEqual(GRNstruct.controlParams.kk_max, 1);
            testCase.assertEqual(GRNstruct.controlParams.MaxIter, 1.00E+06);
            testCase.assertEqual(GRNstruct.controlParams.MaxFunEval, 1.00E+06);
            testCase.assertEqual(GRNstruct.controlParams.TolFun, 1.00E-05);
            testCase.assertEqual(GRNstruct.controlParams.TolX, 0.00001);
            testCase.assertEqual(GRNstruct.controlParams.estimateParams, 1.00E+00);
            testCase.assertEqual(GRNstruct.controlParams.makeGraphs, 1.00E+00);
            testCase.assertEqual(GRNstruct.controlParams.Sigmoid, 1);
            testCase.assertEqual(GRNstruct.controlParams.fix_b, 1);
            testCase.assertEqual(GRNstruct.controlParams.fix_P, 1);
            
            % Tests for setting global variables
            testCase.assertEqual(GRNstruct.GRNParams.b, [0; 0; 0]);
            testCase.assertEqual(GRNstruct.labels.TX6,{'rows genes affected/cols genes controlling';'QT1';'SMRT1';'WRD2'});
            testCase.assertEqual(GRNstruct.labels.TX11, {'StandardName';'QT1';'SMRT1';'WRD2'});
            %testCase.assertEqual(GRNstruct.microData.t.t);
            disp(GRNstruct.GRNParams.no_inputs)
            %testCase.assertEqual(nn,
            
            testCase.assertEqual(GRNstruct.GRNParams.no_inputs, zeros(0,1));
            testCase.assertEqual(GRNstruct.GRNParams.i_forced, [1; 2; 3]);
            testCase.assertEqual(GRNstruct.GRNParams.n_forced, 3);
            
            testCase.assertEqual(GRNstruct.GRNParams.positions,[1, 1;2, 2;3, 3]);
            testCase.assertEqual(GRNstruct.GRNParams.x0, [1; 1; 1])
            
            
        end
        
        function test02SteadyState (testCase)
            GRNstruct.filename = '3-genes_3-edges_artificial-data_Sigmoid_estimation_2.xls';
            GRNstruct.inputFile = which(GRNstruct.filename);
            [~, GRNstruct.sheets] = xlsfinfo(GRNstruct.inputFile);
            
            testCase.assertEqual(any(strcmp(GRNstruct.sheets, 'production_rates')), true);
            testCase.assertEqual(any(strcmp(GRNstruct.sheets, 'degradation_rates')), true);
            testCase.assertEqual(any(strcmp(GRNstruct.sheets, 'wt')), true);
            testCase.assertEqual(any(strcmp(GRNstruct.sheets, 'network')), true);
            testCase.assertEqual(any(strcmp(GRNstruct.sheets, 'network_weights')), true);
            testCase.assertEqual(any(strcmp(GRNstruct.sheets, 'optimization_parameters')), true);
            testCase.assertEqual(any(strcmp(GRNstruct.sheets, 'network_b')), true);
            testCase.assertEqual(any(strcmp(GRNstruct.sheets, 'notes')), true);
            
            GRNstruct = readInputSheet(GRNstruct);
            
            %These are just copies of the ones above so are they really
            %needed?
            testCase.assertEqual(GRNstruct.degRates, [0.5,0.8,1]);
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
            
            testCase.assertEqual(GRNstruct.controlParams.simtime, (0:20));
            testCase.assertEqual(GRNstruct.controlParams.kk_max, 1);
            testCase.assertEqual(GRNstruct.controlParams.MaxIter, 1.00E+06);
            testCase.assertEqual(GRNstruct.controlParams.MaxFunEval, 1.00E+06);
            testCase.assertEqual(GRNstruct.controlParams.TolFun, 1.00E-05);
            testCase.assertEqual(GRNstruct.controlParams.TolX, 0.00001);
            testCase.assertEqual(GRNstruct.controlParams.estimateParams, 1.00E+00);
            testCase.assertEqual(GRNstruct.controlParams.makeGraphs, 1.00E+00);
            testCase.assertEqual(GRNstruct.controlParams.Sigmoid, 1);
            testCase.assertEqual(GRNstruct.controlParams.fix_b, 1);
            
            %Only this one (so far) is different from the test above
            testCase.assertEqual(GRNstruct.controlParams.fix_P, 0);
            
    end
        
    end
    
end