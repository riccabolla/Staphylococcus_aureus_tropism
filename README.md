# Staphylococcus_aureus_tropism
This repository is for the Master Thesis in Omics Data Analysis from University of Padova
## Introduction
Tropism, defined as the tendency of a bacteria to spread in specific tissues, has therefore a determinant role in influencing natural history, severity and outcome of invasive infections by S. aureus.   However, very few is known about S. aureus differential tropism, and no specific marker is used as diagnostic and prognostic determinant of invasive and complicated S. aureus infections in clinical practice. This unmet need represents an important gap to fill, to improve prevention, diagnosis, and advancing research efforts to fight S. aureus infections. This preliminary study aims to screen for known and novel genomic determinants associated with S. aureus tropism and virulence, based on available whole genome sequences of S. aureus from public databases.
## Creating folders
First, go to your main directory and create the folders "sra" and "sra_filtered". 
## Set the environment
1) Install [conda](https://conda.io/projects/conda/en/latest/user-guide/install/index.html) 
2) Set the conda environment following the instructions in [conda_env.txt](./script/conda_env.txt)

## Downloading the SRA Files
The analyzed files were downloaded from the following public projects:
1) Bloodstream Infection: [PRJDB11172](https://ddbj.nig.ac.jp/search/entry/bioproject/PRJDB11172) and [PRJNA673382](https://www.ncbi.nlm.nih.gov/bioproject/?term=PRJNA673382)
2) Joint and Bone Infection: [PRJNA765573](https://www.ncbi.nlm.nih.gov/bioproject/?term=PRJNA765573) and [PRJNA784720](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA784720/)
3) Endocarditis: [PRJEB21660](https://www.ebi.ac.uk/ena/browser/view/PRJEB21660)

For the list of downloaded samples look at [sample_list.txt](./sample_list.txt). 
To install the SRA toolkit follow the [instructions](https://www.ncbi.nlm.nih.gov/sra/docs/sradownload/). 
To download the samples, use the "prefetch" function (https://www.ncbi.nlm.nih.gov/sra/docs/sradownload/). 

## From .sra to .fastq
1) Move all downloaded folders containing the .sra files to the folder named "sra". 
2) Go to the "sra" folder and launch [fastqdump.sh](./script/fastqdump.sh).

## Quality control
In the main directory launch [quality.sh](./script/quality.sh).

## Contamination check
1) Go to the sra_filtered folder and launch [kraken.sh](./script/kraken.sh). 
2) The database used for the analysis is kraken_standard_8 (download here: https://benlangmead.github.io/aws-indexes/k2).
3) Rename the folder containing the .k2d file in "kraken_bacteria" 

## WGS analysis
1) The analysis steps have been performed using the [bactopia](https://bactopia.github.io/latest/) tool.
2) Go to the main directory and launch [bactopia.sh](./script/bactopia.sh).

# Statistical Analysis
1) Download the files in the [reference_files](./reference_files/). 
2) Download [Rstudio](https://posit.co/download/rstudio-desktop/)
3) To install all the required packages launch [required_packages.R](./Statistical_analysis/required_packages.R).
4) Create a folder named "Plot" 
## Assembly stats
1) Launch [Assembly_stats.R](./Statistical_analysis/Assembly_stats.R) 
## Clonal Complex analysis
1) Launch [CC_analysis.R](./Statistical_analysis/CC_analysis.R) 
## Virulence genes analysis
1) Launch [Vf_chisqr.R](./Statistical_analysis/Vf_chisqr.R)
2) Launch [Vf_chisqr_Plots.R](./Statistical_analysis/Vf_chisqr_Plots.R)


