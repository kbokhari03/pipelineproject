import os #import os to pass shell commands 

queryFile = snakemake.input.queryFile #grab out input file to search

searchResults = snakemake.output.searchResults #This is our output file we will post results to 

#Create shell command in variable
blastCommand = f"blastn -query {queryFile} -db BetaherpesvirinaeDB/BetaherpesvirinaeDB -out {searchResults} -outfmt '6 sacc pident length qstart qend sstart send bitscore evalue stitle' -max_target_seqs 5 -max_hsps 1"
#Use os system to pass command
os.system(blastCommand)


