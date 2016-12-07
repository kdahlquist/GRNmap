classdef convertToNestedStructureTest < matlab.unittest.TestCase

   properties
      arrayWithNaN
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
          testCase.arrayWithNaN = [
                                       1   1   1   2   2;
                                       111 112 113 211 212;
                                       NaN 122 123 221 222;
                                       131 132 133 231 232
                                   ];
       end       
   end
   
   methods(Test)
      function testConvertToNestedStructure(testCase)
           rawCellArray = convertToNestedStructure(testCase.arrayWithNaN);
           expected = {
                          1,                    2; 
                          [111 112 113; 1 2 3], [211 212; 1 2]; 
                          [122 123; 2 3],       [221 222; 1 2]; 
                          [131 132 133; 1 2 3], [231 232; 1 2]
                      };
           testCase.verifyEqual(rawCellArray, expected);
      end
   end
   
end