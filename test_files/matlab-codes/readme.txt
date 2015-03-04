This readme contains information on the files in this compressed folder.

The scenario is a four gene network. Two genes are purely self regulated; two others feedback to each other.
The data was created by executing two forward simulations, one with all four and one with a single gene deleted. 
This pair gives us the two data sheets (wt and dcin5).

Input_4_gene_inverse.xls                 	      is the input sheet for the estimation run.
Input_4_gene_inverse_estimation_output_archived.xls   is the output sheet. Name has been changed so that when you run the code, you won't overwrite this file.
Input_4_gene_inverse_estimation_output_archived.mat   is the output matlab binary file. Name has been changed so that when you run the code, you won't overwrite this file.
figure_1, figure_2, and figure_3 are saved output.  once again I have added the phrase _archived to the name.
figure_4 is generated in the output, but there is no saved .jpg file (bug?).

also included is the file Input_4_gene_testing.xlsx, which was used to generate the forward (model-generated) testing data.  In this file, you can see "the right answers" to the estimation problem, in the production_rates and network_weights sheets.  fix_b is set to one, so the b's are not estimated in this example.