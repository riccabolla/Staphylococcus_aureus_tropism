#!/bin/bash

# Iterate over each folder
for folder in */; do
    
    cd "$folder" || exit

    
    for sra_file in *.sra; do
        if [ -f "$sra_file" ]; then
           
            fastq-dump --split-files --read-filter pass --gzip --skip-technical "$sra_file"
	    mv *_1.fastq.gz ../
            mv *_2.fastq.gz ../	
        fi
    done

    cd ..
done
