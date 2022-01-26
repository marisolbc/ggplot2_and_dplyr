### Toy example 1

library(ggplot2)
gene_expression = data.frame(gene = rep(paste0("Gene",seq(1,10)), c(rep(4,10))),
                             sample = rep(paste0("Sample",seq(1,4)),10),
                             group = rep(paste0("Group",seq(1,2)),20),
                             value = rnorm(40))

head(gene_expression)
a = ggplot(data = gene_expression,aes(x=gene,y=value))+
  geom_boxplot()
print(a)
ggsave("Figures/1_toyexample.png",plot = a)


### Toy example 2
library(dplyr)
library(reshape2)
library(pasilla)

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
coldata$sample = rownames(coldata)
head(coldata)

gene_expression = melt(cts, varnames=c('gene', 'sample')) %>% full_join(coldata,by="sample")
a = ggplot(data = gene_expression,aes(x=gene,y=value))+
  geom_boxplot()

ggsave("Figures/2_toyexample.png",plot = a)