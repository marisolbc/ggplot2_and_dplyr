gene_expression = data.frame(gene = rep(paste0("Gene",seq(1,10)), c(rep(4,10))),
                             sample = rep(paste0("Sample",seq(1,4)),10),
                             group = rep(paste0("Group",seq(1,2)),20),
                             values = rnorm(40))

library("pasilla") #Bioconductor

pasCts <- system.file("extdata",
                      "pasilla_gene_counts.tsv",
                      package="pasilla", mustWork=TRUE)
pasAnno <- system.file("extdata",
                       "pasilla_sample_annotation.csv",
                       package="pasilla", mustWork=TRUE)
cts <- as.matrix(read.csv(pasCts,sep="\t",row.names="gene_id"))
head(cts)

coldata <- read.csv(pasAnno, row.names=1)
coldata <- coldata[,c("condition","type")]
rownames(coldata) = colnames(cts)
head(coldata)


######## The logical way --> Loop ##########
gene_expression = data.frame(matrix(NA,ncol = 3))[0,]
colnames(gene_expression) = c("sample","gene","value")

for (samplename in colnames(cts)){
  gene_vals = cts[,samplename]
  gene_expression = rbind(gene_expression,data.frame(sample = samplename,gene = rownames(cts),value = gene_vals))
}

coldata$sample = rownames(coldata)
gene_expression = merge(gene_expression,coldata,by="sample")


######## Using Tibble and Dplyr or Reshape2 and Dplyr ##########
library(reshape2)
library(dplyr)
library(tibble)

gene_expression = as.data.frame(cts) %>% 
  rownames_to_column(var = "gene") %>%  
  pivot_longer(cols = rownames(coldata),names_to = "sample",values_to = "value") %>% 
  full_join(coldata,by="sample")

gene_expression = melt(cts, varnames=c('gene', 'sample')) %>% full_join(coldata,by="sample")


### Use this gene expression in toy_example 2

######## gene_expression to cts

cts = gene_expression[,c("gene","sample","value")] %>% pivot_wider(names_from = "sample", values_from = "value") %>%
  column_to_rownames(var = "gene") %>% as.matrix()

cts = dcast(gene_expression, gene ~ sample, value.var = "value") %>%
  column_to_rownames(var = "gene") %>% as.matrix()

