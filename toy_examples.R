### Toy example 1

library(ggplot2)
gene_expression = data.frame(gene = rep(paste0("Gene",seq(1,10)), c(rep(4,10))),
                             sample = rep(paste0("Sample",seq(1,4)),10),
                             group = rep(paste0("Group",seq(1,2)),20),
                             values = rnorm(40))

a = ggplot(data = gene_expression,aes(x=gene,y=values))+
  geom_boxplot()
print(a)
ggsave("Figures/1_toyexample.png",plot = a)
