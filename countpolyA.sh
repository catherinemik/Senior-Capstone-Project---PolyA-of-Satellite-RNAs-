#!/bin/bash
#SBATCH --job-name=countpolyA
#SBATCH --time=0-01:00:00 
#SBATCH --output=countpolyA.tsv
#SBATCH --error=countpolyA.err 
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=2          
#SBATCH --mem=4GB

#Usage: sbatch countpolyA.sh /private/nanopore/seq_tech_center/Ortiz_RNA/christian_basecalled/A549REP1/02_11_25_R004_RNA_KHM13_A549REP1_1_dorado0.9.1_sup5.1.0_inosine_m6A.bam /private/nanopore/seq_tech_center/Ortiz_RNA/christian/02_11_25_R004_RNA_KHM13_A549REP1/02_11_25_R004_RNA_KHM13_A549REP1_1/
#Output: countpolyA.tsv (read_id, strand, polyA_length)

# --- Input arguments ---
BAM_FILE=$1
POD5_DIR=$2

if [ -z "$BAM_FILE" ] || [ -z "$POD5_DIR" ]; then
  echo "Usage: sbatch count_polyA.sh <input.bam> <pod5_directory>"
  exit 1
fi

# --- Check dependencies ---
command -v samtools >/dev/null 2>&1 || { echo "samtools not found. Load module or install it."; exit 1; }

# --- Find all .pod5 files ---
echo "Searching for .pod5 files in: $POD5_DIR ..."
POD5_LIST=$(find "$POD5_DIR" -type f -name "*.pod5")

if [ -z "$POD5_LIST" ]; then
  echo "No .pod5 files found in $POD5_DIR"
  exit 1
fi

echo "Found the following POD5 files:"
echo "$POD5_LIST" | head

# (Optional) write to file for recordkeeping
echo "$POD5_LIST" > found_pod5_files.txt

# --- Extract read info from BAM ---
# Fields: read_id, strand, sequence
samtools view "$BAM_FILE" | awk '{
    read_id = $1
    strand = ($2 & 16) ? "-" : "+"
    seq = $10
    print read_id "\t" strand "\t" seq
}' > temp_reads.tsv

# --- Count trailing A’s (polyA tail length) ---
awk '{
    seq = $3
    n = length(seq)
    count = 0
    for (i = n; i > 0; i--) {
        if (substr(seq, i, 1) == "A") count++
        else break
    }
    print $1 "\t" $2 "\t" count
}' temp_reads.tsv > countpolyA.tsv

# --- Cleanup ---
rm temp_reads.tsv

echo "Done! Results written to countpolyA.tsv"
echo "POD5 file list saved to found_pod5_files.txt"

