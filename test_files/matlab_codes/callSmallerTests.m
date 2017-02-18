clc
clear all

import matlab.unittest.TestSuite;
import matlab.unittest.TestRunner;
import matlab.unittest.selectors.HasName;
import matlab.unittest.constraints.ContainsSubstring;
import matlab.unittest.plugins.CodeCoveragePlugin;

grnmapPath = [pwd '\..\..\matlab'];
addpath(grnmapPath);

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
    HasName(ContainsSubstring('GeneralLSETest')));

allSuites = [dataStructureSuite, excelSuite, onlyShortTestsSuite];

warning('off', 'all');
result = runner.run(allSuites);
warning('on', 'all');
disp(result);