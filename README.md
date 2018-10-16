[![DOI](https://zenodo.org/badge/24078380.svg)](https://zenodo.org/badge/latestdoi/24078380)

http://kdahlquist.github.io/GRNmap/index.html

# GRNmap:  Gene Regulatory Network modeling and parameter estimation

## About GRNmap
A gene regulatory network (GRN) consists of genes, transcription factors, and the regulatory connections between them that govern the level of expression of mRNA and proteins from those genes. The dynamics of a GRN is how gene expression in the network changes over time. GRNmap (Gene Regulatory Network modeling and parameter estimation) uses ordinary differential equations to model the dynamics of small- to medium-scale GRNs. Using a penalized least squares approach, GRNmap estimates production rates, expression thresholds, and regulatory weights for each transcription factor in the network based on timecourse gene expression data (typically generated by DNA microarrays, but amenable to data from other technologies), and then performs a forward simulation of the dynamics of the network. Our approach is described in the paper, [Dahlquist, K.D., Fitzpatrick, B.G., Camacho, E.T., Entzminger, S.D., and Wanner, N.C. (2015) Parameter Estimation for Gene Regulatory Networks from Microarray Data: Cold Shock Response in Saccharomyces cerevisiae. Bulletin of Mathematical Biology, 77(8), 1457-1492, DOI: 10.1007/s11538-015-0092-6](http://link.springer.com/article/10.1007/s11538-015-0092-6/fulltext.html).

Although originally developed to model GRNs from budding yeast, <i>Saccharomyces cerevisiae</i>, GRNmap can be used with any species for which you have timecourse gene expression data.

There are several options for running GRNmap:
* Sigmoidal or Michaelis-Menten production function
* Estimate parameters or perform a forward simulation only
  * Estimate production rates or fix them to a particular value
  * Estimate expression threholds or fix them to a particular value
  * Automatically perform multiple successive estimation runs for fine tuning of the optimization parameter, alpha
* Automatically generate expression plots or not

GRNmap can be run from source code in MATLAB.
Users without a MATLAB license can use the executable to run GRNmap as a stand-alone program.

### Availability

GRNmap code is available under the open source [BSD license](http://opensource.org/licenses/BSD-3-Clause).

### System Requirements and Compatibility:
* The GRNmap code was developed and tested with MATLAB R2014b; it may not function properly with other versions of MATLAB.
* GRNmap is only compatible with the Windows operating system because of the function it uses to read and write Microsoft Excel spreadsheets. It has only been tested on Windows 7.
* We recommend running GRNmap with a minimum of 8.00 GB of RAM and a 2.40 GHz processor. GRNmap may be compatible with slower systems; the amount of RAM and processor speed will affect the speed with which GRNmap completes the estimation.

### Release Notes

See the [GRNmap About page](https://kdahlquist.github.io/GRNmap/about) for current release notes.

## Documentation

For documentation on how to format the input workbooks and how to interpret the output workbooks, please see the [GRNmap Documentation page](http://kdahlquist.github.io/GRNmap/documentation) or [wiki](https://github.com/kdahlquist/GRNmap/wiki).

### Quick Guide to Getting Started with a Demo Input Workbook

#### Running GRNmap from Code

1. Download the latest version of the GRNmap code as a zipped archive from the [Download page](http://kdahlquist.github.io/GRNmap/downloads) and extract.
2. Launch MATLAB version R2014b and open the file "GRNmap-<version>\matlab\GRNmodel.m".
3. Run GRNmodel.m.
4. When prompted by the Open dialog, select an input Excel workbook.  Demo files are found in the "GRNmap-<version>\data_samples" directory.  
 * The filenames specify whether the production function used is sigmoidal (Sigmoid) or Michelis-Menten (MM), whether parameter estimation followed by a forward simulation will take place (estimation) or just a forward simulation (forward), and whether the workbook is an input or output sample.  For example, the file 21-genes\_50-edges\_Dahlquist-data\_Sigmoid\_estimation.xlsx estimates parameters for a 21-gene, 50-edge network using a sigmoidal production function.
 * GRNmap will display an optimization diagnostics figure when the estimation is running, updating every 100 iterations.
5. When the estimation (or forward simulation) is complete, Microsoft Excel (.xlsx) and MATLAB (.mat) output files will be automatically generated and saved in the same directory as the input file.  If the option "make\_graphs=1" in the optimization\_parameters worksheet, GRNmap will display expression plots for all genes in the network which compares the experimental data to the simulated data, and .jpg files of each expression plot will also be automatically saved in the same directory as the other output files.

#### Installing and Running the GRNmap Executable

1. Download the latest version of the GRNmap executable as a zipped archive from the [Download page](http://kdahlquist.github.io/GRNmap/downloads) and extract.
2. The MATLAB Compiler Runtime (MCR) library version 8.4 is needed to run the GRNmap stand-alone executable.  If you are running GRNmap for the first time, you will need to install MCR.
 * The MCR installer is packaged in the zipped archive.
 * Double-click on the file "MyAppInstaller\_mcr.exe" and follow the instructions to install.  _Note that you will need Administrator privileges to install MCR._
 * You do not need to run the installer again for subsequent runs of GRNmap.
3. Double-click on "GRNmap.exe" to run GRNmap.
4. When prompted by the Open dialog, select an input Excel workbook.  Demo files can be downloaded from the ["data_samples" directory](https://github.com/kdahlquist/GRNmap/tree/master/test_files/data_samples) on the GRNmap GitHub repository.  
 * The filenames specify whether the production function used is sigmoidal (Sigmoid) or Michelis-Menten (MM), whether parameter estimation followed by a forward simulation will take place (estimation) or just a forward simulation (forward), and whether the workbook is an input or output sample.  For example, the file 21-genes\_50-edges\_Dahlquist-data\_Sigmoid\_estimation.xlsx estimates parameters for a 21-gene, 50-edge network using a sigmoidal production function.
 * GRNmap will display an optimization diagnostics figure when the estimation is running, updating every 100 iterations.
5. When the estimation (or forward simulation) is complete, Microsoft Excel (.xlsx) and MATLAB (.mat) output files will be automatically generated and saved in the same directory as the input file.  If the option "make\_graphs=1" in the optimization\_parameters worksheet, GRNmap will display expression plots for all genes in the network which compares the experimental data to the simulated data, and .jpg files of each expression plot will also be automatically saved in the same directory as the other output files.

## Acknowledgments
### People
GRNmap is a project of the Loyola Marymount University Biomathematics Group, headed by Dr. Kam Dahlquist, and Dr. Ben G. Fitzpatrick, in collaboration with Dr. John David N. Dionisio. The forerunner to GRNmap was initiated through a collaboration between Dr. Dahlquist and Dr. Erika T. Camacho, who co-mentored undergraduate Nathan C. Wanner (Applied Mathematics '07). Dr. Ben G. Fitzpatrick joined the project in 2007 as part of the NSF-funded UBM (Interdisciplinary Training for Undergraduates in Biological and Mathematical Sciences; 0634613) Project where he and Dr. Dahlquist co-mentored Stephanie D. (Kuelbs) Entzminger (Applied Mathematics '09). The project took its current form with an NSF-funded RUI award (0921038) to Drs. Dahlquist and Fitzpatrick, enabling work by students Alondra J. Vega (Biomathematics '12), Nicholas A. Rohacz (Biochemistry '13), and Katrina Sherbina (Biomathematics '14), and was christened GRNmap in September 2014 with the work of Juan S. Carrillo (Computer Science, Applied Mathematics '16). Subsequent students joined either the coding or data analysis subgroups. The current coding team includes Trixie Anne M. Roque (Computer Science '17) and Chukwuemeka (Eddie) Azinge (Computer Science '19). The current data analysis team includes Natalie E. Williams (Biology '17), Kristen M. Horstmann (Biomathematics '17), Brandon J. Klein (Biology '18) and Magaret J. O’Neil (Biology '18), with recent contributions by Tessa A. Morris (Biomathematics '16), K. Grace Johnson (Biochemistry '17), and Kayla C. Jackson (Spelman College Mathematics '17). GRNmap is featured as a project in the course Biology 398: Biomathematical Modeling/Mathematics 388: Survey of Biomathematics taught by Drs. Dahlquist and Fitzpatrick.

### Funding
This work is partially supported by NSF award 0921038 (Kam D. Dahlquist and Ben G. Fitzpatrick), the Loyola Marymount University Summer Undergraduate Research Program 2014 (Juan Carrillo) and 2015 (Trixie Roque), the LMU Honors Summer Research Fellowship 2015 (K. Grace Johnson and Natalie Williams), and the LMU Rains Research Assistant Program 2015 (Tessa Morris).

### Contact

To request support or features or report bugs, please go to [GRNmap @ GitHub](https://github.com/kdahlquist/GRNmap).

For all other correspondence, please contact:

**Kam D. Dahlquist, Ph.D.**<br>
Associate Professor<br>
Department of Biology<br>
Loyola Marymount University<br>
Tel: 310-338-7697<br>
kdahlquist@lmu.edu<br>
http://myweb.lmu.edu/kdahlqui<br>

**Ben G. Fitzpatrick, Ph.D.**<br>
Professor<br>
Department of Mathematics<br>
Loyola Marymount University<br>
Tel: 310-338-7892<br>
bfitzpatrick@lmu.edu<br>
http://myweb.lmu.edu/bfitzpatrick<br>
