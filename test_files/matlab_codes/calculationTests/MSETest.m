classdef MSETest < matlab.unittest.TestCase
    properties
       test_dir = [pwd '\..\..\MSE_tests\']
       previous_dir = pwd
       GRNstruct
    end
    
    methods (TestClassSetup)
        function setup (testCase)
           testCase.GRNstruct.inputFile = [testCase.test_dir 'dHAP4_15_gene_network_deletion_added_input_KD_20160126.xlsx'];
           testCase.GRNstruct = readInputSheet(testCase.GRNstruct);
           testCase.GRNstruct = lse(testCase.GRNstruct);
           testCase.GRNstruct.directory = tempdir;
           cd(tempdir);
           output(testCase.GRNstruct); 
        end
    end
    
    methods (TestMethodTeardown)
        function revertPath (testCase)
           cd (testCase.previous_dir);
        end
    end
    
    methods (Test)
        function testMSE (testCase)
            actual_LSE = testCase.GRNstruct.GRNOutput.lse_out;
            MSEs = testCase.GRNstruct.GRNOutput.SSE;
            number_of_strains = size(testCase.GRNstruct.rawExpressionData,2);
            slides_per_strain = zeros(1,number_of_strains);
            number_of_genes = testCase.GRNstruct.GRNParams.num_genes;
            for strain = 1:number_of_strains
                slides_per_strain(strain) = size(testCase.GRNstruct.rawExpressionData(strain).data,2);
                MSEs(:,strain) = MSEs(:,strain)*slides_per_strain(strain);
            end
            
            sum_MSE = sum(sum(MSEs));
            expected_LSE = sum_MSE/(sum(slides_per_strain)*number_of_genes);
            testCase.verifyTrue(abs((actual_LSE - expected_LSE)/expected_LSE) < 0.001);
        end
    end
    
end