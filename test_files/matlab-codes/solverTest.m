%Unit testing using classes

classdef solverTest < matlab.unittest.TestCase
    
    methods (Test)
        function testReal (testCase)
            actSolution = quadraticSolver (1, -3, 2);
            expSolution = [2,1];
            testCase.verifyEqual (actSolution, expSolution)
        end
        %Will fail on purpose
        function testImaginary (testCase)
           actSolution = quadraticSolver (1, 0, 1);
           expSolution = [1i, -1i];
           testCase.assertEqual (actSolution, expSolution)
        end
        
        function testStringifyReal (testCase)
            actSolution = stringify (quadraticSolver (1, -3, 2));
            expSolution = '2  1';
            testCase.assertEqual (actSolution, expSolution)
        end
        
        %Will fail on purpose
        function testStringifyImaginary (testCase)
            actSolution = stringify (quadraticSolver (1, 0, 1));
            expSolution = '0+1i   0-1i';
            testCase.assertEqual (actSolution, expSolution)
        end
        
        function testPalindrome (testCase)
            actSolution = palindrome ('string');
            expSolution = 'stringgnirts';
            testCase.assertEqual (actSolution, expSolution)
        end
        
        function testQuadStringPalindrome (testCase)
            actSolution = palindrome (stringify (quadraticSolver (1, -3, 2)));
            expSolution = '2  11  2';
            testCase.assertEqual (actSolution, expSolution)
        end
        
        function testNonNumericImput (testCase)
            testCase.verifyError (@()quadraticSolver('hello','world','hi'),'quadraticSolver:InputMustBeNumeric') 
        end
        
    end
end