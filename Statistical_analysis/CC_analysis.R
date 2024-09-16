# Load required libraries
library(readxl)
library(tidyverse)

# Read and transform data
data_long <- read_xlsx("CC_analysis.xlsx") %>%
  pivot_longer(cols = -c(Source, Total), names_to = "CC", values_to = "Count")

# Plot distribution
ggplot(data_long, aes(x = CC, y = Count, fill = Source)) +
  geom_bar(stat = "identity") +
  facet_wrap(~ Source) +
  theme_classic() +
  scale_y_continuous(expand = c(0,0)) 
ggsave("CC_distribution.jpg", dpi = 300)

# Perform Chi-square tests and adjust p-values
results <- data_long %>%
  group_by(CC) %>%
  summarize(
    p_value = chisq.test(Count, p = Total / sum(Total))$p.value,
    adj_p_value = p.adjust(p_value, method = "fdr")
  )

# Plot Chi-square results
ggplot(results, aes(x = CC, y = -log10(adj_p_value), colour = CC)) +
  geom_point() +
  labs(title = "ChiSqr results") +
  theme_classic()

# Calculate adjusted standardized residuals
adj_standardized_residuals <- data_long %>%
  left_join(results, by = "CC") %>%
  mutate(
    expected = sum(Count) * (Total / sum(Total)),
    adj_std_residual = (Count - expected) / sqrt(expected * (1 - Total / sum(Total)) * (1 - Count / sum(Count)))
  )

# Filter significant associations
significant_associations <- adj_standardized_residuals %>%
  filter(adj_p_value < 0.01) %>%
  select(Source, adj_std_residual, CC)

# Plot significant associations
ggplot(significant_associations, aes(x = Source, y = CC, fill = adj_std_residual)) + 
  geom_tile() +
  scale_fill_gradient2(low = "blue", high = "red") +
  geom_text(aes(label = round(adj_std_residual, 2))) +
  labs(x = "Infection", title = "Correlation results", subtitle = "* P_value < 0.01 (FDR adjusted)") +
  theme_classic() +
  theme(plot.subtitle = element_text(size = 8), plot.title = element_text(hjust = 0.5))
