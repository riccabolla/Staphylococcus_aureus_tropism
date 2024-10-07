library(readxl)
library(tidyverse)

checkm_data <- read_xlsx("checkM.xlsx")
checkm_data[,3:ncol(checkm_data)] <- lapply(checkm_data[,3:ncol(checkm_data)], as.numeric)
checkm_data <- checkm_data %>%
  select(`Bin Id`,Completeness, Contamination, `Strain heterogeneity`, gene_0, gene_1, gene_2,gene_3)
checkm_data_long <- checkm_data %>% 
  pivot_longer(cols = -`Bin Id`, names_to = "CheckM parameter", values_to = "val") 

checkm_lab <- c(
  'Completeness (%)' = 'Completeness (%)',
  'Contamination (%)' = 'Contamination (%)' ,
  'gene_0' = '0 gene copy',
  'gene_1' = '1 gene copies',
  'gene_2' = '2 gene copies',
  'gene_3' = '3 gene copies',
  'Strain heterogeneity' = 'Strain heterogeneity (%)'
)

ggplot(checkm_data_long, aes(x=`CheckM parameter`, y=val)) +
  geom_boxplot(outliers = FALSE, width=1, aes(fill= `CheckM parameter`)) +
  geom_jitter(shape=21 ,fill = 'lightgrey', height=0, width=0.1) +
  theme_classic() +
  facet_wrap(~ `CheckM parameter`, scales='free_y', labeller = labeller(`CheckM parameter` = checkm_lab), ncol=3) +  # Facet by 'type' and control columns
  ylab('') + xlab('') +
  scale_fill_brewer(palette="Set1")+
  theme(
    axis.text.x = element_blank(),  
    axis.ticks.x = element_blank(), 
    text = element_text(size=12),
    strip.text = element_text(size=12))

ggsave('CheckM_plots.jpg', dpi = 300, path = 'Plot/')

checkm_data <- checkm_data %>%
  summarise(median_completeness = median(Completeness),
            IQR_completeness = IQR(Completeness),
            median_contamination = median(Contamination),
            IQR_contamination = IQR(Contamination),
            median_strain = median(`Strain heterogeneity`),
            IQR_strain = IQR(`Strain heterogeneity`),
            median_zero_gene = median(gene_0),
            IQR_zero_gene = IQR(gene_0),
            median_1_gene = median(gene_1),
            IQR_1_gene = IQR(gene_1),
            median_2_gene = median(gene_2),
            IQR_2_gene = IQR(gene_2),
            median_3_gene = median(gene_3),
            IQR_3_gene = IQR(gene_3))
            

