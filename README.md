GRNmap
======

Gene Regulatory Network modeling and parameter estimation
---
GRNmap uses ordinary differential equations to model the dynamics of "medium-scale" gene regulatory networks.  The program estimates production rates, expression thresholds, and regulatory weights for each transcription factor in the network based on DNA microarray data, and then performs a forward simulation of the dynamics of the network.

There are several options for running the model:
* Sigmoidal or Michaelis-Menten production function
* Estimate parameters or perform a forward simulation only
  * Estimate production rates or fix them to a particular value
  * Estimate expression threholds or fix them to a particular value
* Automatically generate expression plots or not

GRNmap can be run from source code in MATLAB.
Users without a MATLAB license can use the executable to run GRNmap as a stand-alone program.

System Requirements and Compatibility:
* The GRNmap code was developed and tested with MATLAB R2014b; it may not function properly with other versions of MATLAB.
* GRNmap is only compatible with the Windows operating system because of the function it uses to read and write Microsoft Excel spreadsheets. It has only been tested on Windows 7.
* We recommend running GRNmap with a minimum of 8.00 GB of RAM and a 2.40 GHz processor. GRNmap may be compatible with slower systems; the amount of RAM and processor speed will affect the speed with which GRNmap completes the estimation.
