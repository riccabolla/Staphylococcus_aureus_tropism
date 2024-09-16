library(readxl)
library(tidyverse)
library(gridExtra)

assembly_data <- read_xlsx("Assembly_summary.xlsx", sheet = "Assembly_stats")

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

