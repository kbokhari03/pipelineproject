# pipelineproject
Project for pipeline

Hello! In order to run this pipeline, you just need to call snakemake -c1. I have sample data in the scripts directory. The pipeline will create our report with just those reads in the directory. You need to have biopython, re, os, argparse libraries in python to run this pipeline. You also need bowtie2, spades, kallisto, and NCBI databse installed on your machine to run this.  To clean up the output files once the pipeline is done, just call snakemake --delete-all-ouput -c1 to get rid of all the files. However, you will have to manually delete the betaherpes directory manually. 

The structure of the pipeline repo will have two directories, our reads and scripts. The reads have been trimmed so that it can run faster for testing purposes. The pipeline report for the full reads is Bokhari_PipelienReport.txt. 

I was not able to get the TPM due to running out of time and not being able to get R working. I will learn R over the summer so this doesn't happen again. Thank you Dr. Wheeler for the extension. 