'''We want to take in an input tsv file -->

sort data by HSATs, histograms of the different polyA tail lengths

conda activate BME163.conda (old conda environment, has matplotlib and other nice stuff)
python3 findpolyAtails.py -tsv1 /Users/catherinemikhailova/Senior-Capstone-Project---PolyA-of-Satellite-RNAs-/data/countpolyA.chr1.hsat2.tsv -tsv2 /Users/catherinemikhailova/Senior-Capstone-Project---PolyA-of-Satellite-RNAs-/data/countpolyA.chr1.hsat3.tsv -o chr1.polyAcounts.png

 '''

import matplotlib.pyplot as plt
import matplotlib.patches as mplpatches
import matplotlib
import argparse
import random 

parser = argparse.ArgumentParser()
parser.add_argument('--tsvFile1','-tsv1' ,type=str,action='store',help='input tsv file 1')
parser.add_argument('--tsvFile2','-tsv2' ,type=str,action='store',help='input tsv file 2')
parser.add_argument('--outFile','-o' ,type=str,action='store',help='output file')


args = parser.parse_args() 
inFile1 = args.tsvFile1
inFile2 = args.tsvFile2
outFile = args.outFile 


def find_tails(filepath):
    readsDict = {}
    with open(filepath, 'r') as tsv:
        for line in tsv:
            line = line.strip().split('\t')
            read_id = line[0]
            polyA_count = int(line[2])
            if polyA_count > 0:
                readsDict[read_id] = polyA_count
    return readsDict 


reads = find_tails(inFile1)
for x, y in reads.items():
    print(f"{x}: {y} \n")

