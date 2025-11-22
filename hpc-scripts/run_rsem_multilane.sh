#!/bin/sh

RSEM=$HOME/scripts/rsem-calculate-expression.sh
PROJECT_DIR=/home/ochapman/projects/epn-l1cam/shL1CAM-shSHTN1-rnaseq
REF=$HOME/anno/ensembl-113/GRCh38/rsem/Homo_sapiens.GRCh38.113

module use /usr/local/package/modulefiles/
module load star

# Skip the first line and iterate through the rest
tail -n +2 "$PROJECT_DIR/input/samplesheet.csv" | while IFS=',' read -r SAMPLE READ1 READ2 auto; do
	echo "Running RSEM for $SAMPLE"
	R1=$PROJECT_DIR/fastp/${SAMPLE}_1.fq.gz
	R2=$PROJECT_DIR/fastp/${SAMPLE}_2.fq.gz
	test -f $R1 || echo "$R1 does not exist!"
	test -f $R2 || echo "$R2 does not exist!"
	qsub $RSEM --star --star-gzipped-read-file --paired-end --append-names ${R1} ${R2} $REF $SAMPLE
	#break
done
