library(ComplexHeatmap)
library(circlize)
library(readxl)

data_raw <- read_xlsx("CC_vf_inf_matrix.xlsx")

data <- data_raw[,-1]
data
virulence_matrix <- as.matrix(data[,-c(1:4)]) 
virulence_matrix
cc <- as.character(data$CC)  
cc <- factor(cc, levels = unique(cc))
cc_colors <- structure(
  rainbow(length(levels(cc))),
  names = levels(cc)
)

BSI <- as.factor(data$BSI)
Joint <- as.factor(data$Joint)
Endo <- as.factor(data$Endocarditis)

bsi_colors <- c("0" = "white", "1" = "darkred")
joint_colors <- c("0" = "white", "1" = "purple")
endo_colors <- c("0" = "white", "1" = "orange")

ha_cc <- HeatmapAnnotation(
  ClonalComplex = cc,
  BSI = BSI,
  Joint = Joint,
  Endocarditis = Endo,
  col = list(
    ClonalComplex = cc_colors,
    BSI = bsi_colors,
    Joint = joint_colors,
    Endocarditis = endo_colors
  ),
  which = "column"  
)
presence_absence_colors <-c("white", "blue")

ht <- Heatmap(t(virulence_matrix),  
              name = "Presence/Absence",
              col = presence_absence_colors,
              top_annotation = ha_cc,  
              show_row_dend = TRUE,
              show_column_dend = FALSE,  
              cluster_rows = FALSE, 
              cluster_columns = FALSE,
              show_row_names = TRUE,
              show_column_names = TRUE,
              row_names_side = "left",
              column_names_side = "top"
)


draw(ht)
