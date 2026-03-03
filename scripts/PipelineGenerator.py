from Bio import SeqIO #Import biopython 
import gzip #import gzip because we need it for fq.gz files

HCMVgenome = snakemake.input.CodingDomainFile #Store coding domain file as variable
numberOfCodingDomains = 0 #initialize variable for number of coding domains

for record in SeqIO.parse(HCMVgenome, "fasta"): #Parse through coding domain record using SeqIO
    numberOfCodingDomains += 1 #Add one to variable for each record in file


pipelineFile = snakemake.output.pipeline #tell script our final output file

readsBefore = snakemake.input.readBeforeList #our collections of reads before for input
readsAfter = snakemake.input.readsAfterList #Our collection of mapped reads for input

searchResults = snakemake.input.searchResultsList #Our collection of blast result searchs
sampleNames = snakemake.params.samples #Names of our samples


def countReadsgZ(gZFile):#Create a function to count our mapped reads
    with gzip.open(gZFile, "rt") as f: #Open .fq.gz file
        return sum(1 for line in f) / 4 #count number of lines and divide by four to get the records

def countRegularFastQFile(FastQFile): #Create a function to count our initial reads
    with open(FastQFile, "r") as f: #Open .fq files
        return sum(1 for line in f) / 4 #Count number of lines and divide by four to get the number of reads



with open(pipelineFile, "w") as f: #Open our output file
    f.write(f"The HCMV genome (GCF_000845245.1) has {numberOfCodingDomains}  CDS.\n") #Write number of coding domains from input and use f string to call function
    for name, rdBefore, rdAfter, sResults in zip(sampleNames,readsBefore,readsAfter,searchResults): #Zip the sample names, initial reads, mapped reads, and search results in tuple to iterate
        f.write(f"Sample {name} had {countRegularFastQFile(rdBefore)} read pairs before and {countReadsgZ(rdAfter)} read pairs after Bowtie2 filtering\n") #Use f string to write how many inital reads and mapped reads in sample, call function in output area of string
        f.write(f"{name}:\n") #Write sample name header
        f.write("sacc\tpident\tlength\tqstart\tqend\tsstart\tsend\tbitscore\tevalue\tstitle\n") #Write our header table
        with open(sResults, "r") as r: #open our search result file and copy it to output file
            for line in r: #Write line by line
                f.write(line + "\n") #Add new line character

    






