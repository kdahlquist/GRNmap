classdef LSETest < matlab.unittest.TestCase

    properties
        GRNstruct
        test_dir = '\..\..\lse_tests\'

        % global variables used in lse.m
        counter
        log2FC
        prorate
        strain_length
        b
        is_forced
    end

   methods (TestClassSetup)
       function setup (testCase)
           testCase.GRNstruct.inputFile = [testCase.test_dir '4-genes_6-edges_artificial-data_Sigmoidal_estimation_fixb-0_fixP-0_no-graph'];
           testCase.GRNstruct = readInputSheet(testCase.GRNstruct);

           testCase.counter       = 0;
           testCase.log2FC        = testCase.GRNstruct.expressionData;
           testCase.prorate       = testCase.GRNstruct.GRNParams.prorate;
           testCase.strain_length = length(testCase.GRNstruct.expressionData);
           testCase.b             = testCase.GRNstruct.GRNParams.b;
           testCase.is_forced     = testCase.GRNstruct.GRNParams.is_forced;
       end

       function runLSE (testCase)
           global counter log2FC prorate strain_length b is_forced

           counter       = testCase.counter;
           log2FC        = testCase.log2FC;
           prorate       = testCase.prorate;
           strain_length = testCase.strain_length;
           b             = testCase.b;
           is_forced     = testCase.is_forced;

           testCase.GRNstruct = lse(testCase.GRNstruct);
       end
   end

   methods (TestClassTeardown)
       function teardown(testCase)
          testCase.GRNstruct = {};
          clearvars -global
          close all
       end
   end

   methods (Test)
       function testGlobalCounterIsNotZeroIfEstimating (testCase)
           global counter

           if testCase.GRNstruct.controlParams.estimate_params
               % counter for 4-gene 6-edge Sigmoid estimation fix- b=0, P=0 >= 1600
               testCase.verifyTrue (counter ~= 0);
           else
               testCase.verifyEqual (counter, 0);
           end
       end

       function testInitialGuessesIsCorrect (testCase)
           %TODO%
           actual = testCase.GRNstruct.locals.initial_guesses;
           expected = 0;
           testCase.verifyEqual(actual, expected);
       end

       function testEstimatedGuessesIsEqualToInitialGuesses (testCase)
           if testCase.GRNstruct.controlParams.estimate_params
               actual = testCase.GRNstruct.locals.estimated_guesses;
               expected = testCase.GRNstruct.locals.initial_guesses;
               testCase.verifyEqual(actual, expected);
           end
       end

       function testLSEFinalIsCorrect (testCase)
           if testCase.GRNstruct.controlParams.estimate_params
               actual = testCase.GRNstruct.GRNOutput.lse_final;
               expected = 0.001761881584203;
               testCase.verifyEqual(actual, expected);
           end
       end

       function testLSE_0IsCorrect (testCase)
           actual = testCase.GRNstruct.GRNOutput.lse_0;
           expected = 0.047177143360482;
           testCase.verifyEqual(actual, expected);
       end

   end
end
