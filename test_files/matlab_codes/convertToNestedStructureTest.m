classdef convertToNestedStructureTest < matlab.unittest.TestCase

   properties
      timepoint
      genes
      indices
   end

   methods(TestClassSetup)
       function addPath(testCase)
           addpath([pwd '/../../matlab']);
       end

       function setupArray(testCase)
          testCase.timepoint    = {[1 2 3]};
          testCase.genes        = {'A', 'B', 'C'};
          testCase.indices      = {[1 2 3]; [4 5]};
          % test values are formatted in XYZ format, where:
          % X is the expression timepoint value
          % Y is the row number
          % Z is the column number
       end
   end

    methods(Test)

        function testConvertToNestedStructureWithWholeArray (testCase)
            t = struct('indx', {[1 2 3]; [4 5 6]; [7 8 9];}, 't', {1; 2; 3});
            wholeArray = [
                  1   1   1   2   2   2   3   3   3;
                  111 112 113 211 212 213 311 312 313;
                  121 122 123 221 222 223 321 322 323;
                  131 132 133 231 232 233 331 332 333

            ];

            expected = {
                      1,                      2,                     3;
                      [111 112 113; 1 2 3],   [211 212 213; 1 2 3],  [311 312 313; 1 2 3];
                      [121 122 123; 1 2 3],   [221 222 223; 1 2 3],  [321 322 323; 1 2 3];
                      [131 132 133; 1 2 3],   [231 232 233; 1 2 3],  [331 332 333; 1 2 3]
            };

            rawCellArray = convertToNestedStructure(t, wholeArray);
            testCase.verifyEqual(rawCellArray, expected);


        end

        function testConvertToNestedStructureWithNaN(testCase)
            t = struct('indx', {[1 2 3]; [4 5];}, 't', {1; 2});
            arrayWithNaN = [
              1   1   1   2   2;
              111 112 113 211 212;
              NaN 122 123 221 222;
              131 132 133 231 232
            ];
            expected = {
              1,                    2;
              [111 112 113; 1 2 3], [211 212; 1 2];
              [122 123; 2 3],       [221 222; 1 2];
              [131 132 133; 1 2 3], [231 232; 1 2];
            };

            rawCellArray = convertToNestedStructure(t, arrayWithNaN);
            testCase.verifyEqual(rawCellArray, expected);
        end


        function testConvertToNestedStructureRandomizedArray1(testCase)
            t = struct('indx', {[1]; [2 3 4 5]; [6 7]; [8 9]; [10]; [11 12 13]}, 't', {1; 2; 3; 4 ; 5; 6});

            randomizedArray1 = [
                               1   2   2   2   2   3   3   4   4   5   6   6   6;
                               111 211 212 213 214 NaN 312 411 412 511 611 NaN 613;
                               121 221 222 223 NaN 321 322 421 422 521 621 622 623;
                               131 231 232 233 NaN 331 332 431 432 531 631 632 633;
                               NaN 241 242 243 244 341 342 441 442 541 641 642 643;
                               151 251 NaN 253 254 351 352 451 454 551 651 652 653
            ];

            expected = {

                  1,        2,                          3,                4,              5,        6;
                  [111; 1], [211 212 213 214; 1 2 3 4], [312; 2],         [411 412; 1 2], [511; 1], [611 613; 1 3];
                  [121; 1], [221 222 223; 1 2 3],       [321 322; 1 2],   [421 422; 1 2], [521; 1], [621 622 623; 1 2 3];
                  [131; 1], [231 232 233; 1 2 3],       [331 332; 1 2],   [431 432; 1 2], [531; 1], [631 632 633; 1 2 3];
                  [141; 1], [241 242 243 244; 1 2 3 4], [341 342; 1 2],   [441 442; 1 2], [541; 1], [641 642 643; 1 2 3];
                  [151; 1], [251 253 254; 1 3 4],       [351 352; 1 2],   [451 452; 1 2], [551; 1], [651 652 653; 1 2 3];

            };

            rawCellArray = convertToNestedStructure(t, randomizedArray1);
            testCase.verifyEqual(rawCellArray, expected);
        end



        function testConvertToNestedStructureRandomizedArray2(testCase)
            t = struct('indx', {[1]; [2]; [3 4 5]; [6 7]; [8 9]; [10 11]; [12]}, 't', {1; 2; 3; 4 ; 5; 6});

            randomizedArray2 = [
                  1   2   3   3   3   4   4   5   5   6   6   7;
                  111 NaN 311 312 313 411 NaN 511 512 611 612 711;
                  121 221 NaN 322 323 421 422 521 522 621 622 721;
                  131 231 331 332 333 431 432 531 532 631 632 731;
                  NaN 241 341 342 343 441 442 541 542 641 642 741;
                  151 251 351 352 353 451 452 551 NaN 651 652 751
              ];

             expected = {
                      1,        2,        3,                    4,              5,               6,               7
                      [111; 1], [],       [311 312 313; 1 2 3], [411; 1],       [511 512; 1 2],  [611 612; 1 2],  [711; 1];
                      [121; 1], [221; 1], [322 323; 2 3],       [421 422; 1 2], [521 522; 1 2],  [621 622; 1 2],  [721; 1];
                      [131; 1], [231; 1], [331 332 333; 1 2 3], [431 432; 1 2], [531 532; 1 2],  [631 632; 1 2],  [731; 1];
                      [],       [241; 1], [341 342 343; 1 2 3], [441 442; 1 2], [541 542; 1 2],  [641 642; 1 2],  [741; 1];
                      [151; 1], [251; 1], [351 352 353; 1 2 3], [451 452; 1 2], [551; 1],        [651 652; 1 2],  [751; 1];

            };

            rawCellArray = convertToNestedStructure(t, randomizedArray2);
            testCase.verifyEqual(rawCellArray, expected);
        end



        function testConvertToNestedStructureMissingFourCorners(testCase)
            t = struct('indx', {[1 2]; [3]; [4 5 6]; [7 8]; [9]; [10 11]; [12]}, 't', {1; 2; 3; 4 ; 5; 6; 7});

            arrayMissingFourCorners = [
                1   1   2   3   3   3   4   4   5   6   6   7;
                NaN 112 211 311 312 313 411 412 511 611 612 NaN;
                121 122 NaN 321 322 323 421 422 521 621 622 721;
                131 132 231 331 332 333 431 432 531 631 632 731;
                141 142 241 341 342 343 441 442 541 641 642 741;
                NaN 152 251 351 352 353 451 452 551 651 652 NaN
            ];

             expected = {
                 1,              2,         3,                     4,               5,        6,              7;
                 [112; 2],       [211; 1],  [311 312 313; 1 2 3],  [411 412; 1 2],  [511; 1], [611 612; 1 2], [];
                 [121 122; 1 2]  [],        [321 322 323; 1 2 3],  [421 422; 1 2],  [521; 1], [621 622; 1 2], [721; 1];
                 [131 132; 1 2]  [231; 1],  [331 332 333; 1 2 3],  [431 432; 1 2],  [531; 1], [631 632; 1 2], [731; 1];
                 [141 142; 1 2]  [241; 1],  [341 342 343; 1 2 3],  [441 442; 1 2],  [541; 1], [641 642; 1 2], [741; 1];
                 [152; 2]        [251; 1],  [351 352 353; 1 2 3],  [451 452; 1 2],  [551; 1,] [651 652; 1 2], [];

             };

             rawCellArray = convertToNestedStructure(t, arrayMissingFourCorners);
             testCase.verifyEqual(rawCellArray, expected);
        end
    end
end
