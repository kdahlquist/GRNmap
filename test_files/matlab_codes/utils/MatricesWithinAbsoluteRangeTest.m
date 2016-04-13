classdef MatricesWithinAbsoluteRangeTest < matlab.unittest.TestCase
    
    methods(Test)
        function testMatricesWithinAbsoluteRangeDetectsMatricesWithinRange(testCase)
            testCase.assertTrue(matricesWithinAbsoluteRange([3],[3.005],0.01));
        end
        function testMatricesWithinAbsoluteRangeDetectsMatricesOutOfRange(testCase)
            testCase.assertFalse(matricesWithinAbsoluteRange([3],[3.04],0.01));
        end
        function testMatricesWithinAbsoluteRangeDetectsIdenticalMatrices(testCase)
            testCase.assertTrue(matricesWithinAbsoluteRange([3],[3],0));
        end
        function testMatricesWithinAbsoluteRangeRejectsDifferentSizes(testCase)
            testCase.assertFalse(matricesWithinAbsoluteRange([3],[3 3],0.9));
        end
    end

end