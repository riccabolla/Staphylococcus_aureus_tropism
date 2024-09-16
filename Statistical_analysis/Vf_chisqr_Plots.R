library(ggplot2)
library(tidyverse)

final_correlation_list <- read.csv("final_correlation.csv", header = T)

chi_square_results <- read.csv("chi_square_results.csv", header = T)

chi_square_results_filtered <- read.csv("chi_square_results_filtered.csv", header = T)

ggplot(chi_square_results, aes(x = Effect_size , 
                               y= -log10(P_value_adj), 
                               colour = Gene)) + 
  geom_point() + 
  theme(legend.text = element_text(size = 7),
        legend.key.size = unit( 1, 'mm'),
        plot.title = element_text(hjust = 0.5))+
  labs(title = "ChiSqr P_value (adjusted) vs Effect Size")+
  theme_classic()
ggsave("P_value_vs_Effect_size.jpg", dpi = 300, path = "Plot/")

ggplot(final_correlation_list) + 
  geom_tile(mapping = aes(x = Source, y = Gene, fill = Post_Hoc_Value)) + 
  scale_fill_gradient2(low = "blue", high = "red") + 
  theme_classic() + 
  labs(x = "Infection" ,
       title = "Correlation results", 
       subtitle = "* P_value < 0.01 (FDR adjusted) \n ** Effect size > 0.2") +
  geom_text(mapping = aes(x = Source,
                          y = Gene,  
                          label = round(Post_Hoc_Value,2))) +
  theme(plot.subtitle = element_text(size = 8.0),
        plot.title = element_text(hjust = 0.5)) 
ggsave("Cor_results_plot", dpi = 300, path = "Plot/")

