#!/usr/bin/env Rscript

library("ggplot2") 
library("stringr")
library("gclus")

education_df_plus_3 <- readRDS('./r-objects/education_df_plus_3.rds')

education_cols <- c(
  "county", "Pct_Black", "Pct_Hispanic", "Pct_Native_American", 
  "Pct_EL", "Pct_SWD", "Pct_ED", "ACT_Composite", 
  "Pct_Expelled", "Graduation", 
  "mean_math", "mean_science", "mean_literature"
)

education <- education_df_plus_3[education_cols]

for (demo in c("Pct_Black", "Pct_Hispanic", "Pct_Native_American")) {
  name <- regmatches(demo, regexpr("_", demo), invert = TRUE)[[1]][2]
  
  cpairs(
    education[, c(demo, 'mean_math', 'mean_science', 'mean_literature')],
    pch=".", gap=.5,
    upper.panel=panel.smooth,
    main = paste(name, "/ General Math, Science, and Lit")
  )
  
  cpairs(
    education[, c(demo, "Pct_Expelled", "Graduation")],
    pch=".", gap=.5,
    upper.panel=panel.smooth,
    main = paste(name, "/ Expelled vs. Graduation")
  )
  
  cpairs(
    education[, c(demo, "ACT_Composite")],
    pch=".", gap=.5,
    upper.panel=panel.smooth,
    main = paste(name, "/ ACT Scores")
  )
}
