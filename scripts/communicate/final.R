# IMPORTS
library("dplyr")
library("ggplot2")
library("stringr")
library("reshape2")
library("car")
library("PerformanceAnalytics")
library("MASS")

irs_2011_2015 <- readRDS('./r-objects/irs_2011_2015.rds')

# #####################################################

# Start with the irs dataset
# For the first graph, we want to create a line graph representing the counties changing income
# over the years.
df_sort <- irs_2011_2015 %>% 
  dplyr::filter(income_per_tax_return >= 8) %>% 
  dplyr::select(
    county, year, income_per_tax_return
  )

df_sort %>% 
  ggplot(
    aes(
      x = year,
      y = income_per_tax_return, 
      group = county, 
      color = county
    )
  ) + geom_line(size = 1.5) + 
  labs(y = "Income Per Tax Return * 1000", x = "Years")

# #####################################################

# We also want to measure the amount of tax returns per year. First, understanding the majority of the dataset,
# then honing in on the top two to recognize growth in Davidson County specifically
ggplot_num_returns <- function(df, range) {
  df_sort_1 <- irs_2011_2015 %>% 
    filter(sum_total_income_returns >= range) %>% 
    select(
      county, year, sum_total_income_returns
    )
  
  df_sort_1 %>% 
    ggplot(
      aes(
        x = year,
        y = sum_total_income_returns, 
        group = county,
        color = county
      )
    ) + geom_line(size = 1.5) + 
    labs(x = "Years", y = "Num of Tax Payers Per Year") +
    scale_y_continuous(labels = scales::comma)  
}

ggplot_num_returns(irs_2011_2015, 20000)
ggplot_num_returns(irs_2011_2015, 200000)

# #####################################################

# Regarding irs dataset from 2011-2015, we also want to show the overall distribution
# between the num of counties and Income per Tax Return
hist(
  df_sort$income_per_tax_return, 
  freq = TRUE,
  col = 'blue',
  border = 'black',
  xlab = 'Household Income Range * 1000',
  ylab = 'Number of Counties',
  main = 'Income Distribution Among TN Counties From 2011 to 2015'
)

# #####################################################
# #####################################################

# EDUCATION

# #####################################################

# IMPORTS

# #####################################################

education_df_plus_3 <- readRDS('./r-objects/education_df_plus_3.rds')
zip_codes_df <- readRDS('./r-objects/zip_irs_education_df.rds')

par(mfrow=c(2, 2))
# One county shows at 100% Graduation, Meigs. Lowest is Shelby
truehist(education_df_plus_3$Graduation)
# The outlier for ACT Composite, is Williamson, Lowest is Lake and Fayette
truehist(education_df_plus_3$ACT_Composite)
# Highest is Shelby, Lowest is Pickett and Meigs
truehist(education_df_plus_3$Dropout)
# Shelby is the highest suspended rate
truehist(education_df_plus_3$Pct_Suspended)

par(mfrow=c(1, 3))
# Williamson is highest, With lowest having multiple. A couple being Cheatham and Putnam
truehist(education_df_plus_3$mean_math)
# Highest being Fentress at 100%, and Williamson at 89%. Lowest being Lake at 25%, and Shelby third lowest
truehist(education_df_plus_3$mean_science)
# Highest is Williamson and Wilson, and lowest at Hancock
truehist(education_df_plus_3$mean_literature)

# #####################################################

# Subset the education data to only contain the act composite, math, science, and lit cols
edu_subjects_act <- education_df_plus_3[, c("ACT_Composite", "mean_math", "mean_science", "mean_literature")]

# Melt the df to be indexed by Act compositea
md_education <- reshape2::melt(edu_subjects_act, id="ACT_Composite")

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
  xlab = "Avg Subject Scores",
  ylab = "ACT Scores",
  data = md_education %>% filter(value != 0), 
  smoother = FALSE, 
  grid = FALSE, 
  frame = FALSE
)

# #####################################################

# Subset the education data to only contain the act composite, math, science, and lit cols
edu_act_dropout_vs_graduation <- education_df_plus_3[, c("ACT_Composite", "Dropout", "Graduation")]

# Melt the df to be indexed by Act composite
md_dropout_graduation_act <- melt(edu_act_dropout_vs_graduation, id="ACT_Composite")


# These plots were made to help visualize the relationship between act
# scores and either dropout or graduation rate
dropout_vs_graduation_scatter <- function(df, legend.title, xlab, filter_on) {
  scatterplot(
    ACT_Composite ~ value, 
    legend.title = legend.title,
    xlab = paste(xlab, cor(
      df$ACT_Composite, 
      df$value
    )),
    ylab = "ACT Scores",
    data = df %>% filter(variable == filter_on), 
    smoother = FALSE, 
    grid = FALSE, 
    frame = FALSE
  )
}

md_dropout_graduation_act %>% 
  dropout_vs_graduation_scatter(legend.title = "ACT / Dropout Pct", xlab = "Dropout Pct", filter_on = "Dropout")

md_dropout_graduation_act %>% 
  dropout_vs_graduation_scatter(legend.title = "ACT / Graduation Pct", xlab = "Graduation Pct", filter_on = "Graduation")

# #####################################################

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

# #####################################################

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

library("dplyr")

irs_2011_2015 <- readRDS('./r-objects/irs_2011_2015.rds')
education_df_plus_3 <- readRDS('./r-objects/education_df_plus_3.rds')
zip_codes_df <- readRDS('./r-objects/zip_irs_education_df.rds')

df_sort <- irs_2011_2015 %>% 
  filter(income_per_tax_return >= 8) %>% 
  select(county, year, income_per_tax_return)

