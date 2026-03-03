READLIST = ["SRR5660030", "SRR5660033", "SRR5660044", "SRR5660045"] #Our list of reads
EXTENSTIONS = ["_1.fastq","_2.fastq"] #Extension for the fast q files 
INDEXPREFIX = "GenomeIndex" #Variable for our index genome file
NUMBERSASSEMBLY = ["1.fq.gz","2.fq.gz"] #Extensions for our mapped reads file

#Import rule all for our final output, which is the pipeline report
rule all:
    input:
         "PipelineReport.txt"
         
        
#Grab our genome and place in in a file
rule getGenomeAndUnzip:
    output: #Directory of our files and the zip file is what snakemake will check
        file = directory("Genome"),
        finalCheck = "Genome/Genome.zip"
    shell: #Shell command makes our directory and downloads our dataset into the file, include the coding domains
        """
        mkdir -p {output.file}
        datasets download genome accession GCF_000845245.1 --include gff3,rna,cds,protein,genome,seq-report --filename {output.finalCheck}
        
        """

#Unzip genome file
rule UnzipGenome:
    input: #our zipped file is our input
        file = "Genome/Genome.zip"
    output: #gneome assmbly file and our coding domain files
        file1 = "Genome/ncbi_dataset/data/GCF_000845245.1/GCF_000845245.1_ViralProj14559_genomic.fna",
        file2 = "Genome/ncbi_dataset/data/GCF_000845245.1/cds_from_genomic.fna"
    shell: #Shell command unzips file and puts it in genome direcotry
        "unzip {input.file} -d Genome"

rule createFastaFile: #This rule creates our coding domain fasta file
    input: #get coding domain features we already downloaded
        file = "Genome/ncbi_dataset/data/GCF_000845245.1/cds_from_genomic.fna"
    output: #name our final file output
        file2 = "FASTACDs"
    shell: #Pass arguments for script to count it
        "python scripts/GetCDS.py --input {input.file} --output {output.file2}"

rule createGenomeIndex: #Creates genome index with bowtie
    input: #Grab genome assembly
        file = "Genome/ncbi_dataset/data/GCF_000845245.1/GCF_000845245.1_ViralProj14559_genomic.fna"
    output: #Use the multiext function so we don't have to type all the outputs
        multiext("GenomeIndex",".1.bt2",".2.bt2",".3.bt2",".4.bt2",".rev.1.bt2",".rev.2.bt2")
    shell: #shell command to build genome index
        "bowtie2-build {input.file} GenomeIndex"
   
rule createFullGenomeAssembly: #Create our full genome assemble using reads and index
    input: #Grab our reads and genome index, use multiext and prefix variable to specify input
        readFile1 = "reads/{readList}_1.fastq",
        readFile2 = "reads/{readList}_2.fastq",
        indexFile = multiext(INDEXPREFIX,".1.bt2",".2.bt2",".3.bt2",".4.bt2",".rev.1.bt2",".rev.2.bt2")
    output: #output will be sam file and mapped reads 
        samOutput = "{readList}.sam",
        MappedReadsOutput = ["{readList}_mapped_1.fq.gz", "{readList}_mapped_2.fq.gz"]
    shell: #pass shell comand with varaibles 
        "bowtie2 --quiet -x {INDEXPREFIX} -1 {input.readFile1} -2 {input.readFile2} -S {output.samOutput} --al-conc-gz {wildcards.readList}_mapped_%.fq.gz"

rule Spades: #Spades assemble rule
    input: #mapped reads will be used for our input
        mappedRead1 = "{readList}_mapped_1.fq.gz",
        mappedRead2 = "{readList}_mapped_2.fq.gz"
    output: #Create a file for our assembly files, and place our contigs from the assemble in that directory
        file = directory("{readList}_assembly/"),
        contigs = "{readList}_assembly/contigs.fasta"
    shell: #shell command for assembly
        "spades.py -k 127 -t 4 --only-assembler -1 {input.mappedRead1} -2 {input.mappedRead2} -o {output.file}"

rule getLongestContig: #Get our longest contig rule
    input: #grab out contigs from our assemblies
        contig = "{readList}_assembly/contigs.fasta"
    output: #specify output file for longest contigs
        longestContig = "{readList}.fasta"
    shell: #Shell commannd calls script to run it 
        "python scripts/FindLongestContig.py --input {input.contig} --output {output.longestContig}"


rule downloadSearchDB: #Download our database to search against
    output: #file directory for output, and zip file will be in file
        file = directory("Betaherpesvirinae"),
        finalCheck = "Betaherpesvirinae/Genome.zip"
    shell: #make our output directory and shell command 
        """
        mkdir -p {output.file}
        datasets download virus genome taxon Betaherpesvirinae  --include genome --filename {output.finalCheck}
        """

rule UnzipDB: #Unzip our genome to search against
    input: #zip file for our input
        file1 = "Betaherpesvirinae/Genome.zip"
    output: #use our fasta file for our output
        fastaFile = "Betaherpesvirinae/ncbi_dataset/data/genomic.fna"
    shell: #Shell comamand to unzip file
        "unzip {input.file1} -d Betaherpesvirinae"

rule CreateRefDB: #Create reference database using python script
    input: #fasta file for our input of database we want to search
        fastaFile = "Betaherpesvirinae/ncbi_dataset/data/genomic.fna"
    output: #.nsq file so that snakemake knows the database is done
        database = "BetaherpesvirinaeDB/BetaherpesvirinaeDB.nsq"
    shell: #shell command to make database
        "makeblastdb -in {input.fastaFile} -out BetaherpesvirinaeDB/BetaherpesvirinaeDB -title BetaherpesvirinaeDB -dbtype nucl"

rule blastSearch: #Search our database rule
    input: #Query file is our longest contig file, database is what we search against
        db = "BetaherpesvirinaeDB/BetaherpesvirinaeDB.nsq",
        queryFile = "{readList}.fasta"
    output: #Output file is in a text file
        searchResults = "{readList}.txt"
    script: #run script
        "scripts/Search.py"

rule PipelineReport: #final pipeline result generation
    input: #grab our longest contig file, reads before, reads after, and search results text files
        CodingDomainFile = "FASTACDs",
        readBeforeList = expand("reads/{readList}_1.fastq", readList=READLIST),
        readsAfterList = expand("{readList}_mapped_1.fq.gz", readList=READLIST),
        searchResultsList = expand("{readList}.txt", readList=READLIST),
    output: #output files are the pipeline result
        pipeline = "PipelineReport.txt"
    params: #params is going to be our readList, the script will use this to display the name of the read
        samples = READLIST
    script: #run script
        "scripts/PipelineGenerator.py"


rule clean: #This rule is our cleanup rule, but I stopped updating it while working on snakemake, instead I use snakefile delete all output from the shell
    shell:
        """
        rm -rf Genome/

        rm GenomeIndex*

        rm *.sam

        rm *fq.gz

        """