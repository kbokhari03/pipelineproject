READLIST = ["SampSRR5660030", "SampSRR5660033", "SampSRR5660044", "SampSRR5660045"]
EXTENSTIONS = ["_1.fastq","_2.fastq"]
INDEXPREFIX = "GenomeIndex"
NUMBERSASSEMBLY = ["1.fq.gz","2.fq.gz"]
rule all:
    input:
         expand("{readList}.fasta", readList=READLIST)
        

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

rule createGenomeIndex:
    input:
        file = "Genome/ncbi_dataset/data/GCF_000845245.1/GCF_000845245.1_ViralProj14559_genomic.fna"
    output:
        multiext("GenomeIndex",".1.bt2",".2.bt2",".3.bt2",".4.bt2",".rev.1.bt2",".rev.2.bt2")
    shell:
        "bowtie2-build {input.file} GenomeIndex"
   
rule createFullGenomeAssembly:
    input:
        readFile1 = "reads/{readList}_1.fastq",
        readFile2 = "reads/{readList}_2.fastq",
        indexFile = multiext(INDEXPREFIX,".1.bt2",".2.bt2",".3.bt2",".4.bt2",".rev.1.bt2",".rev.2.bt2")
    output:
        samOutput = "{readList}.sam",
        MappedReadsOutput = ["{readList}_mapped_1.fq.gz", "{readList}_mapped_2.fq.gz"]
    shell:
        "bowtie2 --quiet -x {INDEXPREFIX} -1 {input.readFile1} -2 {input.readFile2} -S {output.samOutput} --al-conc-gz {wildcards.readList}_mapped_%.fq.gz"

rule Spades:
    input:
        mappedRead1 = "{readList}_mapped_1.fq.gz",
        mappedRead2 = "{readList}_mapped_2.fq.gz"
    output:
        file = directory("{readList}_assembly/"),
        contigs = "{readList}_assembly/contigs.fasta"
    shell:
        "spades.py -k 127 -t 4 --only-assembler -1 {input.mappedRead1} -2 {input.mappedRead2} -o {output.file}"

rule getLongestContig:
    input:
        contig = "{readList}_assembly/contigs.fasta"
    output:
        longestContig = "{readList}.fasta"
    shell:
        "python scripts/FindLongestContig.py --input {input.contig} --output {output.longestContig}"


rule clean:
    shell:
        """
        rm -rf Genome/

        rm GenomeIndex*

        rm *.sam

        rm *fq.gz

        """