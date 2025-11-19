1. polyA counting script - find polyA tail and count how many bases are there 
    shell script:
   -take in bam file, use samtools cut to take out read id, strand information, and sequence 
   bam file: /private/nanopore/seq_tech_center/Ortiz_RNA/christian_basecalled/A549REP1/02_11_25_R004_RNA_KHM13_A549REP1_1_dorado0.9.1_sup5.1.0_inosine_m6A.bam
   pod5's: "find /private/nanopore/seq_tech_center/Ortiz_RNA/christian/02_11_25_R004_RNA_KHM13_A549REP1/02_11_25_R004_RNA_KHM13_A549REP1_1/ -name **.pod5"
   -awk command to count the A's at the end 

2. base calling script - use dorado and pass polyA flag 
-compare the two to say how the prediction is


Aligning A549 Total RNA and poly(A) enriched data to CHM13. 

1. Generated a fastq file by converting bam file with samtools fastq: 
bam file: /private/nanopore/seq_tech_center/Ortiz_RNA/christian_basecalled/A549REP1/02_11_25_R004_RNA_KHM13_A549REP1_1_dorado0.9.1_sup5.1.0_inosine_m6A.bam

samtools fastq -@ ${THREADS} -T '*' ${BAM} >${FQ}

fastq file: 02_11_25_R004_RNA_KHM13_A549REP1_1_dorado0.9.1_sup5.1.0_inosine_m6A.fastq 
output directory: /private/groups/migalab/cmikhail/Senior-Capstone-Project---PolyA-of-Satellite-RNAs-/polyA_alignments

2. generated a "log" directory (needed to run Julian Menendez' alignment script)
cd /private/groups/migalab/cmikhail/Senior-Capstone-Project---PolyA-of-Satellite-RNAs-/polyA_alignments
mkdir logs 

3. Ran Julian Menendez' alignment script with the following command: 
sbatch /private/groups/migalab/jmmenend/RNA/scripts/dRNA_minimap2_genome.sh --fq 02_11_25_R004_RNA_KHM13_A549REP1_1_dorado0.9.1_sup5.1.0_inosine_m6A.fastq  --ref /private/groups/migalab/jmmenend/references/CHM13/chm13v2.0.fa --outdir /private/groups/migalab/cmikhail/Senior-Capstone-Project---PolyA-of-Satellite-RNAs-/polyA_alignments

4. After aligment successfully finished - looking at HSat2's and HSat3's from chromosome 10 
awk '$1 == "chr10" && $4 ~ /HSat/' chm13v2.0.cenSatv2.1.bed  > chm13v2.0.chr10hSats.bed

5. Using samtools view to subset the  bam file using the cenSat annotation track we just generated
samtools view -L chm13v2.0.chr10hSats.bed -@16 -bh 02_11_25_R004_RNA_KHM13_A549REP1_1_dorado0.9.1_sup5.1.0_inosine_m6A.fastq_chm13v2.0.bam > chr10subset.bam 




