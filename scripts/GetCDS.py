
from Bio import SeqIO #import for our SeqIO
import sys #import for our command line arguments
import argparse #import for our command line argument function
import re #import to grab protein ID from fasta heading

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

listOfRecords = [] #create an empty list to store record to write to file

with open(infile, "r") as handle: #open our file
    for record in SeqIO.parse(handle, "fasta"): #parse through fasta file
        headerMatch = re.search(r'\[protein_id=([^\]]+)\]', record.description) #use the re function to grab the protein id, from the description
        if headerMatch: #If there is a match (which there should be, since shell command asked for cds)
            proteinID = headerMatch.group(1) #set protein id using headermatch subslicing
            listOfRecords.append(">" + proteinID) #add hader 
        listOfRecords.append(record.seq) #Add entry to list
        
        
with open(outfile,"w") as handle: #open out file
    for element in listOfRecords: #parse through list of records
        handle.write(str(element) + "\n") #write entry and add new line


