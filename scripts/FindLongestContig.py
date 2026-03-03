from Bio import SeqIO #import biopython library 
import sys #import sys for command line args
import argparse #import arg parse for command line args

#function to parse command line arguments
def check_arg(args=None):
    parser = argparse.ArgumentParser(description="<add description of what script does>")
    parser.add_argument("-i", "--input",
    help="input file",
    required=True)
    parser.add_argument("-o", "--output",
    help="output file",
    required=True)
    return parser.parse_args(args)

#retrieve command line arguments
arguments = check_arg(sys.argv[1:])
infile = arguments.input #set input to infile
outfile = arguments.output #set output to outfile



#Funciton to get the longest contig
def longestContigFinder(infile): #function to get longest Contig
    longestContig = None #Initialize variable and set it to None
    with open(infile,"r") as handle: #Open file using with statement
        for record in SeqIO.parse(handle,"fasta"): #Use SeqIO to parse through the record
            if longestContig is None or len(record.seq) > len(longestContig.seq): #If statement to check if current contig is longer that current longest contig (including none)
                longestContig = record #Set longest contig to record
    return longestContig #Return the longest contig as SeqIO 

longestContig = longestContigFinder(infile) #call function on infile and set to variable

with open(outfile, "w") as handle: #open output file
    SeqIO.write(longestContig,handle,"fasta") #write the longest contig to it
