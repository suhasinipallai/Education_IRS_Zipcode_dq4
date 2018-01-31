#!/usr/bin/env Rscript

library("readxl")
library("dplyr")
library("tidyr")

# Pre-determining the column and col indexes that we want to keep. 
column_names <- c('zip', 'gross_income', 'num_dependents', 'adj_gross_income', 'total_income_returns', 'total_income_amount',
                  'agi_salaries_wages_returns', 'agi_salaries_wages_amount', 'farm_returns', 'unemployment_compensation_returns', 'unemployment_compensation_amount',
                  'state_local_income_tax_returns', 'state_local_income_tax_amount', 'state_local_general_sales_returns', 'state_local_general_sales_amount',
                  'real_estate_returns', 'real_estate_amount', 'taxes_paid_returns', 'taxes_paid_amount', 'taxable_income_returns', 'taxable_income_amount',
                  'child_tax_credit_returns', 'child_tax_credit_amount', 'total_tax_payments_returns', 'total_tax_payments_amount', 
                  'tax_due_at_filing_returns', 'tax_due_at_filing_amount', 'overpayments_refunded_returns', 'overpayments_refunded_amount')

columns_to_keep <- c(1, 2, 9, 13:17, 34:36, 60:67, 72, 73, 90, 91, 102, 103, 122:125)

# Read in the data, only keeping the columns defined above, and renaming the columns
irs_2014_dataset <- read_excel('./data/irs/2014-irs.xls', skip = 5)[columns_to_keep]
names(irs_2014_dataset) <- column_names

# We are only interested in the rows where a zip code is available
irs_2014_dataset <- irs_2014_dataset %>% 
  drop_na(zip)

# We know that there is an `na` value in every gross_income subset within the irs dataset
# representing Total
irs_2014_dataset['gross_income'][is.na(irs_2014_dataset['gross_income'])] <- 'Total'

saveRDS(irs_2014_dataset, './r-objects/irs_2014_dataset.rds')
write.csv(irs_2014_dataset, './r-objects/irs_2014_dataset.csv')

irs_2014_dataset_group_by_zip_total_gross_income <- irs_2014_dataset %>% 
  filter(gross_income == 'Total') %>% 
  select(-gross_income)

View(irs_2014_dataset_group_by_zip_total_gross_income)

# 'zip', 'gross_income', 'num_dependents', 'adj_gross_income', 'total_income_returns', 'total_income_amount' 'taxes_paid_returns' 'taxes_paid_amount'
irs_2014_dataset_initial_ds <- irs_2014_dataset_group_by_zip_total_gross_income[c(1:5, 17, 18)]

saveRDS(irs_2014_dataset_initial_ds, './r-objects/irs_2014_dataset_initial_ds.rds')
write.csv(irs_2014_dataset_initial_ds, './r-objects/irs_2014_dataset_initial_ds.csv')