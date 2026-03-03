import os #import os to pass commands to shell

databaseFastaFile = "pipelineproject/Betaherpesvirinae/ncbi_dataset/data/genomic.fna" #location of fasta file for database building
databaseName = "Betaherpesvirinae" #Name of database

#Shell command, store it to a variable
ncbiDATABASECommand = 'makeblastdb -in '+databaseFastaFile+' -out '+databaseName+' -title '+databaseName+' -dbtype prot' 
#Pass command to shell using os.system
os.system(ncbiDATABASECommand)