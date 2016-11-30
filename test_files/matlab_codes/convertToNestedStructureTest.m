classdef convertToNestedStructureTest < matlab.unittest.TestCase

   properties
      arrayWithNaN
      timepoint
      genes
   end
   
   methods(TestClassSetup)
       function addPath(testCase)
           addpath([pwd '/../../matlab']);
       end
       
       function setupArray(testCase)
          testCase.timepoint    = {[1 2 3]};
          testCase.genes        = {'A', 'B', 'C'};
          testCase.arrayWithNaN = [15  15 15 20 20
                                   10  22 30 40 50;
                                   NaN 10 20 50 60;
                                   20  20 10 20 20];
       end       
   end
   
   methods(Test)
      function testRemoveNaN(testCase)
           cellArrayWithoutNaN = removeNaN(testCase.arrayWithNaN);
           expected = {15 20; 
                      [10 20 30; 1 2 3], [40 50; 1 2]; 
                      [10 20; 2 3],      [50 60; 1 2]; 
                      [20 20 10; 1 2 3], [20 20; 1 2]};
           testCase.verifyEqual(cellArrayWithoutNaN, expected);
      end
   end
   
end