classdef lseTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function testLSE (testCase)
            global GRNstruct output_file
            
            [~, output_sheets] = xlsfinfo(output_file);
            
            GRNstruct = lse(GRNstruct);
            disp(GRNstruct);
            
            
        end
            
    end
    
end