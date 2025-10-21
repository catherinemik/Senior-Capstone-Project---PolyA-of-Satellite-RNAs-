1. polyA counting script - find polyA tail and count how many bases are there 
    shell script:
   -take in bam file, use samtools cut to take out read id, strand information, and sequence 
   -awk command to count the A's at the end 

2. base calling script - use dorado and pass polyA flag 
-compare the two to say how the prediction is


