library(readxl)
library(tidyverse)

data <- read_xlsx("checkM.xlsx")
data$Completeness <- as.numeric(data$Completeness)
data$Contamination <- as.numeric(data$Contamination)
data$`Strain heterogeneity` <- as.numeric(data$`Strain heterogeneity`)
str(data$Contamination)
data <- data %>%
  select(Completeness, Contamination, `Strain heterogeneity`, gene_0, gene_1, gene_2,gene_3) %>%
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
            

