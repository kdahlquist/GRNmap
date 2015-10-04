classdef outputTest < matlab.unittest.TestCase
    
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
                if GRNstruct.controlParams.simulation_timepoints(1) == 0
                    testCase.assertEqual(round(GRNstruct.controlParams.simulation_timepoints, 6), round((0:0.1:2), 6));
                end
                % What if there is no timepoint = 0?
                
            end
        end
        
%       This function will need to be separated eventually into its own file
        function testLSE (testCase)
            global GRNstruct
            GRNstruct = lse(GRNstruct); 
            
        end
                
        function testGraphs (testCase)
            global GRNstruct
            
            GRNstruct = graphs(GRNstruct);
            
%           Test if graphs are made only when they're supposed to
            if GRNstruct.controlParams.make_graphs
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
            
%             delete([GRNstruct.directory '*.jpg']);
        end
        
    end
    
end