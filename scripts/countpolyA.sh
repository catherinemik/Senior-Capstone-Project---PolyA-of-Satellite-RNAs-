#!/bin/bash
#SBATCH --job-name=countpolyA
#SBATCH --time=0-01:00:00 
#SBATCH --output=countpolyA.tsv
#SBATCH --error=countpolyA.err 
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=2          
#SBATCH --mem=4GB

#Usage: sbatch countpolyA.sh /private/nanopore/seq_tech_center/Ortiz_RNA/christian_basecalled/A549REP1/02_11_25_R004_RNA_KHM13_A549REP1_1_dorado0.9.1_sup5.1.0_inosine_m6A.bam 
#Output: countpolyA.tsv (read_id, strand, polyA_length)

#determines polyA tail length (at 3' end of the sequence)

# --- Input arguments ---
BAM_FILE=$1

if [ -z "$BAM_FILE" ]; then
  echo "Usage: sbatch count_polyA.sh <input.bam>"
  exit 1
fi

# --- Check dependencies ---
command -v samtools >/dev/null 2>&1 || { echo "samtools not found. Load module or install it."; exit 1; }


#bitwise flag 16 is the reverse strand 
samtools view "$BAM_FILE" | awk -v OFS="\t" '{
    read_id = $1
    if (and($2, 16))
        strand = "-"
    else
        strand = "+"
    seq = $10
    print read_id, strand, seq
}' > temp_reads.tsv


# --- Count trailing A’s (polyA tail length) at the 3' end of each sequence---
#loops backwards through the sequence, from the last base to the first 
#increments counter if the  base is A - if the base is not A it immediately breaks

#we are seeing "T tails" from the reverse strand - script needs to account for this 
#“Sliding window” would iterate through each window of base pairs, if a window is under a threshold percentage of consistent A’s, or T’s ⇒ we can say that the polyA tail has ended 
#This gives the script wiggle room in identifying polyA tails

awk -v OFS="\t" '
BEGIN{
    WINDOW = 10                 #window size (base pairs)
    MIN_FRAC = 0.8              #minimum fraction of A/T in window    

}
{
    read_id = $1 
    strand = $2 
    seq = $3 

    n = length(seq)
    tail_len = 0

    #expected tail base depends on strand
    if (strand == "+") tail_base = "A"
    else               tail_base = "T"

    #walk backwards from 3 prime end 
    for ( i = n; i >= 1; i -= WINDOW){
        start = i - WINDOW + 1
        if (start < 1) start = 1

        win_len = i - start + 1
        match = 0

        for (j = start; j <= i; j++){
            if (substr(seq, j, 1) == tail_base)
            match++
        }

        frac = match / win_len

        if (frac >= MIN_FRAC) {
            tail_len += win_len
        } else {
            break
        }
    }

    print read_id, strand, tail_len

}' temp_reads.tsv > countpolyA.tsv 


echo "Done! Results written to countpolyA.tsv"

samtools view /private/nanopore/seq_tech_center/Ortiz_RNA/christian_basecalled/A549REP1/02_11_25_R004_RNA_KHM13_A549REP1_1_dorado0.9.1_sup5.1.0_inosine_m6A.bam | awk -v OFS="\t" '{ if (and($2,16)) s="-"; else s="+"; print $1, s, $10 }' | head
