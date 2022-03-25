############## Volcano Plot ##################  

library(dplyr)
library(ggplot2)
library(ggrepel)

# We read a differential expression signature from the next link
diff_expression <- read.delim("https://zenodo.org/record/2529117/files/limma-voom_luminalpregnant-luminallactate?download=1")

# We keep only the columns that are going to be used: 
diff_expression <- diff_expression[,c("SYMBOL","logFC","P.Value","adj.P.Val")] 

# We set the params used to filter the significant genes. You can change them
params = list(adj.P.Val = 0.05, logFC = 1,top = 10)

# We create a new column that identify Up and down differentially expresed genes
diff_expression %>% 
  arrange(adj.P.Val) %>%
  mutate(up_or_down = ifelse(logFC > params$logFC & adj.P.Val < params$adj.P.Val,"UP",
                                               ifelse(logFC < -params$logFC & adj.P.Val < params$adj.P.Val,
                                                      "DOWN","None"))) -> diff_expression
# We set the color to the factors
color_sel = list("UP" = "firebrick1", "DOWN" = "dodgerblue1", "None" = "black")
# And change the alpha to "None" genes
alpha <- ifelse(diff_expression$up_or_down != "None", 1, 0.25)

# Then we use geom_plot, with logFC in x axis and -log(P.Value) in y axis, coloring by the new column up_or_down
ggplot(diff_expression,aes(x=logFC,y=-log(P.Value),color=up_or_down))+
  geom_point(aes(alpha=alpha),size = 1)+
  theme(panel.background = element_blank(), # Remove the background  
        axis.line = element_line(colour = "black"), # Add axis lines and set them to black 
        legend.position="bottom",
        legend.key = element_rect(colour = "white", fill = NA))+
  scale_color_manual(values = color_sel,limits = c('UP', 'DOWN'),name = "Genes")+ #Introduce the color sets, remove "None" from legend and change the title of the legend
  scale_alpha_continuous(guide="none") #Remove alpha legend

# Now we want to add labels for the 10 most significant genes
ggplot(diff_expression,aes(x=logFC,y=-log(P.Value),color=up_or_down))+
  geom_point(aes(alpha=alpha),size = 1)+
  theme(panel.background = element_blank(),
        axis.line = element_line(colour = "black"),
        legend.position="bottom",
        legend.key = element_rect(colour = "white", fill = NA))+
  scale_color_manual(values = color_sel,limits = c('UP', 'DOWN'),name = "Genes")+
  scale_alpha_continuous(guide="none")+
  geom_text(data=head(diff_expression, params$top), aes(label=SYMBOL),show.legend = FALSE, #With geom_text label the top genes
            size=3)

# Use library ggrepel to improve labelling

ggplot(diff_expression,aes(x=logFC,y=-log(P.Value),color=up_or_down))+
  geom_point(aes(alpha=alpha),size = 1)+
  theme(panel.background = element_blank(),  
        axis.line = element_line(colour = "black"),
        legend.position="bottom",
        legend.key = element_rect(colour = "white", fill = NA))+
  scale_color_manual(values = color_sel,limits = c('UP', 'DOWN'),name = "Genes")+
  scale_alpha_continuous(guide="none")+
  geom_text_repel(data=head(diff_expression, params$top), aes(label=SYMBOL),show.legend = FALSE, #With geom_text_repel label the top genes
                  size=3)

ggsave("Volcano_Plot.png",width = 1500,height = 1200,units = "px")
