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
   
    methods(TestClassTeardown)
        function closeErrorDialogBoxes(testCase)
            close(findall(0, 'Type', 'figure', 'Name', 'Missing Data'));
        end
        
        function closeWarningDialogBoxes(testCase)
            close(findall(0, 'Type', 'figure', 'Name', 'Single Replicate Data'))
        end
    end

    methods(Test)

        function testWithoutNaNs (testCase)
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

         function testOneRowOfNaNs (testCase)
            t = struct('indx', {[1 2 3]; [4 5 6]; [7 8 9];}, 't', {1; 2; 3});
            wholeArray = [
                  1   1   1   2   2   2   3   3   3;
                  111 112 113 211 212 213 311 312 313;
                  121 122 123 NaN NaN NaN 321 322 323;
                  131 132 133 231 232 233 331 332 333
            ];
            expected = 'convertToNestedStructure:MissingData';
            testCase.verifyError(@()convertToNestedStructure(t, wholeArray), expected);
        end

        function testUpperLeftCornerWithNaN (testCase)
            t = struct('indx', {[1 2 3]; [4 5 6]; [7 8 9];}, 't', {1; 2; 3});
            wholeArray = [
                  1   1   1   2   2   2   3   3   3;
                  NaN 112 113 211 212 213 311 312 313;
                  121 122 123 221 222 223 321 322 323;
                  131 132 133 231 232 233 331 332 333
            ];

            expected = {
                      1,                      2,                     3;
                      [112 113; 2 3],         [211 212 213; 1 2 3],  [311 312 313; 1 2 3];
                      [121 122 123; 1 2 3],   [221 222 223; 1 2 3],  [321 322 323; 1 2 3];
                      [131 132 133; 1 2 3],   [231 232 233; 1 2 3],  [331 332 333; 1 2 3]
            };

            rawCellArray = convertToNestedStructure(t, wholeArray);
            testCase.verifyEqual(rawCellArray, expected);
        end

        function testUpperRightCornerWithNaN (testCase)
            t = struct('indx', {[1 2 3]; [4 5 6]; [7 8 9];}, 't', {1; 2; 3});
            wholeArray = [
                  1   1   1   2   2   2   3   3   3;
                  111 112 113 211 212 213 311 312 NaN;
                  121 122 123 221 222 223 321 322 323;
                  131 132 133 231 232 233 331 332 333
            ];

            expected = {
                      1,                      2,                     3;
                      [111 112 113; 1 2 3],   [211 212 213; 1 2 3],  [311 312; 1 2];
                      [121 122 123; 1 2 3],   [221 222 223; 1 2 3],  [321 322 323; 1 2 3];
                      [131 132 133; 1 2 3],   [231 232 233; 1 2 3],  [331 332 333; 1 2 3]
            };

            rawCellArray = convertToNestedStructure(t, wholeArray);
            testCase.verifyEqual(rawCellArray, expected);
        end

        function testLowerLeftCornerWithNaN (testCase)
            t = struct('indx', {[1 2 3]; [4 5 6]; [7 8 9];}, 't', {1; 2; 3});
            wholeArray = [
                  1   1   1   2   2   2   3   3   3;
                  111 112 113 211 212 213 311 312 313;
                  121 122 123 221 222 223 321 322 323;
                  NaN 132 133 231 232 233 331 332 333
            ];

            expected = {
                      1,                      2,                     3;
                      [111 112 113; 1 2 3],   [211 212 213; 1 2 3],  [311 312 313; 1 2 3];
                      [121 122 123; 1 2 3],   [221 222 223; 1 2 3],  [321 322 323; 1 2 3];
                      [132 133; 2 3],         [231 232 233; 1 2 3],  [331 332 333; 1 2 3]

            };

            rawCellArray = convertToNestedStructure(t, wholeArray);
            testCase.verifyEqual(rawCellArray, expected);
        end

        function testLowerRightCornerWithNaN (testCase)
            t = struct('indx', {[1 2 3]; [4 5 6]; [7 8 9];}, 't', {1; 2; 3});
            wholeArray = [
                  1   1   1   2   2   2   3   3   3;
                  111 112 113 211 212 213 311 312 313;
                  121 122 123 221 222 223 321 322 323;
                  131 132 133 231 232 233 331 332 NaN
            ];

            expected = {
                      1,                      2,                     3;
                      [111 112 113; 1 2 3],   [211 212 213; 1 2 3],  [311 312 313; 1 2 3];
                      [121 122 123; 1 2 3],   [221 222 223; 1 2 3],  [321 322 323; 1 2 3];
                      [131 132 133; 1 2 3],   [231 232 233; 1 2 3],  [331 332; 1 2]
            };

            rawCellArray = convertToNestedStructure(t, wholeArray);
            testCase.verifyEqual(rawCellArray, expected);
        end

        function testReplicateNaNPermutations (testCase)
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

        function testRowNaNPermutations (testCase)
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

        function testColumnNaNPermutations (testCase)        
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

        function testAllNaNs (testCase)
            t = struct('indx', {[1 2 3]; [4 5 6]; [7 8 9];}, 't', {1; 2; 3});
            wholeArray = [
                  1   1   1   2   2   2   3   3   3;
                  NaN NaN NaN NaN NaN NaN NaN NaN NaN;
                  NaN NaN NaN NaN NaN NaN NaN NaN NaN;
                  NaN NaN NaN NaN NaN NaN NaN NaN NaN
            ];
            expected = 'convertToNestedStructure:MissingData';
            testCase.verifyError(@()convertToNestedStructure(t, wholeArray), expected);
        end

        % Old Tests

        function testConvertToNestedStructureNaN(testCase)
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

        function emptyArray(testCase)
            t = struct('indx', {}, 't', {});
            emptyArray = [];
            expected = {};
            rawCellArray = convertToNestedStructure(t, emptyArray);
            testCase.verifyEqual(rawCellArray, expected);
        end

    end
end
