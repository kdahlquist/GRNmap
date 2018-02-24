clc
clearvars -global

import matlab.unittest.TestSuite;
import matlab.unittest.TestRunner;
import matlab.unittest.selectors.HasName;
import matlab.unittest.constraints.ContainsSubstring;
import matlab.unittest.plugins.CodeCoveragePlugin;

grnmapPath = [pwd '\..\..\matlab'];
testStructsPath = [pwd '\testStructs\'];
addpath(grnmapPath);
addpath(testStructsPath);

runner = TestRunner.withTextOutput;
diagnostic = DiagnosticRecorderPlugin;

runner.addPlugin(CodeCoveragePlugin.forFolder(grnmapPath));
runner.addPlugin(diagnostic);

dataStructureSuite = TestSuite.fromFolder('dataStructureTests');
excelSuite = TestSuite.fromFolder('excelTests');
calculationSuite = TestSuite.fromFolder('calculationTests');

% LCurveTest and MSETest take too long :(
onlyShortTestsSuite = calculationSuite.selectIf( ...
    HasName(ContainsSubstring('ForwardSimulationTest')) | ...
    HasName(ContainsSubstring('LSETest')) | ...
    HasName(ContainsSubstring('computeStatisticsTest')) | ...
    HasName(ContainsSubstring('GeneralLSETest')));

% shortSuite = calculationSuite.selectIf(HasName(ContainsSubstring('computeStatisticsTest')));
% onlyReadInputSuite = excelSuite.selectIf(HasName(ContainsSubstring('ReadInputSheetTest')));
allSuites = [dataStructureSuite, excelSuite, calculationSuite];

% onlyShortTestSuite = calculationSuite.selectIf(HasName(ContainsSubstring('computeStatisticsTest')));
% allSuites = onlyShortTestSuite;

warning('on', 'convertToNestedStructure:SingleReplicateData');

result = runner.run(allSuites);
disp(result);
resultBool = result;

failure = 0;
% check for any failures
for i = size(result, 2)
    if result(1, i).Failed == 1
        failure = 1;
        break
    end
end

if failure == 1
    msgbox('We have failures! Check output for more details.');
else
    msgbox('Success! All tests passing');
end

rmpath(grnmapPath);
rmpath(testStructsPath);

close all