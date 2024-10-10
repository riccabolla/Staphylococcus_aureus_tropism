library(tidyverse)
library(readxl)
library(ggplot2)
library(DescTools)


data <- read_xlsx("Vf_analysis.xlsx")
gene_variance <- apply(data, 2, var)
genes_no_zero_variance <- which(gene_variance >= 0.01)

gene_names <- names(genes_no_zero_variance)

gene_presence_counts <- data %>%
  
  pivot_longer(cols = -c(Sample, Source), names_to = "Gene", values_to = "Gene_Expression") %>%  # Reshape data
  group_by(Gene, Source) %>%
  summarize(
    Presence_Count = sum(Gene_Expression == 1),
    Absence_Count = sum(Gene_Expression == 0),
    Total_Count = n()
  ) %>%
  mutate(
    Presence_Frequency = Presence_Count / Total_Count,
    Absence_Frequency = Absence_Count / Total_Count
  )

gene_presence_counts

chi_square_results <- data.frame(Gene = character(),
                                 Chi_Squared = numeric(),
                                 Df = integer(),
                                 P_Value = numeric(),
                                 Effect_size = numeric(),
                                 stringsAsFactors = FALSE)


post_hoc_results_list <- list()


for (gene_name in gene_names) {
  
  cont_table <- table(Source = data$Source, Gene = data[[gene_name]])
    
  chi_res <- chisq.test(cont_table)
  
  V <- CramerV(cont_table, bias.correct = TRUE)
    
  chi_square_results <- rbind(chi_square_results, data.frame(
    Gene = gene_name,
    Chi_Squared = as.numeric(chi_res$statistic),
    Df = chi_res$parameter,
    P_Value = chi_res$p.value,
    Effect_size = V
  ))
}  

chi_square_results <- chi_square_results %>%
  mutate(P_value_adj = p.adjust(P_Value, method = "fdr"))

chi_square_results_filtered <- chi_square_results %>%
  filter(P_value_adj <= 0.01 & Effect_size >= 0.15)


for (gene_name in chi_square_results_filtered$Gene) {
  
  cont_table <- table(Source = data$Source , Gene = data[[gene_name]])
  
  expected <- outer(rowSums(cont_table), colSums(cont_table)) / sum(cont_table)
    
  std_residuals <- (cont_table - expected) / sqrt(expected)
    
  adj_std_residuals <- std_residuals * sqrt(chi_res$parameter)
    
  adj_std_residuals_df <- as.data.frame.table(adj_std_residuals, 
                                              responseName = "Adj_Std_Residual") %>%
    rename(Source = Source, Gene_Expression = Gene) %>%
    mutate(Gene = gene_name)  %>%
    left_join(gene_presence_counts %>% filter(Gene == gene_name), 
             by = c("Gene", "Source")) %>%
    select(-Presence_Count, -Absence_Count, -Total_Count) %>% 
    mutate(P_value_adj = chi_square_results$P_value_adj[chi_square_results$Gene == gene_name])
 
  post_hoc_results_list[[gene_name]] <- adj_std_residuals_df
}

final_correlation_list <- lapply(post_hoc_results_list, function(df) {
  df %>%
    filter(Gene_Expression == 1) %>%
    select(Source, 
           Gene, 
           Gene_Expression,
           P_value_adj  , 
           Adj_Std_Residual, 
           Presence_Frequency,
           Absence_Frequency) %>%
    rename(Post_Hoc_Value = Adj_Std_Residual, 
           Pres_freq = Presence_Frequency,
           Abs_freq = Absence_Frequency) 
}) %>%
  bind_rows()

write.csv(final_correlation_list, "final_correlation.csv")

write.csv(chi_square_results, "chi_square_results.csv")

write.csv(chi_square_results_filtered, "chi_square_results_filtered.csv")
