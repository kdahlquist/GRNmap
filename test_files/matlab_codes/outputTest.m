classdef outputTest < matlab.unittest.TestCase
    
%     properties
%         OriginalPath
%     end
%     
%     methods (TestMethodSetup)
%         function addToPath (testCase)
%            testCase.OriginalPath = path;
%            p = fileparts(pwd);
%            addpath(fullfile(p, 'sixteen_tests'));
%         end
%     end
%     
%     methods (TestMethodTeardown)
%         function restorePath (testCase)
%            path(testCase.OriginalPath); 
%         end
%     end
    
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
            
            for strain_index = 1:length(GRNstruct.microData)
                testCase.assertEqual(any(ismember([GRNstruct.microData(strain_index).Strain '_log2_optimized_expression'], GRNstruct.output_sheets)), true);
            end
            
            for strain_index = 1:length(GRNstruct.microData)
                testCase.assertEqual(any(ismember([GRNstruct.microData(strain_index).Strain '_sigmas'], GRNstruct.output_sheets)), true);
            end
            
        end
        
%       Test for finding out if the correct numbers are outputted
        function testSigmas(testCase)
           global GRNstruct
           
           for timepoint_index = 1:length(GRNstruct.GRNParams.num_times)
               for strain_index = 1:length(GRNstruct.microData)
                   output_sigmas  = xlsread(GRNstruct.output_file, [GRNstruct.microData(strain_index).Strain '_sigmas']);
               end
               expected_sigmas = zeros(GRNstruct.GRNParams.num_times, length(GRNstruct.microData));
               testCase.assertEqual(expected_sigmas, round(output_sigmas, 6));
           end
        end
        
%       Test if correct simtime is outputted to log2_optimized_expression        
        function testSimTime(testCase)
            global GRNstruct
            for strain_index = 1:length(GRNstruct.microData)
                if GRNstruct.controlParams.simtime(1) == 0
                    testCase.assertEqual(GRNstruct.controlParams.simtime, GRNstruct.microData(strain_index).data(1, 1:end));
                end
                
            end
            
        end
        
        function testLSE (testCase)
           global GRNstruct
         
           GRNstruct = lse(GRNstruct);
        end
        
        function testGraphs (testCase)
            global GRNstruct
            
%             GRNstruct.testGRNstruct = output(GRNstruct);
        end
        
    end
    
end