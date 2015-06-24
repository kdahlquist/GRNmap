classdef outputTest < matlab.unittest.TestCase
    
%   Will have to implement setup and teardown for cleaner tests instead of
%   having a global GRNstruct. Setup and teardown functions don't work just
%   yet; work on this will continue in the fall.
    properties
        OriginalPath
    end
    
    methods (TestMethodSetup)
        function addTestFilePath (testCase)
           testCase.OriginalPath = path;
           p = fileparts(pwd);
           addpath(fullfile(p, 'sixteen_tests'));
        end
        
        % Finds the temporary folder in the system. We need to create a
        % temporary file to check if output sheets are saved
        function addTempFolder (testCase)
            testCase.temporary_folder = tempdir;
            [~, testCase.filename, testCase.extension] = fileparts (GRNstruct.inputFile);
            testCase.temporary_file = [tempname, testCase.extension];
        end

    end
    
    methods (TestMethodTeardown)
        
        function deletePlots (testCase)
           if ~isempty(dir('*.jpg'))
              delete ('ACE2.jpg', 'AFT2.jpg', 'CIN5.jpg', 'FHL1.jpg', 'optimization_diagnostic.jpg');
           end
        end
        
        function restorePath (testCase)
           path(testCase.OriginalPath); 
        end
        
    end
    
    methods (Test)
                
%       Test for finding out if worksheets exist
        function testOutputSheetsExist (testCase)
            
            global GRNstruct 
            
%           Check to see if original input worksheets are copied over
            sheet_counter = 1;
            for index = 1:length(GRNstruct.sheets)
                if strcmp(GRNstruct.output_sheets(index), GRNstruct.sheets(sheet_counter))
                    [input_num, input_txt] = xlsread(GRNstruct.inputFile, sheet_counter);
                    [output_num, output_txt] = xlsread(GRNstruct.output_file, sheet_counter);
                    testCase.assertEqual(input_num, output_num);
                    testCase.assertEqual(input_txt, output_txt);
                end
                sheet_counter = sheet_counter + 1;
            end

%           Check if necessary worksheets are outputted
            testCase.assertEqual(any(ismember('network_optimized_weights', GRNstruct.output_sheets)), true);
            testCase.assertEqual(any(ismember('optimization_diagnostics', GRNstruct.output_sheets)), true);
            
            for strain_index = 1:length(GRNstruct.microData)
                testCase.assertEqual(any(ismember([GRNstruct.microData(strain_index).Strain '_log2_optimized_expression'], GRNstruct.output_sheets)), true);
                testCase.assertEqual(any(ismember([GRNstruct.microData(strain_index).Strain '_sigmas'], GRNstruct.output_sheets)), true);
            end
            
            if ~GRNstruct.controlParams.fix_b
               testCase.assertEqual(any(ismember('optimized_threshold_b', GRNstruct.output_sheets)), true); 
            else
               testCase.assertEqual(not(ismember('optimized_threshold_b', GRNstruct.output_sheets)), true);
            end
            
            if ~GRNstruct.controlParams.fix_P
               testCase.assertEqual(any(ismember('optimized_production_rates', GRNstruct.output_sheets)), true); 
            else
               testCase.assertEqual(not(ismember('optimized_production_rates', GRNstruct.output_sheets)), true);
            end
                        
        end
        
%       Test for finding out if the correct numbers are outputted
        function testSigmaValues(testCase)
           global GRNstruct
           for timepoint_index = 1:length(GRNstruct.GRNParams.num_times)
               for strain_index = 1:length(GRNstruct.microData)
                   expected_sigmas = zeros(GRNstruct.GRNParams.num_genes, GRNstruct.GRNParams.num_times);
                   output_sigmas  = xlsread(GRNstruct.output_file, [GRNstruct.microData(strain_index).Strain '_sigmas']);
                   testCase.assertEqual(round(output_sigmas(1,:), 6), round((0.4:0.4:1.6), 6));
                   testCase.assertEqual(round(output_sigmas(2:end,:), 6), expected_sigmas);
               end
           end
        end
        
%       Test if correct simtime is outputted to log2_optimized_expression        
        function testSimTime(testCase)
            global GRNstruct
            for strain_index = 1:length(GRNstruct.microData)
                if GRNstruct.controlParams.simtime(1) == 0
                    testCase.assertEqual(round(GRNstruct.controlParams.simtime, 6), round((0:0.1:2), 6));
                end
                % What if there is no timepoint = 0?
                
            end
        end
         
%       Test if deleted gene actually got deleted
%         function testDeletion(testCase)
%             global GRNstruct
%             for strain_index = 1:length(GRNstruct.microData)
%                 [expression] = xlsread(GRNstruct.output_file, [GRNstruct.microData(strain_index).Strain '_log2_optimized_expression']);
%                 testCase.assertEqual((all(expression(:, 2:end))), true);
%                  disp(expression);
%             end
%         end
        
%       This function will need to be separated eventually into its own file
        function testLSE (testCase)
            global GRNstruct
            GRNstruct = lse(GRNstruct); 
            
            
        end
                
        function testGraphs (testCase)
            global GRNstruct
            
            GRNstruct = graphs(GRNstruct);
            
%           Test if graphs are made only when they're supposed to
            if GRNstruct.controlParams.makeGraphs
                testCase.assertEqual(exist('ACE2.jpg', 'file'), 2);
                testCase.assertEqual(exist('AFT2.jpg', 'file'), 2);
                testCase.assertEqual(exist('CIN5.jpg', 'file'), 2);
                testCase.assertEqual(exist('FHL1.jpg', 'file'), 2);
            else
%               This test will fail since we are calling the graphs
%               routine. Calling just the graphs routine when makeGraphs == 0 yields 
%               graphs with blank pages. We will need to call the graphs
%               function from the output routine but move the if statement
%               to graphs.m and leave the saving of optimization
%               diagnostics outside since we would want that figure
%               every time we run the program
                testCase.assertEqual(exist('ACE2.jpg', 'file'), 0);
                testCase.assertEqual(exist('AFT2.jpg', 'file'), 0);
                testCase.assertEqual(exist('CIN5.jpg', 'file'), 0);
                testCase.assertEqual(exist('FHL1.jpg', 'file'), 0);
            end
            
%           Test if there is an optimization diagnostics image
            testCase.assertEqual(exist('optimization_diagnostic.jpg', 'file'), 2);
        end
        
%       Will need to make a test to see what happens when we estimate param
%         function testEstimation (testCase)
%             global GRNstruct
%             
%             if GRNstruct.controlParams.estimateParams
%                
%             else
%                 
%             end
%             
%         end
    end
    
end