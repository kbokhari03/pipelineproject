import os

databaseFastaFile = "pipelineproject/Betaherpesvirinae/ncbi_dataset/data/genomic.fna"
databaseName = "Betaherpesvirinae"

ncbiDATABASECommand = 'makeblastdb -in '+databaseFastaFile+' -out '+databaseName+' -title '+databaseName+' -dbtype prot' 

os.system(ncbiDATABASECommand)