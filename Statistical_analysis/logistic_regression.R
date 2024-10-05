library(tidyverse)
library(caret)
library(readxl)
library(pROC)

data <- read_xlsx("BSI_logistic_regression.xlsx")
data$BSI <- as.factor(data$BSI)
run_model_iteration <- function(train_data, test_data) {
  train_control <- trainControl(method = "none")
  
  model <- train(BSI ~ esaC + essC + esxB + fnbB + lukF_PV + sdrD,
                 data = train_data, method = "glm", family = "binomial",
                 trControl = train_control)
  
  predictions <- predict(model, newdata = test_data)
  cm <- confusionMatrix(predictions, test_data$BSI, positive = "1")
  
  predictions_prob <- predict(model, newdata = test_data, type = "prob")
  roc_obj <- roc(test_data$BSI, predictions_prob[, "1"])
  
  list(cm = cm, roc_obj = roc_obj, var_imp = varImp(model)$importance)
}


n_iterations <- 100
metrics <- data.frame(Accuracy = numeric(n_iterations), Sensitivity = numeric(n_iterations), 
                      Specificity = numeric(n_iterations), Kappa = numeric(n_iterations), 
                      AUC = numeric(n_iterations), PPV = numeric(n_iterations), 
                      NPV = numeric(n_iterations))

var_imp_list <- list()
roc_curves <- data.frame()


for (i in 1:n_iterations) {
  set.seed(i)
  
  train_index <- createDataPartition(data$BSI, p = 0.75, list = FALSE)
  train_data <- data[train_index, ]
  test_data <- data[-train_index, ]
  
  results <- run_model_iteration(train_data, test_data)
  
  cm <- results$cm
  roc_obj <- results$roc_obj
  
  metrics[i, ] <- c(cm$overall["Accuracy"], cm$byClass["Sensitivity"], 
                    cm$byClass["Specificity"], cm$overall["Kappa"], 
                    roc_obj$auc, cm$byClass["Pos Pred Value"], cm$byClass["Neg Pred Value"])
  
  var_imp_list[[i]] <- results$var_imp
  roc_curves <- rbind(roc_curves, data.frame(fpr = 1 - roc_obj$specificities, tpr = roc_obj$sensitivities, iteration = i))
}

plot_variable_importance <- function(var_imp_list) {
  if (length(var_imp_list) > 0) {
    all_var_imp <- do.call(cbind, lapply(var_imp_list, function(x) x[, "Overall", drop = FALSE]))
    mean_importance <- apply(all_var_imp, 1, mean)
    
    mean_importance_df <- data.frame(Variable = names(mean_importance), MeanImportance = mean_importance)
    
    ggplot(mean_importance_df, aes(x = reorder(Variable, MeanImportance), y = MeanImportance)) +
      geom_point(color = "black", size = 2) +
      geom_segment(aes(x = Variable, xend = Variable, y = 0, yend = MeanImportance), color = "black", size = 0.5) +
      coord_flip() + theme_classic() + 
      labs(title = "Mean Importance of Variables", x = "Variable", y = "Mean Importance")
  }
}


plot_variable_importance(var_imp_list)
ggsave("mean_var_imp_iterated.jpg", dpi = 300)


metrics_summary <- metrics %>% summarise(across(everything(), list(mean = mean, sd = sd)))
print(metrics_summary)


metrics_long <- metrics %>% pivot_longer(cols = everything(), names_to = "Metric", values_to = "Value")
ggplot(metrics_long, aes(x = Metric, y = Value, fill = Metric)) +
  geom_boxplot() + theme_classic() +
  labs(title = "Boxplots of Model Performance Metrics", subtitle = "Number of iteration: 100 \nMethod: GLM \nFamily: binomial") +
  theme(legend.position = "none")
ggsave("Boxplot_metrics_iterated.jpg", dpi = 300)



ggplot(roc_curves, aes(x = fpr, y = tpr, group = iteration, alpha = 0.1)) +
  geom_line(color = "blue") + 
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "red") +
  theme_classic() +
  labs(title = "ROC Curves Over 100 Iterations", x = "False Positive Rate (1 - Specificity)", y = "True Positive Rate (Sensitivity)")
ggsave("multiple_auc.jpg", dpi = 300)
