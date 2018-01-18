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
View(irs_2014_dataset)
names(irs_2014_dataset) <- column_names

str(irs_2014_dataset)
#4735 obs , 29 variables
irs_2014_dataset <- irs_2014_dataset %>% 
  filter(!zip==0 & !zip == 99999 ) %>% 
  drop_na(zip)
str(irs_2014_dataset)
View(irs_2014_dataset)

unique_zip <- unique(irs_2014_dataset$zip)
View(unique_zip)


dis_zip <- distinct(irs_2014_dataset,irs_2014_dataset$zip)
View(dis_zip)

            

