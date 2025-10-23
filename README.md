1. polyA counting script - find polyA tail and count how many bases are there 
    shell script:
   -take in bam file, use samtools cut to take out read id, strand information, and sequence 
   bam file: /private/nanopore/seq_tech_center/Ortiz_RNA/christian_basecalled/A549REP1/02_11_25_R004_RNA_KHM13_A549REP1_1_dorado0.9.1_sup5.1.0_inosine_m6A.bam
   pod5's: "find /private/nanopore/seq_tech_center/Ortiz_RNA/christian/02_11_25_R004_RNA_KHM13_A549REP1/02_11_25_R004_RNA_KHM13_A549REP1_1/ -name **.pod5"
   -awk command to count the A's at the end 

2. base calling script - use dorado and pass polyA flag 
-compare the two to say how the prediction is


