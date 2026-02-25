from Bio import SeqIO
import sys
import argparse

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
infile = arguments.input
outfile = arguments.output




def longestContigFinder(infile):
    returnFinal = []
    longestContig = None
    with open(infile,"r") as handle:
        for record in SeqIO.parse(handle,"fasta"):
            if longestContig is None or len(record.seq) > len(longestContig.seq):
                longestContigDescription = record.description
                longestContigSeq = record.seq
    returnFinal.append(longestContigDescription)
    returnFinal.append(longestContigSeq)
    return returnFinal

with open(outfile, "w") as handle:
    handle.write(">" + str(longestContigFinder(infile)[0]) + "\n" + str(longestContigFinder(infile)[1]))
