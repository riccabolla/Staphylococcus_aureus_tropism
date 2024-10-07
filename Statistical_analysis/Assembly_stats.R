library(readxl)
library(tidyverse)
library(gridExtra)

assembly_data <- read_xlsx("Assembly_summary.xlsx", sheet = "Assembly_stats")

# Table with median and IQR of assembly parameter before filtering low-quality assembly
summary_table_pre <- assembly_data %>%
  summarize(
    Median_Completeness = median(Completeness),
    IQR_Completeness = IQR(Completeness),
    Median_Coverage = median(Coverage),
    IQR_Coverage = IQR(Coverage),
    Median_Contigs = median(Contigs),
    IQR_Contigs = IQR(Contigs)
  )

post_assembly_data <- read_xlsx("Assembly_summary.xlsx", sheet = "Filt_assembly_stats ")

# Table with median and IQR of assembly parameter after filtering low-quality assembly
summary_table_post <- post_assembly_data %>%
  summarize(
    Median_Completeness = median(Completeness),
    IQR_Completeness = IQR(Completeness),
    Median_Coverage = median(Coverage),
    IQR_Coverage = IQR(Coverage),
    Median_Contigs = median(Contigs),
    IQR_Contigs = IQR(Contigs)
  )

filt_assembly_data <- assembly_data %>%
  select(Completeness = `Completeness (%)`, 
         Coverage = `coverage x`, 
         Contigs = assembler_total_contig)

plot_jitter <- function(data, y_value, y_label, title, color) {
  ggplot(data, aes(x = "", y = !!sym(y_value))) +
    geom_jitter(width = 0.2, color = color) +
    theme_classic() +
    theme(plot.title = element_text(hjust = 0.5)) +
    labs(x = "", y = y_label, title = title)
}

completeness_plot <- plot_jitter(filt_assembly_data, "Completeness", "Genome completeness (%)", "Per sample Genome completeness", "#981717")
coverage_plot <- plot_jitter(filt_assembly_data, "Coverage", "Genome Coverage (x)", "Per sample genome coverage", "#2709EC")
contig_plot <- plot_jitter(filt_assembly_data, "Contigs", "Number of contigs (n)", "Per sample number of contigs", "#3701CB")

assembly_plot <- grid.arrange(completeness_plot, coverage_plot, contig_plot, ncol = 3)

ggsave("Assembly_stat.jpg", plot = assembly_plot, dpi = 300)

#OPTIONAL: Plot of all main assembly parameters 

data <- read_xlsx("Assembly_plots_optional.xlsx")
str(data)
data[,2:ncol(data)] <- lapply(data[,2:ncol(data)], as.numeric)
str(data)
data
data_long <- data %>% 
  pivot_longer(cols = -Assembly, names_to = "Assembly parameter", values_to = "val") 

data_long$`Assembly parameter` <- as.factor(data_long$`Assembly parameter`)

quast_lab <- c(
  'annotator_total_CDS' = 'N CDS', 
  '# contigs' = 'N. Contigs', 
  'Largest contig' = 'Largest Alignement', 
  'N50' = 'N50',
  '# predicted genes (unique)' = 'N predicted unique genes', 
  'Total length' = 'Assembly total length',
  'coverage x' = 'Coverage depth', 
  'Completeness (%)' = 'Completeness (%)',
  'Contamination (%)' = 'Contamination (%)' 
)

ggplot(data_long, aes(x=`Assembly parameter`, y=val)) +
  geom_boxplot(outliers = FALSE, width=1, aes(fill= `Assembly parameter`)) +
  geom_jitter(shape=21 ,fill = 'lightgrey', height=0, width=0.1) +
  theme_classic() +
  facet_wrap(~`Assembly parameter`, scales='free_y', labeller = labeller(`Assembly parameter` = quast_lab), ncol=3) +  # Facet by 'type' and control columns
  ylab('') + xlab('') +
  scale_fill_brewer(palette="Set1")+
  theme(
    axis.text.x = element_blank(),  
    axis.ticks.x = element_blank(), 
    text = element_text(size=12),
    strip.text = element_text(size=12))

ggsave('Assembly_param.jpg', dpi = 300, path = 'Plot/') 

