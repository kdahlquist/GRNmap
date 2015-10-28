%Unit Testing using functions

function tests = exampleTest
    tests = functiontests(localfunctions);
end

function testRealSolution(testCase)
    actSolution = quadraticSolver(1,-3,2);
    expSolution = [2,1];
    verifyEqual(testCase,actSolution,expSolution)
end

%Supposed to fail since changing outputs to reals
function testImaginarySolution(testCase)
    actSolution = quadraticSolver(1,2,10);
    expSolution = [-1+3i, -1-3i];
    verifyEqual(testCase,actSolution,expSolution)
end