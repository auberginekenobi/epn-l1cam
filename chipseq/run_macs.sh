
RESDIR=/icgc/dkfzlsdf/analysis/dktk/Ependymoma/results/chip_seq_sequencing/p65/bwa
OUTDIR=/icgc/dkfzlsdf/analysis/dktk/Ependymoma/results/chip_seq_sequencing/p65/peaks
WGSDIR=/icgc/dkfzlsdf/analysis/dktk/Ependymoma/results/lcWGS_analysis_pancancer/results_per_pid

for BAMFILE in `find $RESDIR -name "*.rmdup.bam"`
do
    echo $BAMFILE
    SNAME=`echo $BAMFILE |  cut -f 11 -d "/" | cut -f 1 -d "."`
    echo "Processing $SNAME"
    CONTROL=$WGSDIR/$SNAME/alignment/tumor_${SNAME}_merged.mdup.bam
    
    cmd="macs14 -t ${BAMFILE} -c ${CONTROL} -f BAM -g hs -p 1e-9 -n $OUTDIR/tumour-p65_${SNAME}"
    echo $cmd
    $cmd
done






