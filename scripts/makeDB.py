import os

file_name = "contig.fasta"
db_name = "database"

makeblast_db='makeblastdb -in '+file_name+' -out '+db_name+' -title '+db_name+' -dbtype nucl' 

os.system(makeblast_db)

