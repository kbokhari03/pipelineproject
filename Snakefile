

rule getGenome:
    output:
        file = "ncbi_dataset.zip"
    shell:
        "datasets download genome accession GCF_000845245.1 --include gff3,rna,cds,protein,genome,seq-report"


rule moveDataSetIntoNewDirectory:
    input:
        "ncbi_dataset.zip"
    output:
        folder = directory("/Genome"),
        file = "ncbi_dataset.zip"
    shell:
        "mkdir {output.directory}"
        "mv {input} {output.directory}"


rule clean:
    shell:
        "rm ncbi_dataset.zip"