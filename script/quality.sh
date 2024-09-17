#!/bin/bash	

source activate qcheck

for file in sra/*_R1.fastq.gz; do
    sample_name=$(basename $file _R1.fastq.gz)
    fastp -i $file -I sra/${sample_name}_R2.fastq.gz -o sra_filtered/${sample_name}_R1_filtered.fastq.gz -O sra_filtered/${sample_name}_R2_filtered.fastq.gz -q 30

done
cd sra_filtered/

fastqc *_filtered.fastq.gz 

multiqc .

conda deactivate 

mv *html QC/

done

echo done!

