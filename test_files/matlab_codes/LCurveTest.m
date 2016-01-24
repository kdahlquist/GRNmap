classdef LCurveTest < matlab.unittest.TestCase
   properties
       test_dir = '..\perturbation_tests\math_post_L-curve_corrected\'
       previous_dir
       expected_values
       GRNmap_path
       GRNstruct
   end
   
   methods (TestClassSetup)
       function runGRNmap (testCase)
          testCase.GRNstruct = output(testCase.GRNstruct); 
       end 
   end
   
   methods (TestMethodSetup)
       function changePath (testCase)
           testCase.expected_values = xlsread ();
           testCase.GRNmap_path = [pwd '/../../matlab'];
           addpath(testCase.GRNmap_path);
           testCase.previous_dir = pwd;
           cd (tempdir)
       end
   end
   
   methods (TestMethodTeardown)
       function revertPath (testCase)
           cd (testCase.previous_dir);
           
       end
   end
   
   methods (Test)
       function testIfLCurveParameterIsRead (testCase)
           
       end
   end
end