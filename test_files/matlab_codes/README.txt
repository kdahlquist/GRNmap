How to run the tests:

1. Make sure that the current path is ~\test_files\matlab_codes. You can
   perform a quick check by typing <pwd> on the Command Window. The tests
   rely on the assumption that the directory for running the tests is where
   the "callTests.m" file is located.
2. Open the file called "callTests.m". Click "Run" (the green triangle
   located at the top of the Matlab IDE). Another way of running is by 
   right-clicking "callTests.m" and selecting "Run". If you see a dialog
   box that says "File <path/to/file> is not in the current folder or on 
   the MATLAB path.", just click "Change Folder" and that should take you
   to the directory of where "callTests.m" is.
3. The tests should start running and you should see something like 
   "Running CompressMissingDataTest ....." on the Command Window.

Some notes about the "callTests" script:

- For now, the MSETest and LCurveTest are not included when running the
  tests. I did this because they take too long to run. If you want to
  include them in the testing runs, simply replace "onlyShortTestsSuite" 
  in the "allSuites" variable with "calculationSuite" and it should run
  every single tests within the calculationTests folder.

- The warning is turned on for a reason, which is to check if the 
  expression data sheet(s) contains only 1 data point for at least 1 
  replicate timepoint.

The testStructs/ folder contains the constant structs that we test against.
In other words, instead of always reading through the Excel spreadsheets
when we are running our tests, we simply populate the fields of the
GRNstruct based on what is needed for a specific set of tests.

P.S. You probably can figure this out on your own, but it doesn't hurt to
be extra careful :)