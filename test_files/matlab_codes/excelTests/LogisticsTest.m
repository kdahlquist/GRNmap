classdef LogisticsTest < matlab.unittest.TestCase

    properties
        test_dir = '..\..\optimization_diagnostic_test\'
        actualDiag
        lengthOfRun
        timestamp
    end

    methods (TestClassSetup)
        function setupActualDiag (testCase)
            testCase.actualDiag = {};
        end

        function setupLengthOfRun (testCase)
            testCase.lengthOfRun = 100;
        end

        function runLogisticsTest (testCase)
            % We calculate timestamp before we run it to minimize time difference as much
            % as possible
            testCase.timestamp = datestr(now, 'mmmm dd, yyyy HH:MM AM');
            testCase.actualDiag = logisitics(testCase.actualDiag, testCase.lengthOfRun, testCase.timestamp);
        end
    end

    methods (Test)
        function testGRNmapVersion(testCase)
            fileID = fopen('version.txt','r');
            text = textscan(fileID,'%s',1,'Delimiter','\n');
            versionNumber = text{1};
            testCase.verifyEqual(testCase.actualDiag{2, 1}, 'GRNmap Version');
            testCase.verifyEqual(testCase.actualDiag{2, 2}, versionNumber);
        end

        function testGRNmapCorrectDate(testCase)
            testCase.verifyEqual(testCase.actualDiag{3, 1}, 'run length');
            testCase.verifyEqual(testCase.actualDiag{3, 2}, testCase.lengthOfRun);
        end

        function testGRNmapCompletedTimestamp(testCase)
            testCase.verifyEqual(testCase.actualDiag{4, 1}, 'time completed');
            testCase.verifyEqual(testCase.actualDiag{4, 2}, testCase.timestamp);
        end
    end
end
