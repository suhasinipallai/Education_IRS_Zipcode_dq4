#!/usr/bin/env Rscript

library("ggplot2") 
library("stringr")
library("reshape2")
library("car")
library("dplyr")

education_df_plus_3 <- readRDS('./r-objects/education_df_plus_3.rds')

# Subset the education data to only contain the act composite, math, science, and lit cols
edu_subjects_act <- education_df_plus_3[, c("ACT_Composite", "mean_math", "mean_science", "mean_literature")]

# Melt the df to be indexed by Act compositea
md_education <- melt(edu_subjects_act, id="ACT_Composite")

scatterplot(
  ACT_Composite ~ value | variable, 
  legend.title = "ACT / Math, Science, Lit",
  xlab = "Avg Subject Scores",
  ylab = "ACT Scores",
  data = md_education, 
  smoother = FALSE, 
  grid = FALSE, 
  frame = FALSE
)

scatterplot(
  ACT_Composite ~ value | variable, 
  legend.title = "ACT / Math, Science, Lit ~ Excluding 0 as Avg",
  labels = md_education,
  xlab = "Avg Subject Scores",
  ylab = "ACT Scores",
  data = md_education %>% filter(value != 0), 
  smoother = FALSE, 
  grid = FALSE, 
  frame = FALSE
)

# Subset the education data to only contain the act composite, math, science, and lit cols
edu_act_dropout_vs_graduation <- education_df_plus_3[, c("ACT_Composite", "Dropout", "Graduation")]

# Melt the df to be indexed by Act composite
md_dropout_graduation_act <- melt(edu_act_dropout_vs_graduation, id="ACT_Composite")


# These plots were made to help visualize the relationship between act
# scores and either dropout or graduation rate
scatterplot(
  ACT_Composite ~ value, 
  legend.title = "ACT / Dropout Pct",
  xlab = paste("Dropout Pct", cor(
    md_dropout_graduation_act$ACT_Composite, 
    md_dropout_graduation_act$value
  )),
  ylab = "ACT Scores",
  data = md_dropout_graduation_act %>% filter(variable == "Dropout"), 
  smoother = FALSE, 
  grid = FALSE, 
  frame = FALSE
)

scatterplot(
  ACT_Composite ~ value, 
  legend.title = "ACT / Graduation Pct",
  xlab = paste("Graduation Pct", cor(
    md_dropout_graduation_act$ACT_Composite, 
    md_dropout_graduation_act$value
  )), 
  ylab = "ACT Scores",
  data = md_dropout_graduation_act %>% filter(variable == "Graduation"), 
  smoother = "loessLine", 
  grid = FALSE, 
  frame = FALSE
)

# Subset the education data to only contain the act composite, math, science, and lit cols
edu_act_vs_core_region <- education_df_plus_3[, c("ACT_Composite", "CORE_region")]

# Melt the df to be indexed by Act composite
md_act_core <- melt(edu_act_vs_core_region, id="ACT_Composite")

par(cex.axis=.5)
boxplot(
  ACT_Composite ~ value,
  data=md_act_core, 
  main="ACT Scores For CORE Regions", 
  ylab="ACT Scores",
  las = 2
)