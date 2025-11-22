#!/bin/bash
#$ -l s_vmem=8G ## memory per core
#$ -pe def_slot 8 ## cores
#$ -j y ## merge stdout and stderr into single file
#$ -cwd ## output to current directory

# Count RNA-seq reads per gene using RSEM.
# Usage: qsub rsem-calculate-expression.sh [parameters]
# eg. qsub rsem-calculate-expression.sh --alignments --paired-end input.bam $HOME/anno/ensembl-113/rsem/Homo_sapiens.GRCh38.113 samplename

# Installation instructions for RSEM at https://supcom.hgc.jp/internal/q/4379/rsem-%E3%82%92-%E4%BD%BF%E7%94%A8-%E3%81%97%E3%81%9F%E3%81%84%E3%81%A7%E3%81%99?show=4379#q4379

module use /usr/local/package/modulefiles/
module load star

RSEM=~/bin/rsem/1.3.3/bin/rsem-calculate-expression
$RSEM --num-threads $NSLOTS $@
