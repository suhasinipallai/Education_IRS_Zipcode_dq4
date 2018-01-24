#!/usr/bin/env Rscript

library("ggplot2") 
library("stringr")
library("gclus")

education_df_plus_3 <- readRDS('./r-objects/education_df_plus_3.rds')

education_irs_zip <- readRDS('./r-objects/zip_irs_education_df.rds')[, c("county", "income_per_tax_return")]

education_cols <- c(
  "county", "Pct_Black", "Pct_Hispanic", "Pct_Native_American", 
  "Pct_EL", "Pct_SWD", "Pct_ED", "ACT_Composite", 
  "Pct_Expelled", "Graduation", 
  "mean_math", "mean_science", "mean_literature"
)

education <- education_df_plus_3[education_cols]

education_tax_income <- merge(education_irs_zip, education, by = 'county')

find_cor <- function(df, col_name, thresh=0.2) {
  # This function was created to iterate through the columns of a df, 
  # and find the corr between a specific col and every other column
  # that reaches a certain threshold.
  
  df <- Filter(is.numeric, df)
  
  for (i in seq_along(colnames(df))) {
    col <- colnames(df)[i]
    if (col == col_name) next
    
    col_corr <- cor(df[[col]], df[[col_name]])
    
    if (col_corr > thresh) {
      cpairs(
        df[, c(col, col_name)],
        gap=.5,
        upper.panel=panel.smooth,
        main = paste(col, "/", col_name, "/ Corr: ", col_corr)
      )
    }
  }
}

for (demo in c("Pct_Black", "Pct_Hispanic", "Pct_Native_American")) {
  find_cor(df = education_tax_income, col_name = demo, thresh = 0.5)
}
