classdef computeStatisticsTest < matlab.unittest.TestCase
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

    methods(TestClassTeardown)
        function closeErrorDialogBoxes(testCase) %#ok<MANU>
            close(findall(0, 'Type', 'figure', 'Name', 'Missing Data'));
        end

        function closeWarningDialogBoxes(testCase) %#ok<MANU>
            close(findall(0, 'Type', 'figure', 'Name', 'Single Replicate Data'))
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
                'raw', {[0.4    0.4    0.4    0.8    0.8    0.8    1.2    1.2    1.2    1.6    1.6    1.6;...
                              -0.376334306292052    -0.376334306292052    -0.376334306292052    -0.706666467343382    -0.706666467343382    -0.706666467343382    -0.987239299670092    -0.987239299670092    -0.987239299670092    -1.21744326547615    -1.21744326547615    -1.21744326547615;...
                              -0.227718654239836    -0.227718654239836    -0.227718654239836    -0.408017743026565    -0.408017743026565    -0.408017743026565    -0.546412653239117    -0.546412653239117    -0.546412653239117    -0.649843860182989    -0.649843860182989    -0.649843860182989;...
                               0.269293821322375    0.269293821322375    0.269293821322375    0.415935372482249    0.415935372482249    0.415935372482249    0.497511633589691    0.497511633589691    0.497511633589691    0.541599938412416    0.541599938412416    0.541599938412416;...
                              -0.290936155220703    -0.290936155220703    -0.290936155220703    -0.579771801563864    -0.579771801563864    -0.579771801563864    -0.85583465653557    -0.85583465653557    -0.85583465653557    -1.10972623205696    -1.10972623205696    -1.10972623205696...
                             ];
                             [0.4    0.4    0.4    0.8    0.8    0.8    1.2    1.2    1.2    1.6    1.6    1.6;...
                              -0.376334306292052    -0.376334306292052    -0.376334306292052    -0.706666467343382    -0.706666467343382    -0.706666467343382    -0.987239299670092    -0.987239299670092    -0.987239299670092    -1.21744326547615    -1.21744326547615    -1.21744326547615;...
                              -0.227718654239836    -0.227718654239836    -0.227718654239836    -0.408017743026565    -0.408017743026565    -0.408017743026565    -0.546412653239117    -0.546412653239117    -0.546412653239117    -0.649843860182989    -0.649843860182989    -0.649843860182989;...
                              0    0    0    0    0    0    0    0    0    0    0    0;...
                              -0.13932150464649    -0.13932150464649    -0.13932150464649    -0.249851730445413    -0.249851730445413    -0.249851730445413    -0.336140688374095    -0.336140688374095    -0.336140688374095    -0.402590113617106    -0.402590113617106    -0.402590113617106...
                             ]}...
            );

            testCase.GRNstruct.GRNParams = struct(...
                 'adjacency_mat', [1 0 0 0; 0 1 0 0; 0 0 1 1; 0 0 1 1],...
                 'alpha', 0.001,...
                 'b', [0;0;0;0],...
                 'num_genes', 4, ...
                 'num_edges', 6,...
                 'num_forced', 4, ...
                 'is_forced', [1; 2; 3; 4], ...
                 'no_inputs', [], ...
                 'positions', [1, 1; 2, 2; 3, 3; 3, 4; 4, 3; 4, 4], ...
                 'prorate', [0.5;
                             1.0;
                             2.0;
                             1.0], ...
                 'minLSE', 1.21333586496396E-33, ...
                 'active', 1:4, ...
                 'num_times', 4, ...
                 'expression_timepoints', [0.4 0.8 1.2 1.6], ...
                 'num_strains', 2 ...
             );


            testCase.GRNstruct = compressMissingData(testCase.GRNstruct);
            testCase.GRNstruct = computeStatistics(testCase.GRNstruct);

            expectedMinLSE = constantStruct.GRNParams.minLSE;
            expectedStdev = constantStruct.expressionData.stdev;
            expectedAvg = constantStruct.expressionData.avg;

            actualMinLSE = testCase.GRNstruct.GRNParams.minLSE;
            actualStdev = testCase.GRNstruct.expressionData.stdev;
            actualAvg = testCase.GRNstruct.expressionData.avg;

            errorStdev = abs(actualStdev - expectedStdev) < 1E-15;
            errorAvg = abs(actualAvg - expectedAvg) < 1E-04;

            testCase.verifyTrue(abs(actualMinLSE - expectedMinLSE) < 1E-15);
            testCase.verifyTrue(all(errorStdev(:)));
            testCase.verifyTrue(all(errorAvg(:)));

        end

        function testWithOneMissingDataPoint (testCase)
            testCase.GRNstruct.expressionData = struct( ...
                  'Strain', {{'wt'}}, ...
                  't', struct ('indx', {[1 2]; [3 4 5]}, 't', {10; 20}), ...
                  'raw', {[10    10    20   20   20;...
                           1.5   1     2.1  2    NaN;...
                           3     3     4    4.6    4.3;...
                          ]}...
              );
            testCase.GRNstruct.GRNParams = struct(...
                 'num_genes', 2, ...
                 'num_times', 2, ...
                 'expression_timepoints', [10 20], ...
                 'num_strains', 1 ...
             );


            testCase.GRNstruct.expectedMinLSE = 0.0344;
            testCase.GRNstruct.expectedAvg = [
                                              1.2500    2.0500
                                              3         4.3000
                                             ];

            testCase.GRNstruct.expectedStdev = [
                                                0.3536    0.0707
                                                0         0.3000
                                               ];

            testCase.GRNstruct = compressMissingData(testCase.GRNstruct);
            testCase.GRNstruct = computeStatistics(testCase.GRNstruct);

            expectedMinLSE = testCase.GRNstruct.expectedMinLSE;
            expectedStdev =  testCase.GRNstruct.expectedStdev;
            expectedAvg = testCase.GRNstruct.expectedAvg;

            actualMinLSE = testCase.GRNstruct.GRNParams.minLSE;
            actualStdev = testCase.GRNstruct.expressionData.stdev;
            actualAvg = testCase.GRNstruct.expressionData.avg;

            errorStdev = abs(actualStdev - expectedStdev) < 1E-04;
            errorAvg = abs(actualAvg - expectedAvg) < 1E-04;

            testCase.verifyTrue(abs(actualMinLSE - expectedMinLSE) < 1E-04);
            testCase.verifyTrue(all(errorStdev(:)));
            testCase.verifyTrue(all(errorAvg(:)));

        end

        function testWithMultipleMissingDataPoints (testCase)
            testCase.GRNstruct.expressionData = struct( ...
                  't', struct ('indx', {[1 2]; [3 4]; [5 6 7]; [8]}, 't', {10; 20; 30; 40}), ...
                  'raw', {[10    10    20    20    30    30    30    40;...
                           1     1.1   2     2     NaN   3     3.3     4;...
                           NaN   5     6     NaN   7     7     NaN     8;...
                           ];...
                         }...
            );

            testCase.GRNstruct.GRNParams = struct(...
                    'num_genes', 2, ...
                    'num_times', 4, ...
                    'expression_timepoints', [10 20 30 40], ...
                    'num_strains', 1 ...
            );


            testCase.GRNstruct = compressMissingData(testCase.GRNstruct);
            testCase.GRNstruct = computeStatistics(testCase.GRNstruct);

            testCase.GRNstruct.expectedMinLSE = 0.0042;
            testCase.GRNstruct.expectedAvg = [
                                                 1.0500    2    3.1500    4
                                                 5         6    7         8
                                             ];
            testCase.GRNstruct.expectedStdev = [
                                                 0.0707    0    0.2121    0
                                                 0         0    0         0
                                               ];

            expectedMinLSE = testCase.GRNstruct.expectedMinLSE;
            expectedStdev =  testCase.GRNstruct.expectedStdev;
            expectedAvg = testCase.GRNstruct.expectedAvg;

            actualMinLSE = testCase.GRNstruct.GRNParams.minLSE;
            actualStdev = testCase.GRNstruct.expressionData.stdev;
            actualAvg = testCase.GRNstruct.expressionData.avg;


            % Note as our tests are already truncated for simplicity's sake
            % while we can perform more specific calculations we deemed it
            % unnecessary as we are not testing specific calculation.
            % In this case we felt rough similarity was more approriate than
            % extreme precision.

            errorStdev = abs(actualStdev - expectedStdev) < 1E-04;
            errorAvg = abs(actualAvg - expectedAvg) < 1E-04;

            testCase.verifyTrue(abs(actualMinLSE - expectedMinLSE) < 1E-04);
            testCase.verifyTrue(all(errorStdev(:)));
            testCase.verifyTrue(all(errorAvg(:)));

        end

        function testWithNegativeNumbers (testCase)
            testCase.GRNstruct.expressionData = struct( ...
                  't', struct ('indx', {[1 2]; [3 4]; [5 6]; [8]; [9 10]}, 't', {10; 20; 30; 40; 50}), ...
                  'raw', {[10    10    20    20     30    30    40    50    50;...
                           -1    -1.1  -2    -2     NaN   -3    -3.3  -4.3  -4.2;...
                           NaN   -5    -6    NaN    -7    -7.2  -7.8  -8    -8.7;...
                           ];...
                         }...
            );

            testCase.GRNstruct.GRNParams = struct(...
                    'num_genes', 2, ...
                    'num_times', 5, ...
                    'expression_timepoints', [10 20 30 40 50], ...
                    'num_strains', 1 ...
            );


            testCase.GRNstruct = compressMissingData(testCase.GRNstruct);
            testCase.GRNstruct = computeStatistics(testCase.GRNstruct);

            testCase.GRNstruct.expectedMinLSE = 0.0183;
            testCase.GRNstruct.expectedAvg = [
                                                 -1.0500    -2    -3    -3.3    -4.2500
                                                 -5         -6    -7.1  -7.8    -8.3500
                                             ];
            testCase.GRNstruct.expectedStdev = [
                                                 0.0707    0    0      0    0.0707
                                                 0         0    0.1414 0    0.4950
                                               ];

            expectedMinLSE = testCase.GRNstruct.expectedMinLSE;
            expectedStdev = testCase.GRNstruct.expectedStdev;
            expectedAvg = testCase.GRNstruct.expectedAvg;

            actualMinLSE = testCase.GRNstruct.GRNParams.minLSE;
            actualStdev = testCase.GRNstruct.expressionData.stdev;
            actualAvg = testCase.GRNstruct.expressionData.avg;

            errorStdev = abs(actualStdev - expectedStdev) < 1E-04;
            errorAvg = abs(actualAvg - expectedAvg) < 1E-04;

            testCase.verifyTrue(abs(actualMinLSE - expectedMinLSE) < 1E-04);
            testCase.verifyTrue(all(errorStdev(:)));
            testCase.verifyTrue(all(errorAvg(:)));

        end

        function testWithZeros (testCase)
            testCase.GRNstruct.expressionData = struct( ...
                  'Strain', {{'wt'}}, ...
                  't', struct ('indx', {[1 2]; [3 4 5 6]; [7 8]; [9 10]}, 't', {10; 20; 30; 40}), ...
                  'raw', {[10    10    20   20   20    20    30    30    40    40;...
                           1.5   1     2.1  2    NaN   2     0     0     3     3.1;...
                           0     0     0    2    -2.1  1     4     4.1   0     0;...
                          ]}...
              );
            testCase.GRNstruct.GRNParams = struct(...
                 'num_genes', 2, ...
                 'num_times', 4, ...
                 'expression_timepoints', [10 20 30 40], ...
                 'num_strains', 1 ...
             );


            testCase.GRNstruct.expectedMinLSE = 0.4921;
            testCase.GRNstruct.expectedAvg = [
                                              1.2500    2.0333    0       3.0500
                                              0         0.2250   4.0500  0
                                             ];

            testCase.GRNstruct.expectedStdev = [
                                                0.3536    0.0577    0    0.0707;
                                                0         1.7519    0.0707    0
                                               ];

            testCase.GRNstruct = compressMissingData(testCase.GRNstruct);
            testCase.GRNstruct = computeStatistics(testCase.GRNstruct);

            expectedMinLSE = testCase.GRNstruct.expectedMinLSE;
            expectedStdev =  testCase.GRNstruct.expectedStdev;
            expectedAvg = testCase.GRNstruct.expectedAvg;

            actualMinLSE = testCase.GRNstruct.GRNParams.minLSE;
            actualStdev = testCase.GRNstruct.expressionData.stdev;
            actualAvg = testCase.GRNstruct.expressionData.avg;

            errorStdev = abs(actualStdev - expectedStdev) < 1E-04;
            errorAvg = abs(actualAvg - expectedAvg) < 1E-04;

            testCase.verifyTrue(abs(actualMinLSE - expectedMinLSE) < 1E-04);
            testCase.verifyTrue(all(errorStdev(:)));
            testCase.verifyTrue(all(errorAvg(:)));

        end

         function testWithZerosAndNegativeNumbers (testCase)
            testCase.GRNstruct.expressionData = struct( ...
                  'Strain', {{'wt'}}, ...
                  't', struct ('indx', {[1 2]; [3 4]; [5 6 7 8]; [9]; [10 11]; [12]}, 't', {10; 20; 30; 40; 50; 60}), ...
                  'raw', {[10    10    20    20    30    30    30    30    40    50   50   60;...
                           -1.5  -1    0     0     NaN   -0.5  0     0     3     3.1  3.5  -4.1;...
                           0     0     -5.2  -5.2  -6.7  -6.9  -7.3  0     0     0    0    -8;...
                          ]}...
              );
            testCase.GRNstruct.GRNParams = struct(...
                 'num_genes', 2, ...
                 'num_times', 6, ...
                 'expression_timepoints', [10 20 30 40 50 60], ...
                 'num_strains', 1 ...
             );


            testCase.GRNstruct.expectedMinLSE = 1.6069;
            testCase.GRNstruct.expectedAvg = [
                                              -1.2500    0        -0.1667    3         3.3000    -4.1
                                              0          -5.2     -5.2250    0         0         -8
                                             ];

            testCase.GRNstruct.expectedStdev = [
                                                0.3536    0    0.2887    0    0.2828    0;
                                                0         0    3.4923    0    0         0;
                                               ];

            testCase.GRNstruct = compressMissingData(testCase.GRNstruct);
            testCase.GRNstruct = computeStatistics(testCase.GRNstruct);

            expectedMinLSE = testCase.GRNstruct.expectedMinLSE;
            expectedStdev =  testCase.GRNstruct.expectedStdev;
            expectedAvg = testCase.GRNstruct.expectedAvg;

            actualMinLSE = testCase.GRNstruct.GRNParams.minLSE;
            actualStdev = testCase.GRNstruct.expressionData.stdev;
            actualAvg = testCase.GRNstruct.expressionData.avg;

            errorStdev = abs(actualStdev - expectedStdev) < 1E-04;
            errorAvg = abs(actualAvg - expectedAvg) < 1E-04;

            testCase.verifyTrue(abs(actualMinLSE - expectedMinLSE) < 1E-04);
            testCase.verifyTrue(all(errorStdev(:)));
            testCase.verifyTrue(all(errorAvg(:)));
        end

        function testWithCompleteZeros(testCase)
           testCase.GRNstruct.expressionData = struct( ...
                 'Strain', {{'wt'}}, ...
                 't', struct ('indx', {[1 2]; [3 4]; [5 6]; [7]}, 't', {10; 20; 30; 40}), ...
                 'raw', {[10    10    20    20    30    30     40
                          0     0     0     0     0     0      0
                          0     0     0     0     0     0      0
                         ]}...
             );
           testCase.GRNstruct.GRNParams = struct(...
                'num_genes', 2, ...
                'num_times', 4, ...
                'expression_timepoints', [10 20 30 40], ...
                'num_strains', 1 ...
            );


           testCase.GRNstruct.expectedMinLSE = 0;
           testCase.GRNstruct.expectedAvg = [
                                             0    0    0    0;
                                             0    0    0    0;
                                            ];

           testCase.GRNstruct.expectedStdev = [
                                               0    0    0    0;
                                               0    0    0    0;
                                              ];
           testCase.GRNstruct = compressMissingData(testCase.GRNstruct);
           testCase.GRNstruct = computeStatistics(testCase.GRNstruct);

           expectedMinLSE = testCase.GRNstruct.expectedMinLSE;
           expectedStdev =  testCase.GRNstruct.expectedStdev;
           expectedAvg = testCase.GRNstruct.expectedAvg;

           actualMinLSE = testCase.GRNstruct.GRNParams.minLSE;
           actualStdev = testCase.GRNstruct.expressionData.stdev;
           actualAvg = testCase.GRNstruct.expressionData.avg;

           errorStdev = abs(actualStdev - expectedStdev) < 1E-04;
           errorAvg = abs(actualAvg - expectedAvg) < 1E-04;

           testCase.verifyTrue(abs(actualMinLSE - expectedMinLSE) < 1E-04);
           testCase.verifyTrue(all(errorStdev(:)));
           testCase.verifyTrue(all(errorAvg(:)));
       end
    end
end
