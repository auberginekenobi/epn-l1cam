# R 3.6.3
library(DiffBind)

# compute analysis
dt <- dba(sampleSheet="RELA_vs_YAP1_DiffBind_config.txt")
dtCounts <- dba.count(dt)


# extract counts 
s1 <- dtCounts$peaks[[1]]
coords <- paste0(s1$Chr,":",s1$Start,"-",s1$End)


peakCounts <- NULL

for (i in 1:length(dtCounts$peaks)) {
    #peakCounts <- cbind(peakCounts, dtCounts$peaks[[i]]$RPKM)
    peakCounts <- cbind(peakCounts, dtCounts$peaks[[i]]$Score)
}

colnames(peakCounts) <- dtCounts$samples$SampleID
rownames(peakCounts) <- coords


peakCounts2 <- log2(peakCounts + 1)
write.table(peakCounts2, "analysisDiffBind/peakCounts_p65.log2TMM.txt", sep = "\t", quote = FALSE )


# additional control for PCA

library(genefilter)
rv <- rowVars(peakCounts2)
idx <- order(-rv)[1:5000] 
pc <- prcomp( t(log2(peakCounts2[idx,] + 1) ))
#pc <- prcomp( t(peakCounts2[idx,] ))
png("analysisDiffBind/PCA_direct_141117_log2TMM_top5K.png")
plot(pc$x[,1], pc$x[,2], cex=1.6,pch =17, col= c(rep("red",5),rep("blue",2)), 
     xlab = "PC1", ylab = "PC2", main = "PCA RELA normalized signal peaks (top 5000) ")
legend("topright", title="Groups ", cex= 0.8,
       legend=c("RELA","YAP1"), fill = c("red","blue") ) 

dev.off()


hMethod = "ward.D2" # preferred
hMethod="ward.D"
hMethod="complete" # default

png("analysisDiffBind/hclust_log2TMM_top5K.png", height = 400, width = 400)
hc <- hclust(dist(t(log2(peakCounts2[idx,]) + 1)), method=hMethod)
plot(hc, labels = colnames(peakCounts2) ,  hang = -1, cex = 0.5,
     main = paste("Cluster dendogram", hMethod, "",length(idx), "peaks"), 
     sub = "",     xlab = "Samples", ylab = "Height" )
dev.off()



# direct analysis

dtCounts <- dba.contrast(dtCounts, categories=DBA_CONDITION,minMembers=2)
dtCounts <- dba.analyze(dtCounts)
resultDB <- dba.report(dtCounts)
resDF <- as.data.frame(resultDB)

write.table(resDF, "analysisDiffBind/p65_cuffDiff_result_full.txt", row.names=F,sep="\t", quote=F)


# overlap with TSS

gtfFile <- "annotations/star_index_gencode19/gencode.v19.annotation.gtf"
annData <- import.gff(gtfFile)
annData <- annData[annData$type == "gene",]


tss <- GRanges( seqnames=as.character(seqnames(annData)),
               IRanges(start=ifelse(as.character(strand(annData))=="+",
               start(annData),end(annData)), width=2000, names=values(annData)$gene_name) )
tssRegions <- shift(tss, -1000)

degGR = GRanges(resDF)
res1 <- findOverlaps(degGR, tssRegions)
resTSS <- cbind( as.data.frame(tssRegions[ subjectHits(res1) ]),
                    resDF[ queryHits(res1) ]

export.bed(resTSS, "analysisDiffBind/p65_cuffDiff_result.TSS_only.txt")















