# IMPORTS
library("dplyr")
library("ggplot2")

irs_2011_2015 <- readRDS('./r-objects/irs_2011_2015.rds')

# #####################################################

# Start with the irs dataset
# For the first graph, we want to create a line graph representing the counties changing income
# over the years.
df_sort <- irs_2011_2015 %>% 
  filter(income_per_tax_return >= 8) %>% 
  select(
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
