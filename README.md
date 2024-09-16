# Staphylococcus_aureus_tropism
This repository is for the Master Thesis in Omics Data Analysis from University of Padova
## Introduction
Tropism, defined as the tendency of a bacteria to spread in specific tissues, has therefore a determinant role in influencing natural history, severity and outcome of invasive infections by S. aureus.   However, very few is known about S. aureus differential tropism, and no specific marker is used as diagnostic and prognostic determinant of invasive and complicated S. aureus infections in clinical practice. This unmet need represents an important gap to fill, to improve prevention, diagnosis, and advancing research efforts to fight S. aureus infections. This preliminary study aims to screen for known and novel genomic determinants associated with S. aureus tropism and virulence, based on available whole genome sequences of S. aureus from public databases.
## Fastq Files
The analyzed files were downloaded from the following public projects:
1) Bloodstream Infection: [PRJDB11172](https://ddbj.nig.ac.jp/search/entry/bioproject/PRJDB11172) and [PRJNA673382](https://www.ncbi.nlm.nih.gov/bioproject/?term=PRJNA673382)
2) Joint and Bone Infection: [PRJNA765573](https://www.ncbi.nlm.nih.gov/bioproject/?term=PRJNA765573) and [PRJNA784720](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA784720/)
3) Endocarditis: [PRJEB21660](https://www.ebi.ac.uk/ena/browser/view/PRJEB21660)

For the list of downloaded samples see [sample_list.txt](./sample_list.txt)
To use SRA toolkit look at [SRA_toolkit.txt](./SRA_toolkit.tx)

## Quality control
In your main directory create two folders named "sra" and "sra_filtered". 
Put the fastq files in the sra folder.
In the main directory lunch the quality.sh script present in the [script](./script) folder. 

## Contamination check
To check the contamination go the sra_filtered folder and lunch the kraken.sh script present in the [script](./script)

## WGS analysis
The analysis steps have been performed using the [bactopia](https://bactopia.github.io/latest/) tool.
Go to the sra_filtered folder and lunch bactopia.sh present in the [script](./script)





