classdef calculationsTest < matlab.unittest.TestCase
    properties
        GRNstruct
        minLSECalculation

    end

    methods (TestClassSetup)
        function addGRNmapPath (testCase) %#ok<MANU>
            addpath([pwd '\..\..\..\matlab'])
            addpath([pwd '\..\testStructs'])
        end
    end

    methods (Test)
        function testWithNoMissingData (testCase)
            constantStruct = ConstantGRNstructs.MM_estimation_fixP0_graph;
            testCase.GRNstruct.expressionData = struct(...
                'Strain', {{'wt'};{'dcin5'}},...
                'deletion', {0; 3}, ...
                'model', {[];[]},...
                't', struct ('indx', {[1 2 3]; [4 5 6]; [7 8 9]; [10 11 12]}, 't', {0.4; 0.8; 1.2; 1.6}), ...
                'raw', {[0.4	0.4	0.4	0.8	0.8	0.8	1.2	1.2	1.2	1.6	1.6	1.6;...
                              -0.376334306292052	-0.376334306292052	-0.376334306292052	-0.706666467343382	-0.706666467343382	-0.706666467343382	-0.987239299670092	-0.987239299670092	-0.987239299670092	-1.21744326547615	-1.21744326547615	-1.21744326547615;...
                              -0.227718654239836	-0.227718654239836	-0.227718654239836	-0.408017743026565	-0.408017743026565	-0.408017743026565	-0.546412653239117	-0.546412653239117	-0.546412653239117	-0.649843860182989	-0.649843860182989	-0.649843860182989;...
                               0.269293821322375	0.269293821322375	0.269293821322375	0.415935372482249	0.415935372482249	0.415935372482249	0.497511633589691	0.497511633589691	0.497511633589691	0.541599938412416	0.541599938412416	0.541599938412416;...
                              -0.290936155220703	-0.290936155220703	-0.290936155220703	-0.579771801563864	-0.579771801563864	-0.579771801563864	-0.85583465653557	-0.85583465653557	-0.85583465653557	-1.10972623205696	-1.10972623205696	-1.10972623205696...
                             ];
                             [0.4	0.4	0.4	0.8	0.8	0.8	1.2	1.2	1.2	1.6	1.6	1.6;...
                              -0.376334306292052	-0.376334306292052	-0.376334306292052	-0.706666467343382	-0.706666467343382	-0.706666467343382	-0.987239299670092	-0.987239299670092	-0.987239299670092	-1.21744326547615	-1.21744326547615	-1.21744326547615;...
                              -0.227718654239836	-0.227718654239836	-0.227718654239836	-0.408017743026565	-0.408017743026565	-0.408017743026565	-0.546412653239117	-0.546412653239117	-0.546412653239117	-0.649843860182989	-0.649843860182989	-0.649843860182989;...
                              0	0	0	0	0	0	0	0	0	0	0	0;...
                              -0.13932150464649	-0.13932150464649	-0.13932150464649	-0.249851730445413	-0.249851730445413	-0.249851730445413	-0.336140688374095	-0.336140688374095	-0.336140688374095	-0.402590113617106	-0.402590113617106	-0.402590113617106...
                             ]},...
            );


            testCase.GRNstruct = compressMissingData(testStruct);
            expectedMinLSE = constantStruct.GRNParams.minLSE;
            expectedStdev = constantStruct.expressionData.stdev;
            expectedAvg = constantStruct.expressionData.avg;

            actualMinLSE = testStruct.GRNParams.minLSE;
            actualStdev = testStruct.expressionData.stdev;
            actualAvg = testStruct.expressionData.avg;

            testCase.verifyEqual(actualMinLSE, expectedMinLSE);
            testCase.verifyEqual(actualStdev, expectedStdev);
            testCase.verifyEqual(actualAvg, expectedAvg);

        end

        function testWithOneMissingDataPoint (testCase)
            constantStruct = CompressMissingDataStruct.GRNstruct_with_one_NaN;
            testCase.GRNstruct.expressionData = struct( ...
              'expressionData', struct(...
                  't', struct ('indx', {[1 2 3]; [4 5 6]; [7 8 9]}, 't', {0.4; 0.8; 1.2}), ...
                  'raw', {[0.4	0.4	0.4	0.8	0.8	0.8	1.2	1.2	1.2;...
                           -0.376334306292052	-0.376334306292052	-0.376334306292052	-0.706666467343382	-0.706666467343382	-0.706666467343382	-0.987239299670092	-0.987239299670092	-0.987239299670092;...
                           -0.227718654239836	-0.227718654239836	 NaN                -0.408017743026565	-0.408017743026565	-0.408017743026565	-0.546412653239117	-0.546412653239117	-0.546412653239117;...
                            0.269293821322375	 0.269293821322375	 0.269293821322375	 0.415935372482249	 0.415935372482249	 0.415935372482249 	 0.497511633589691	 0.497511633589691	 0.497511633589691;...
                           -0.290936155220703	-0.290936155220703	-0.290936155220703	-0.579771801563864	-0.579771801563864	-0.579771801563864	-0.85583465653557	-0.85583465653557	-0.85583465653557...
                           ];
                           [0.4	0.4	0.4	0.8	0.8	0.8	1.2	1.2	1.2;...
                           -0.376334306292052	-0.376334306292052	-0.376334306292052	-0.706666467343382	-0.706666467343382	-0.706666467343382	-0.987239299670092	-0.987239299670092	-0.987239299670092;...
                           -0.227718654239836	-0.227718654239836	-0.227718654239836	-0.408017743026565	-0.408017743026565	-0.408017743026565	-0.546412653239117	-0.546412653239117	-0.546412653239117;...
                            0                     0                   0                   0                   0                   0                   0                   0                   0;...
                           -0.13932150464649     -0.13932150464649	-0.13932150464649	-0.249851730445413	-0.249851730445413	-0.249851730445413	-0.336140688374095	-0.336140688374095	-0.336140688374095...
                      ]}...
                 )...
            );

            %TODO calculate minLSE
            testCase.GRNstruct.actualMinLSE = 0;

                                              ]};
            testCase.GRNstruct.actualAvg = {[
                                                -0.37633430629205195    -0.706666467343382    -0.9872392996700915
                                                -0.227718654239836      -0.408017743026565    -0.546412653239117
                                                0.269293821322375       0.415935372482249     0.497511633589691
                                                -0.290936155220703      -0.579771801563864    -0.85583465653557
                                            ];

                                                -0.37633430629205195    -0.706666467343382   -0.987239299670092
                                                -0.22771865423983603    -0.408017743026565   -0.546412653239117
                                                0                       0                    0
                                                -0.13932150464649       -0.249851730445413   -0.336140688374095
                                            [
                                           ]};
            %TODO calculate actualStdev
            testCase.GRNstruct.actualStdev = {[

                                             ]};

            testCase.GRNstruct = compressMissingData(testStruct);
            expectedMinLSE = constantStruct.GRNParams.minLSE;
            expectedStdev = constantStruct.expressionData.stdev;
            expectedAvg = constantStruct.expressionData.avg;

            actualMinLSE = testStruct.GRNParams.minLSE;
            actualStdev = testStruct.expressionData.stdev;
            actualAvg = testStruct.expressionData.avg;

            testCase.verifyEqual(actualMinLSE, expectedMinLSE);
            testCase.verifyEqual(actualStdev, expectedStdev);
            testCase.verifyEqual(actualAvg, expectedAvg);

        end

        function testWithMultipleMissingDataPoints (testCase)
            constantStruct = ConstantGRNstructs.MM_estimation_fixP0_graph;
            testCase.GRNstruct =  struct( ...
                 'expressionData', struct(...
                     't', struct ('indx', {[1 2 3]; [4 5 6]; [7 8 9]}, 't', {0.4; 0.8; 1.2}), ...
                     'raw', {[0.4	0.4	0.4	0.8	0.8	0.8	1.2	1.2	1.2;...
                              -0.376334306292052	-0.376334306292052	-0.376334306292052	-0.706666467343382	-0.706666467343382	-0.706666467343382	 NaN                -0.987239299670092	-0.987239299670092;...
                              -0.227718654239836	-0.227718654239836	 NaN                -0.408017743026565	-0.408017743026565	-0.408017743026565	-0.546412653239117	-0.546412653239117	-0.546412653239117;...
                               0.269293821322375	 0.269293821322375	 0.269293821322375	 0.415935372482249	 NaN            	 0.415935372482249 	 0.497511633589691	 0.497511633589691	 0.497511633589691;...
                              -0.290936155220703	-0.290936155220703	-0.290936155220703	-0.579771801563864	-0.579771801563864	-0.579771801563864	-0.85583465653557	-0.85583465653557	 NaN...
                              ];
                              [0.4	0.4	0.4	0.8	0.8	0.8	1.2	1.2	1.2;...
                              -0.376334306292052	-0.376334306292052	-0.376334306292052	-0.706666467343382	-0.706666467343382	 NaN                -0.987239299670092	-0.987239299670092	-0.987239299670092;...
                              -0.227718654239836	 NaN                -0.227718654239836	-0.408017743026565	-0.408017743026565	-0.408017743026565	-0.546412653239117	-0.546412653239117	-0.546412653239117;...
                               0                     0                   0                   0                   0                   0                   0                   0                   0;...
                               NaN                  -0.13932150464649	-0.13932150464649	 NaN                -0.249851730445413	-0.249851730445413	-0.336140688374095	-0.336140688374095	-0.336140688374095...
                              ]}...
                 )...
            );


            %TODO calculate minLSE
            testCase.GRNstruct.actualMinLSE = [];
            testCase.GRNstruct.actualAvg = {[
                                                 -0.37633430629205195    -0.706666467343382


                                            ];
                                            [
                                           ]};
            %TODO calculate actualStdev
            testCase.GRNstruct.actualStdev = [];


            testCase.GRNstruct = compressMissingData(testStruct);
            expectedMinLSE = constantStruct.GRNParams.minLSE;
            expectedStdev = constantStruct.expressionData.stdev;
            expectedAvg = constantStruct.expressionData.avg;

            actualMinLSE = testStruct.GRNParams.minLSE;
            actualStdev = testStruct.expressionData.stdev;
            actualAvg = testStruct.expressionData.avg;

            testCase.verifyEqual(actualMinLSE, expectedMinLSE);
            testCase.verifyEqual(actualStdev, expectedStdev);
            testCase.verifyEqual(actualAvg, expectedAvg);

        end
    end
end
