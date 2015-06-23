classdef readInputSheetTest < matlab.unittest.TestCase
    
%     properties
%         OriginalPath
%     end
%     
%     methods (TestMethodSetup)
%         function addToPath (testCase)
%            testCase.OriginalPath = path;
%            p = fileparts(pwd);
%            addpath(fullfile(p, 'sixteen_tests'));
%            path_file_to_test = fileparts(p);
%            addpath(fullfile(path_file_to_test, 'matlab'));
%         end
%     end
%     
%     methods (TestMethodTeardown)
%         
%         function restorePath (testCase)
%            path(testCase.OriginalPath); 
%         end
%     end
    
%     methods (Test)
%        
%         function testReadInputs(testCase)
%             disp(GRNstruct)
%         end
%         
%     end
    
    methods (Test)
        
%       Test to see if input worksheets have correct names
        function testReadInputs (testCase)
            
            global GRNstruct

            GRNstruct.test_file = which(GRNstruct.inputFile);
            [directory, name, ext] = fileparts (GRNstruct.test_file);
            [~, GRNstruct.sheets] = xlsfinfo(GRNstruct.test_file);
            
            GRNstruct = readInputSheet(GRNstruct);
            GRNstruct.output_file = [name '_output' ext];
            [~, GRNstruct.output_sheets] = xlsfinfo(GRNstruct.output_file);
            
%           Check to see if input worksheets exist.  
            sheetNames = {'production_rates', 'degradation_rates', 'wt_log2_expression', 'dcin5_log2_expression', 'network','network_weights', 'optimization_parameters', 'threshold_b', 'wt_log2_optimized_expression', 'optimized_production_rates', 'optimized_threshold_b', 'network_optimized_weights'};
            testCase.assertEqual(any(ismember(GRNstruct.sheets, sheetNames)), true); 
            testCase.assertEqual(any(ismember(GRNstruct.output_sheets, sheetNames)), true); 
           
%           Test for comparing input with corresponding output sheets.
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
            
            
        end
        
%       Test to see if timepoints match
        function testSimTime(testCase)
            
           global GRNstruct
           
           for strain_index = 1:length(GRNstruct.microData)
                testCase.assertEqual(length(GRNstruct.GRNParams.time), length(GRNstruct.microData(strain_index).t));
                for timepoint = 1: length(GRNstruct.GRNParams.time)
                   testCase.assertEqual(GRNstruct.GRNParams.time(timepoint), GRNstruct.microData(strain_index).t(timepoint).t); 
                end
           end
        end
        
        function testNumGenes(testCase)
             global GRNstruct
             
             testCase.assertEqual(GRNstruct.GRNParams.num_genes, 4);
        end
        
    end
    
end