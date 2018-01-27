#!/usr/bin/env Rscript

library("ggplot2") 
library("stringr")
library("gclus")

education_irs_zip <- readRDS('./r-objects/zip_irs_education_df.rds')

remove_outliers <- function(x, na.rm = TRUE, ...) {
  qnt <- quantile(x, probs=c(.0, .8), na.rm = na.rm, ...)
  H <- 1.5 * IQR(x, na.rm = na.rm)
  y <- x
  y[x < (qnt[1] - H)] <- NA
  y[x > (qnt[2] + H)] <- NA
  y
}

find_cor <- function(df, col_name, thresh=0.2) {
  # This function was created to iterate through the columns of a df, 
  # and find the corr between a specific col and every other column
  # that reaches a certain threshold.
  
  df <- Filter(is.numeric, df)
  
  for (i in seq_along(colnames(df))) {
    col <- colnames(df)[i]
    if (col == col_name) next
    
    col_1 <- remove_outliers(df[[col]])
    col_2 <- remove_outliers(df[[col_name]])
    
    col_corr <- cor(col_1, col_2)
    
    if (col_corr > thresh) {
      cpairs(
        df[, c(col_name, col)],
        gap=.5,
        upper.panel=panel.smooth,
        main = paste(col, "/", col_name, "/ Corr: ", col_corr)
      )
    }
  }
}

df = Filter(is.numeric, education_irs_zip)

df = df[complete.cases(df), ]

for (demo in colnames(df)) {
  find_cor(df = df, col_name = demo, thresh = 0.3)
}
