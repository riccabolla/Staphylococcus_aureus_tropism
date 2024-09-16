#!/bin/bash

source activate kraken

KRAKEN_DB="../kraken_bacteria/"

for file_R1 in *_R1_filtered.fastq.gz; do
   
    file_R2="${file_R1/_R1_/_R2_}"

    sample_name=$(basename "$file_R1" _R1_filtered.fastq.gz)

    kraken2 --db $KRAKEN_DB --threads 4 --paired $file_R1 $file_R2 --report kraken_report/${sample_name}_kraken_report.txt > kraken_output.log 2>&1
done
