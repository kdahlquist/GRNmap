classdef PopulateGlobalsTest < matlab.unittest.TestCase

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
        log2FC
    end

    methods(TestClassSetup)
        function makeGlobals(testCase, test_files)
            global alpha adjacency_mat b degrate expression_timepoints ...
                fix_b fix_P num_genes prorate wts deletion is_forced ...
                production_function strain_length log2FC
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
            testCase.log2FC = log2FC;
         end
    end

    methods(TestClassTeardown)
        function clearGlobals(testCase) %#ok<MANU>
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

        function testLog2FC_data(testCase)
            testCase.verifyEqual(testCase.log2FC(1).raw, [0.4	0.4	0.4	0.8	0.8	0.8	1.2	1.2	1.2	1.6	1.6	1.6;...
                                                          -0.376334306292052	-0.376334306292052	-0.376334306292052	-0.706666467343382	-0.706666467343382	-0.706666467343382	-0.987239299670092	-0.987239299670092	-0.987239299670092	-1.21744326547615	-1.21744326547615	-1.21744326547615;...
                                                          -0.227718654239836	-0.227718654239836	-0.227718654239836	-0.408017743026565	-0.408017743026565	-0.408017743026565	-0.546412653239117	-0.546412653239117	-0.546412653239117	-0.649843860182989	-0.649843860182989	-0.649843860182989;...
                                                           0.269293821322375	0.269293821322375	0.269293821322375	0.415935372482249	0.415935372482249	0.415935372482249	0.497511633589691	0.497511633589691	0.497511633589691	0.541599938412416	0.541599938412416	0.541599938412416;...
                                                          -0.290936155220703	-0.290936155220703	-0.290936155220703	-0.579771801563864	-0.579771801563864	-0.579771801563864	-0.85583465653557	-0.85583465653557	-0.85583465653557	-1.10972623205696	-1.10972623205696	-1.10972623205696...
                                                          ]);
            testCase.verifyEqual(testCase.log2FC(2).raw, [0.4	0.4	0.4	0.8	0.8	0.8	1.2	1.2	1.2	1.6	1.6	1.6;...
                                                          -0.376334306292052	-0.376334306292052	-0.376334306292052	-0.706666467343382	-0.706666467343382	-0.706666467343382	-0.987239299670092	-0.987239299670092	-0.987239299670092	-1.21744326547615	-1.21744326547615	-1.21744326547615;...
                                                          -0.227718654239836	-0.227718654239836	-0.227718654239836	-0.408017743026565	-0.408017743026565	-0.408017743026565	-0.546412653239117	-0.546412653239117	-0.546412653239117	-0.649843860182989	-0.649843860182989	-0.649843860182989;...
                                                           0	0	0	0	0	0	0	0	0	0	0	0;...
                                                          -0.13932150464649	-0.13932150464649	-0.13932150464649	-0.249851730445413	-0.249851730445413	-0.249851730445413	-0.336140688374095	-0.336140688374095	-0.336140688374095	-0.402590113617106	-0.402590113617106	-0.402590113617106...
                                                          ]);
        end

        function testLog2FC_deletion(testCase)
            testCase.verifyEqual(testCase.log2FC(1).deletion, 0);
            testCase.verifyEqual(testCase.log2FC(2).deletion, 3);
        end

        function testLog2FC_strain(testCase)
            testCase.verifyEqual(testCase.log2FC(1).Strain, {'wt'});
            testCase.verifyEqual(testCase.log2FC(2).Strain, {'dcin5'});
        end

        function testLog2FC_t_index(testCase)
            testCase.verifyEqual(testCase.log2FC(1).t(1).indx, [1 2 3]);
            testCase.verifyEqual(testCase.log2FC(1).t(2).indx, [4 5 6]);
            testCase.verifyEqual(testCase.log2FC(1).t(3).indx, [7 8 9]);
            testCase.verifyEqual(testCase.log2FC(1).t(4).indx, [10 11 12]);

            testCase.verifyEqual(testCase.log2FC(2).t(1).indx, [1 2 3]);
            testCase.verifyEqual(testCase.log2FC(2).t(2).indx, [4 5 6]);
            testCase.verifyEqual(testCase.log2FC(2).t(3).indx, [7 8 9]);
            testCase.verifyEqual(testCase.log2FC(2).t(4).indx, [10 11 12]);
        end

        function testLog2FC_t_t(testCase)
            testCase.verifyEqual(testCase.log2FC(1).t(1).t, 0.4000);
            testCase.verifyEqual(testCase.log2FC(1).t(2).t, 0.8000);
            testCase.verifyEqual(testCase.log2FC(1).t(3).t, 1.2000);
            testCase.verifyEqual(testCase.log2FC(1).t(4).t, 1.6000);

            testCase.verifyEqual(testCase.log2FC(2).t(1).t, 0.4000);
            testCase.verifyEqual(testCase.log2FC(2).t(2).t, 0.8000);
            testCase.verifyEqual(testCase.log2FC(2).t(3).t, 1.2000);
            testCase.verifyEqual(testCase.log2FC(2).t(4).t, 1.6000);
        end

        function testLog2FC_avg(testCase)
            testCase.verifyEqual(testCase.log2FC(1).avg, [-0.3763 -0.7067 -0.9872 -1.2174
                                                          -0.2277 -0.4080 -0.5464 -0.6498
                                                           0.2693  0.4159  0.4975  0.5416
                                                          -0.2909 -0.5798 -0.8558 -1.1097]);
            testCase.verifyEqual(testCase.log2FC(2).avg, [-0.3763 -0.7067 -0.9872 -1.2174
                                                          -0.2277 -0.4080 -0.5464 -0.6498
                                                           0       0       0       0
                                                          -0.1393 -0.2499 -0.3361 -0.4026]);
        end

        function testLog2FC_stdev(testCase)
            testCase.verifyEqual(testCase.log2FC(1).stdev, [6.79869977755259E-17	1.35973995551052E-16	0	0;...
                                                            3.3993498887763E-17	0	0	0;...
                                                            0	0	0	0;...
                                                            0	0	0   0]);
            testCase.verifyEqual(testCase.log2FC(2).stdev, [6.79869977755259E-17	1.35973995551052E-16	0	0;...
                                                            3.3993498887763E-17	0	0	0;...
                                                            0	0	0	0;...
                                                            0	0	0   0]);
        end

%       GRNstruct.GRNmodel.model --> will probably be different for each
%       indidivual test files
%         function testLog2FC_model(testCase)
%             testCase.verifyEqual(testCase.log2FC(1).model, );
%             testCase.verifyEqual(testCase.log2FC(2).model, );
%         end

    end
end
