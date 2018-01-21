library("dplyr")

# Read in zip codes and irs dataframes created at both
# './scripts/irs.R'
# './scripts/zip-codes.R
zip_codes_df <- readRDS('./r-objects/zip_codes_group_by_county.rds')
irs_df <- readRDS('./r-objects/irs_2014_dataset_initial_ds.rds')

# Merge both irs and zip codes data by zip
zip_codes_irs_df <- merge(zip_codes_df, irs_df, by = 'zip')

# we want each row to represent the county. With that being said, we want to grab the sum and mean
# of the columns specified. 
# We also created the income_per_tax_return column which takes the total income tax amount
# divided by total income returns to produce this field, by county.
zip_codes_irs_df_by_county <- zip_codes_irs_df %>% 
  group_by( county ) %>% 
  summarise(
    
    sum_total_population = sum(total_population),
    sum_num_dependents = sum(num_dependents),
    sum_adj_gross_income = sum(adj_gross_income),
    mean_adj_gross_income = mean(adj_gross_income),
    sum_total_income_returns = sum(total_income_returns),
    sum_total_income_amount = sum(total_income_amount),
    mean_total_income_amount = mean(total_income_amount),
    sum_taxes_paid_returns = sum(taxes_paid_returns),
    sum_taxes_paid_amount = sum(taxes_paid_amount)
    
  ) %>% 
  ungroup() %>% 
  mutate( 
    
    income_per_tax_return = sum_total_income_amount / sum_total_income_returns 
    
  ) %>% 
  select(
    
    county, sum_total_population, sum_total_income_returns, sum_total_income_amount, 
    income_per_tax_return,sum_num_dependents, sum_adj_gross_income, mean_adj_gross_income, 
    mean_total_income_amount, sum_taxes_paid_returns, sum_taxes_paid_amount
    
  ) %>% 
  arrange( desc( county ) )

# Save off df for use later on
saveRDS(zip_codes_irs_df_by_county, './r-objects/zip_codes_irs_df_by_county.rds')
write.csv(zip_codes_irs_df_by_county, './r-objects/zip_codes_irs_df_by_county.csv')
