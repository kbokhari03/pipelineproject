
rule all:
    input:
        "FASTACDs"
        

rule getGenomeAndUnzip:
    output:
        file = directory("Genome"),
        finalCheck = "Genome/Genome.zip"
    shell:
        """
        mkdir -p {output.file}
        datasets download genome accession GCF_000845245.1 --include gff3,rna,cds,protein,genome,seq-report --filename {output.finalCheck}
        
        """

rule UnzipGenome:
    input:
        file = "Genome/Genome.zip"
    output:
        file1 = "Genome/ncbi_dataset/data/GCF_000845245.1/GCF_000845245.1_ViralProj14559_genomic.fna",
        file2 = "Genome/ncbi_dataset/data/GCF_000845245.1/cds_from_genomic.fna"
    shell:
        "unzip {input.file} -d Genome"

rule createFastaFile:
    input:
        file = "Genome/ncbi_dataset/data/GCF_000845245.1/cds_from_genomic.fna"
    output:
        file2 = "FASTACDs"
    shell:
        "python scripts/GetCDS.py --input {input.file} --output {output.file2}"

rule clean:
    shell:
        """
        rm -rf Genome/

        rm FASTACDs
        
        """