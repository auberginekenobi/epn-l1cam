#!/bin/bash
#$ -l s_vmem=16G
#$ -pe def_slot 4
#$ -j y
#$ -cwd ## output to current directory

# Run fastqc on UTokyo SHIROKANE
# Usage: qsub fastqc.sh file1.fq.gz [file2.fq.gz ...]
# To run with a different number of threads change the the def_slot allocation.

module use /usr/local/package/modulefiles/
module load fastp

if [ $# -eq 0 ]; then
	fastp -h
elif [ -z "$NSLOTS" ]; then
	time ( fastp $@ )
else
	time ( fastp --thread $NSLOTS $@ )
fi
