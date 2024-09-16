#!/bin/bash


RED='\033[0;31m'
NC='\033[0m' 

source activate bactopia


print_red() {
    echo -e "${RED}\e[1m$1${NC}"
}

print_red "Running bactopia prepare"

bactopia-prepare --path sra_filtered --species "Staphylococcus aureus" --genome-size 2800000 > samples.txt 

print_red "Running Bactopia"

bactopia --samples samples.txt --outdir Results --species "Staphylococcus aureus" --pilon_rounds 1 --cleanup_workdir --genome_size 2800000 --shovill_assembler spades --compliant

print_red "Summarizing data"

bactopia summary --bactopia-path Results --outdir Results/

print_red "Quality control of assembly"

bactopia --wf quast --bactopia Results/ --cleanup_workdir

bactopia --wf busco --bactopia Results/ --cleanup_workdir

print_red "Starting S.aureus specific analysis" 

bactopia --wf staphopiasccmec --bactopia Results/ --cleanup_workdir

bactopia --wf abricate --abricate_db vfdb --bactopia Results/ --cleanup_workdir

bactopia --wf spatyper --bactopia Results/ --cleanup_workdir

conda deactivate