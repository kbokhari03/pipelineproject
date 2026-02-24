
rule all:
    input:
        "Genome/Genome.zip"

rule getGenomeAndUnzip:
    output:
        file = directory("Genome"),
        finalCheck = "Genome/Genome.zip"
    shell:
        """
        mkdir -p {output.file}
        datasets download genome accession GCF_000845245.1 --include gff3,rna,cds,protein,genome,seq-report --filename {output.finalCheck}
        
        """





rule clean:
    shell:
        "rm -rf Genome/"