from Bio import SeqIO


HCMVgenome = snakemake.input.CodingDomainFile

listIndex = SeqIO.index(HCMVgenome, "fasta")
numberOfCodingDomains = len(listIndex)

pipelineFile = snakemake.ouput.pipeline

readsBefore = snakemake.input.readBeforeList
readsAfter = snakemake.input.readsAfterList




with open(pipelineFile, "w") as f:
    f.write(f"The HCMV genome (GCF_000845245.1) has {numberOfCodingDomains}  CDS.")
    for i in range(len(readsBefore)):
        beforeIndex = len(SeqIO.index(readsBefore[i],"fasta"))
        afterIndex = len(SeqIO.index(readsAfter[i],"fasta"))
        


