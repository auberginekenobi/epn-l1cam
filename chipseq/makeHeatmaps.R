options(stringsAsFactors = FALSE)

exprMtx <- read.delim("data/mnp12_MC_v3_expr.txt.gz")

annData <- read.delim("data/mnp12_MC_v3_ann.adjusted.txt")

targAnn <- annData[ annData$Group %in% c("EPN_YAP", "EPN_RELA"),,drop=F ]
targMtx <- exprMtx[ , rownames(targAnn)]


dataCheck <- read.delim("data/nonYAP1_DEGs_with_peaks.txt")

selGenes <- unique(dataCheck [ dataCheck$log2FoldChange < 0, "Gene.Name" ])


library(gplots)
library(colorBlindness)
col16 <- Blue2DarkRed12Steps

colOrder <-  c(rownames(targAnn)[targAnn$Group == "EPN_RELA" ],
               rownames(targAnn)[targAnn$Group != "EPN_RELA" ] )
nSamples = summary(as.factor(targAnn$Group))

selColCols <- c(rep("red",nSamples[1]), rep("skyblue",nSamples[2])) # colors for columns

fName <- paste("heatmap_YAP1_vs_ZFTA.ZFTA_peak_genes", format(Sys.time(), "%Y-%m-%d"), "pdf", sep = ".")


pdf(fName, width = 8, height = 10)
heatmap.2(as.matrix(targMtx[selGenes, colOrder]), col = col16,
          Colv = FALSE, Rowv = TRUE, scale = "row",
          trace = "none", dendrogram = "row",
          #cexCol=0.5,
          labCol = FALSE,
          key.title = "",
          main = "Diff expr genes: RELA vs YAP1\n(promoter-TSS)", # heat map title
          #sepwidth=c(0.1,0.1)
          #colRow = cols,
          ColSideColors = selColCols,
          # for PDF
          lwid = c(2,10),
          lhei = c(2,9),
          margins=c(3,7)
          # labelingcexRow = 1, cexCol = 3
)
dev.off()




