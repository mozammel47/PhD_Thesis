###Importing library
library(ggplot2)
library(DESeq2)

###Loading data
countData <- as.matrix(read.csv(file="vcac_rna_counts_vcac.tsv",sep="\t",row.names="locus_tag"))

###Assigning condition
conditions <- c(rep("control",2), rep("treatment", 3))

###start by running DESeq2 to find differentially expressed genes.

rna.dse <- DESeqDataSetFromMatrix(countData, colData = as.data.frame(conditions), design = ~ conditions)
colData(rna.dse)$conditions <- factor(colData(rna.dse)$conditions,levels=c("control", "treatment"))

## Get a DESeqDataSet object
rna.dse <- DESeq(rna.dse)

##Extracting table

resultsNames(rna.dse) # lists the coefficients
res <- results(rna.dse, name="conditions_treatment_vs_control") 
resLFC <- lfcShrink(rna.dse, coef="conditions_treatment_vs_control", type="apeglm")
write.table(resLFC, file = "vcac_rna_fold-change-table.tsv", sep = "\t")

###PCA Plot
plotPCA(rlog(rna.dse), intgroup="conditions")$data%>%
  ggplot(aes(x = PC1, y = PC2)) + geom_point(size =3, aes(color=conditions), alpha=0.7)+
  labs(x="PC1 (97.0 %)", y="PC2 (2.0 %)")+
  scale_color_manual(values = c("black", "red"),labels = c("wt", expression(italic(Delta*"flrA"))))+
  theme_my_custom()+
  theme(
    legend.position="bottom", legend.title=element_blank(),
    panel.grid = element_blank(),axis.line = element_blank(),
    aspect.ratio = 0.6)
