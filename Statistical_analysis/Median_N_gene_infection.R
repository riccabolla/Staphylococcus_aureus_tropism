library(readxl)
library(ggplot2)
library(ggsignif)
library(FSA)

data <- read_xlsx("Virulence_analysis.xlsx")
data$Source <- as.factor(data$Source)
str(data)
data$gene_count <- rowSums(data[, 3:ncol(data)] == 1)
median_test <- data %>%
  select(Source, gene_count)
median_test <- data.frame(median_test)
kruskal.test(gene_count ~ Source, data = median_test)
dunnTest(gene_count ~ Source, data = data, method = "bonferroni")


ggplot(data, aes(x = Source, y = gene_count, fill = Source)) +
  geom_boxplot() +
  labs(x = "Infection", y = "Number of Virulence genes",
       title = "Count of virulence genes by type of Infection",
       subtitle = "*     p value < 0.05 \n *** p value < 0.001") +
  theme_classic() +
  scale_y_continuous(limits = c(40, 81)) + 
  ggsignif::geom_signif(
    comparisons = list(c("BSI", "Joint"), c("BSI", "Endocarditis")),
    tip_length = 0.05,
    vjust = -0.5,
    annotations = c("***", "*"),
    y_position = c(73, 78)) +
  theme(plot.subtitle = element_text(size = 7))

ggsave("Infection_count_virulence_genes.jpg", width = 8, height = 8 dpi = 300, path = "Plot/")
