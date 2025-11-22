#!/bin/sh
set -euo pipefail

###########################################
# Run fastp on shEPN samples #
###########################################

# constants
fastp=/home/ochapman/scripts/fastp.sh
PROJECT_DIR=/home/ochapman/projects/epn-l1cam/shL1CAM-shSHTN1-rnaseq

# defaults
INPUT_FILE=$PROJECT_DIR/input/samplesheet.csv
dry_run=false
multilane=false

while [[ $# -gt 0 ]]; do
  case $1 in
    -i|--input) INPUT_FILE="$2"; shift 2 ;;
    --dry-run) dry_run=true; shift ;;
    --multilane) multilane=true; shift ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

# iterate through the sample sheet file
# sample,fastq_1,fastq_2,strandedness
tail -n +2 "$INPUT_FILE" | while IFS=',' read -r SAMPLE F1 F2 auto; do
	echo "Running fastp for experiment ${SAMPLE}"
	R1=$PROJECT_DIR/input/$( basename $F1 )
	R2=$PROJECT_DIR/input/$( basename $F2 )

	if [ "$multilane" = true ]; then
		## hack: get everything after the second-to-last underscore
		## eg AEG588A6_S6_L004_R1_001.fastq.gz --> AEG588A6_S6_L004
		base=$(awk -F'_' '{OFS="_"; if (NF>2) {NF-=2} print}' <<< "$( basename $F1 )")
	else
		base=$SAMPLE
	fi

	params="-i $R1 -I $R2 -o ${base}_1.fq.gz -O ${base}_2.fq.gz \
		--detect_adapter_for_pe --correction --overrepresentation_analysis \
		--trim_poly_g --low_complexity_filter --complexity_threshold 15 --trim_poly_x \
		--json ${base}.json --html ${base}.html --report_title fastp_report_for_${base}"

	if [ "$dry_run" = true ]; then
		echo $params
	else
		qsub $fastp $params
	fi
#	break
done

