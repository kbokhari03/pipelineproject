import os

queryFile = snakemake.input.queryFile

searchResults = snakemake.output.searchResults

blastCommand = f"blastn -query {queryFile} -db BetaherpesvirinaeDB/BetaherpesvirinaeDB -out {searchResults} -outfmt '6 sacc pident length qstart qend sstart send bitscore evalue stitle' -max_target_seqs 5 -max_hsps 1"

os.system(blastCommand)


