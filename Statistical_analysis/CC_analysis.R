library(readxl)
library(tidyverse)

data <- read_xlsx("CC_analysis.xlsx")
data

data_long <- data %>%
  pivot_longer(cols = -c(Source, Total), names_to = "CC", values_to = "Count") 

ggplot(data_long) + 
  geom_bar(mapping = aes(x = CC, y = Count, fill = Source),
           stat = "identity") +
  facet_wrap(~ Source) +
  theme_classic() +
  scale_y_continuous(expand = c(0,0))
ggsave("CC_distribution.jpg", dpi = 300, path = "Plot/")

results <- data_long %>%
  group_by(CC) %>%
  summarize(
    ChiSqTest = list(chisq.test(Count, p = Total / sum(Total))), 
    p_value = map_dbl(ChiSqTest, "p.value"),
    adj_p_value = p.adjust(p_value, method = "fdr")
  )

ggplot(results) +
  geom_point(mapping = aes(x = CC, y = -log10(adj_p_value), colour = CC))+
  labs(title = "ChiSqr results") + 
  theme_classic()
ggsave("CC_chisqr.jpg", dpi = 300, path = "Plot/")

adj_standardized_residuals <- data_long %>%
  left_join(results, by = "CC") %>%
  mutate(
    expected = sum(Count) * (Total / sum(Total)),
    row_prop = Total / sum(Total),
    col_prop = Count / sum(Count),
    adj_std_residual = (Count - expected) / sqrt(expected * (1 - row_prop) * (1 - col_prop))
  )


significant_associations <- adj_standardized_residuals %>%
  filter(adj_p_value < 0.01) %>%
  select(Source, adj_p_value, adj_std_residual, CC)
significant_associations

ggplot(significant_associations) + 
  geom_tile(mapping = aes(x = Source, y = CC, fill = adj_std_residual)) + 
  scale_fill_gradient2(low = "blue", high = "red") + 
  theme_classic() + 
  labs(x = "Infection" ,
       title = "Correlation results", 
       subtitle = "* P_value < 0.01 (FDR adjusted)") +
  geom_text(mapping = aes(x = Source,
                          y = CC,  
                          label = round(adj_std_residual,2))) +
  theme(plot.subtitle = element_text(size = 8.0),
        plot.title = element_text(hjust = 0.5)) 
ggsave("CC_adj_values.jpg", dpi = 300, path = "Plot/")

data2 <- read_xlsx("CC_vf_analysis.xlsx", na = "NA")
data2 <- drop_na(data2)
data2$gene_count <- rowSums(data2[, 5:ncol(data2)] == 1)
median_count <- data2 %>%
  group_by(CC) %>%
  summarise(median_gene_count = median(gene_count),
            IQR_gene_count = IQR(gene_count))

cc_colors <- c("CC1" = "#3734A6", "CC121" = "#4642D3", "CC15" = "#4D49E8", 
               "CC22" = "#5550FF", "CC30" = "#714ED1", "CC45" = "#8C4BA2", 
               "CC5" = "#965BAA", "CC8" = "#B0638A", "CC97" = "#C96A6A")

ggplot(data2, aes(x = CC, y = gene_count, fill = CC)) +
  geom_boxplot() +
  labs(x = "Clonal Complex (CC)", y = "Number of Virulence genes", 
       title = "Gene Presence by CC") +
  theme_classic()+
  scale_y_continuous(limits = c(40,81))+
  scale_fill_manual(values = cc_colors)

ggsave("CC_gene_presence.jpg", dpi = 300, path = "Plot/")
