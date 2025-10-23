#!/bin/bash
DORADO="/private/nanopore/tools/dorado/dorado-1.1.1-linux-x64/bin/dorado"      #point to dorado on mustard
MODEL="/private/nanopore/tools/dorado/models/rna004_130bps_sup@v5.1.0"         #trained preset that dorado works with
WORKDIR=$(pwd)
TEMPDIR="/data/tmp/$(whoami)/dorado-polyA_$(SLURM_JOB_ID)"         
mkdir $TEMPDIR
cd $TEMPDIR
#make a trap clause - if my script fails - delete everything in temp directory 
cleanup(){
    echo "clean"
    rm -rf $TEMPDIR
}
trap cleanup EXIT

#Link pod5 files with find command
for file in $(find /private/nanopore/seq_tech_center/Ortiz_RNA/christian/02_11_25_R004_RNA_KHM13_A549REP1/02_11_25_R004_RNA_KHM13_A549REP1_1/ -name **.pod5); do
    ln -s $ file $(basename $file)
done
#if misnamed file or direcotry exit

#make a temporary directory
#need GPUS for this script
