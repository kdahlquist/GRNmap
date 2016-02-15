classdef DiagnosticRecorderPlugin < matlab.unittest.plugins.TestRunnerPlugin
    
    properties
        FailedTestData
    end
    
    methods (Access = protected)
        function runTestSuite(plugin, pluginData)
            plugin.FailedTestData = [];
            runTestSuite@...
                matlab.unittest.plugins.TestRunnerPlugin(plugin, pluginData);
        end
        
        function testCase = createTestMethodInstance(plugin, pluginData)
            testCase = createTestMethodInstance@...
                matlab.unittest.plugins.TestRunnerPlugin(plugin, pluginData);
            
            testName = pluginData.Name;
            testCase.addlistener('AssertionFailed', ...
                @(~,event)plugin.recordData(event,testName, 'Assertion'));
            testCase.addlistener('FatalAssertionFailed', ...
                @(~,event)plugin.recordData(event,testName, 'Fatal Assertion'));
            testCase.addlistener('VerificationFailed', ...
                @(~,event)plugin.recordData(event,testName, 'Verification'));
        end
    end
    
    methods (Access = private)
        function recordData(plugin,eventData,name,failureType)
            s.Name = {name};
            s.Type = {failureType};
            s.TestDiagnostics = eventData.TestDiagnosticResult;
            s.FrameworkDiagnostics = eventData.FrameworkDiagnosticResult;
            s.Stack = eventData.Stack;
            s.Timestamp = datetime;
            
            plugin.FailedTestData = [plugin.FailedTestData; struct2table(s)];
        end
    end
end