'''We want to take in an input tsv file -->

sort data by HSATs, histograms of the different polyA tail lengths

conda activate BME163.conda (old conda environment, has matplotlib and other nice stuff)
python3 polyAhistogram.py -tsv1 /Users/catherinemikhailova/Senior-Capstone-Project---PolyA-of-Satellite-RNAs-/data/countpolyA.chr10.hsat2.tsv -tsv2 /Users/catherinemikhailova/Senior-Capstone-Project---PolyA-of-Satellite-RNAs-/data/countpolyA.chr10.hsat3.tsv -o chr10.polyAcounts.png

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


#parse the tsv files 
def parseTsv(filepath):
    polyA_list = []
    with open(filepath, 'r') as tsv: 
        for line in tsv: 
            line = line.strip().split('\t')
            seq_id = line[0]
            polyA_count = int(line[2])
            polyA_list.append(polyA_count)
    return polyA_list



#plot individual points 
#plan: y-axis is polyA tail length, HSAT2 and HSAT3 dots represented in different colors 
def plotStuff(list1, list2, ax):
    #for HSAT2 we will plot at x=2
    for polyA_count in list1:
        ax.plot(
            2 + random.uniform(-0.1, 0.1),
            polyA_count,
            'o',
            color=(0.384, 0.318, 0.941),
            alpha=0.5,
            markersize=4
        )
    
    #for HSAT3 we will plot at x=4
    for polyA_count in list2:
        ax.plot(
            4 + random.uniform(-0.1, 0.1),
            polyA_count,
            'o',
            color=(0.227, 0.659, 0.486),
            alpha=0.5,
            markersize=4
        )

    
    
    ax.set_title("Poly A Count Plot: Chr10 ")
    ax.set_xlabel("Satellite")
    ax.set_ylabel("polyA tail length (bp)")

    ax.grid(False)
    

def main(): 
    tsvList1 = parseTsv(inFile1)
    tsvList2 = parseTsv(inFile2)

    figureWidth = 4
    figureHeight = 4 
    plt.figure(figsize=(figureWidth, figureHeight))

    margin_x = 0.3 
    margin_y = 0.2 

    MainPanelLeft = figureWidth * (margin_x / 2)
    MainPanelBottom = figureHeight * (margin_y / 2)
    MainPanelWidth = figureWidth * (1 - margin_x)
    MainPanelHeight = figureHeight * (1 - margin_y)

    MainPanel = plt.axes([
        MainPanelLeft / figureWidth,
        MainPanelBottom / figureHeight,
        MainPanelWidth / figureWidth,
        MainPanelHeight / figureHeight
    ])

    plotStuff(tsvList1, tsvList2, MainPanel)

    MainPanel.set_title(MainPanel.get_title(), fontsize=6)
    MainPanel.set_xlabel(MainPanel.get_xlabel(), fontsize=6)
    MainPanel.set_xlim(1,5)
    MainPanel.set_xticks([2, 4])
    MainPanel.set_xticklabels(['HSAT2', 'HSAT3'])

    MainPanel.set_ylabel(MainPanel.get_ylabel(), fontsize=6)
    
    MainPanel.set_ylim(bottom=0)
    MainPanel.tick_params(axis='both', which='major', labelsize=6)

    for spine in MainPanel.spines.values():
        spine.set_linewidth(0.5)


    plt.savefig(outFile, dpi=800)
    plt.close()


main()
#1. we need to figure out the format of the tsv file --> how is it organized? 
#2. start with chr10 --> subset HSAT2's and HSAT3's seperately
#3. make the histogram: plotting polyA tail length in relation to hsat2s and 3's?
