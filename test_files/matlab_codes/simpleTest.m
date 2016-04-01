classdef simpleTest < matlab.unittest.TestCase
    
   properties (MethodSetupParameter)
      num = {'this1', 'that1'}
   end
   
   properties
      newNum 
   end
   
   methods (TestMethodSetup)
       function append (testCase, num)
           testCase.newNum = [num 'something'];
       end
   end
   
   methods (Test)
       function testPrintNum (testCase)
          disp(testCase.newNum) 
       end
   end
end