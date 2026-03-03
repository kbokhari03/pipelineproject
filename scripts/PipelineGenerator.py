from Bio import SeqIO
import gzip

HCMVgenome = snakemake.input.CodingDomainFile
numberOfCodingDomains = 0

for record in SeqIO.parse(HCMVgenome, "fasta"):
    numberOfCodingDomains += 1


pipelineFile = snakemake.output.pipeline

readsBefore = snakemake.input.readBeforeList
readsAfter = snakemake.input.readsAfterList

searchResults = snakemake.input.searchResultsList
sampleNames = snakemake.params.samples


def countReadsgZ(gZFile):
    with gzip.open(gZFile, "rt") as f:
        return sum(1 for line in f) / 4

def countRegularFastQFile(FastQFile):
    with open(FastQFile, "r") as f:
        return sum(1 for line in f) / 4



with open(pipelineFile, "w") as f:
    f.write(f"The HCMV genome (GCF_000845245.1) has {numberOfCodingDomains}  CDS.\n")
    for name, rdBefore, rdAfter, sResults in zip(sampleNames,readsBefore,readsAfter,searchResults):
        f.write(f"Sample {name} had {countRegularFastQFile(rdBefore)} read pairs before and {countReadsgZ(rdAfter)} read pairs after Bowtie2 filtering\n")
        f.write(f"{name}:\n")
        f.write("sacc\tpident\tlength\tqstart\tqend\tsstart\tsend\tbitscore\tevalue\tstitle\n")
        with open(sResults, "r") as r:
            for line in r:
                f.write(line + "\n")

    






