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

% onlyReadInputSuite = excelSuite.selectIf(HasName(ContainsSubstring('ReadInputSheetTest')));

allSuites = [dataStructureSuite, excelSuite, calculationSuite];

warning('on', 'convertToNestedStructure:SingleReplicateData');

result = runner.run(allSuites);
disp(result);

rmpath(grnmapPath);
rmpath(testStructsPath);

close all