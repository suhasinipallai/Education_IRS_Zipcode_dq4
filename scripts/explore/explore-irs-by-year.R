#!/usr/bin/env Rscript

library("readxl")
library("dplyr")
library("tidyr")

# Read in the data, only keeping the columns defined above, and renaming the columns
col_names <- c('zip', 'gross_income', 'total_income_returns', 'total_income_amount')

irs_2011_dataset <- read_excel('./data/irs/2011-irs-numbers.xls', skip = 5)
names(irs_2011_dataset) <- col_names

View(irs_2011_dataset)


# We are only interested in the rows where a zip code is available
irs_2011_dataset <- irs_2011_dataset %>% 
  drop_na(zip)

# We know that there is an `na` value in every gross_income subset within the irs dataset
# representing Total
irs_2011_dataset['gross_income'][is.na(irs_2011_dataset['gross_income'])] <- 'Total'

View(irs_2011_dataset %>% filter(gross_income == 'Total'))