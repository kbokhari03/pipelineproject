
from Bio import SeqIO #import for our SeqIO
import sys #import for our command line arguments
import argparse #import for our command line argument function
import re

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

listOfRecords = []

with open(infile, "r") as handle:
    for record in SeqIO.parse(handle, "fasta"):
        headerMatch = re.search(r'\[protein_id=([^\]]+)\]', record.description)
        if headerMatch:
            proteinID = headerMatch.group(1)
            listOfRecords.append(">" + proteinID)
        listOfRecords.append(record.seq)
        
        
with open(outfile,"w") as handle:
    for element in listOfRecords:
        handle.write(str(element) + "\n")


