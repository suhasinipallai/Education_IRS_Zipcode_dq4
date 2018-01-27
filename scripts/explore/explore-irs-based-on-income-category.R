library("dplyr")
library("ggplot2")
library("PerformanceAnalytics")

zip_codes_df <- readRDS('./r-objects/zip_irs_education_df.rds')

zip_codes_df$income_category <- factor(
  zip_codes_df$income_category, 
  levels = c('Low Income', 'Medium Income', 'High Income', 'Very High Income')
)

create_corr_boxplot <- function(df, x, y) {
  df %>% 
    ggplot(
      aes( x = df[[x]], y = df[[y]] )
    ) + 
    geom_boxplot() +
    labs(x = x, y = y)
}

lapply(
  c('Dropout', 'Graduation', 'ACT_Composite', 'Pct_Chronically_Absent', 'Pct_Expelled', 'mean_math', 'mean_science', 'mean_literature'), 
  function(name) { create_corr_boxplot(zip_codes_df, 'income_category', name)}
)

cor_df <- zip_codes_df[ , c(2:7,9:11,15)]
chart.Correlation(cor_df, histogram = T, pch = 19)


