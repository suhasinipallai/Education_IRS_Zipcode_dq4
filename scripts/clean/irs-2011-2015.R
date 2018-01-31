library("dplyr")
library("tidyr")
library("readxl")

#----- irs-2011 

columns_to_keep <- c(1,2,64,65)
irs_2011_dataset <- read_excel('./data/irs/2011-irs.xls',skip=5)[columns_to_keep]

col_names <- c('zip','gross_income','total_income_returns','total_income_amount')
names(irs_2011_dataset) <- col_names

irs_2011_dataset <- irs_2011_dataset %>% 
  drop_na(zip)

irs_2011_dataset['gross_income'][is.na(irs_2011_dataset['gross_income'])] <- 'Total'

irs_2011_dataset$year <- 2011

irs_2011_dataset_gross_income_total <- irs_2011_dataset %>% 
  filter(gross_income == 'Total')

#-total 590 , 4130 entries


#----irs-2012

columns_to_keep <- c(1,2,67,68)
irs_2012_dataset <- read_excel('./data/irs/2012-irs.xls',skip=5)[columns_to_keep]

col_names <- c('zip','gross_income','total_income_returns','total_income_amount')
names(irs_2012_dataset) <- col_names

irs_2012_dataset <- irs_2012_dataset %>% 
  drop_na(zip)

irs_2012_dataset['gross_income'][is.na(irs_2012_dataset['gross_income'])] <- 'Total'

irs_2012_dataset$year <- 2012

irs_2012_dataset_gross_income_total <- irs_2012_dataset %>%
  filter(gross_income == 'Total')

#-total 590 , 4130 entries


#----irs-2013

columns_to_keep <- c(1,2,101,102)
irs_2013_dataset <- read_excel('./data/irs/2013-irs.xls',skip=5)[columns_to_keep]

col_names <- c('zip','gross_income','total_income_returns','total_income_amount')
names(irs_2013_dataset) <- col_names

irs_2013_dataset <- irs_2013_dataset %>% 
  drop_na(zip)

irs_2013_dataset['gross_income'][is.na(irs_2013_dataset['gross_income'])] <- 'Total'

irs_2013_dataset$year <- 2013

irs_2013_dataset_gross_income_total <- irs_2013_dataset %>%
  filter(gross_income == 'Total')

#-total 590 , 4130 entries


#-------irs_2014

columns_to_keep <- c(1,2,114,115)
irs_2014_dataset <- read_excel('./data/irs/2014-irs.xls',skip=5)[columns_to_keep]

col_names <- c('zip','gross_income','total_income_returns','total_income_amount')
names(irs_2014_dataset) <- col_names

irs_2014_dataset <- irs_2014_dataset %>% 
  drop_na(zip)

irs_2014_dataset['gross_income'][is.na(irs_2014_dataset['gross_income'])] <- 'Total'

irs_2014_dataset$year <- 2014

irs_2014_dataset_gross_income_total <- irs_2014_dataset %>%
  filter(gross_income == 'Total')

#-total 590 , 4130 entries


#---- irs -2015 ,n_max = 4712
columns_to_keep <- c(1:2,118:119)

irs_2015_dataset <- read_excel('./data/irs/2015-irs.xls',skip=5)[columns_to_keep]
col_names <- c('zip','gross_income','total_income_returns','total_income_amount')

names(irs_2015_dataset) <- col_names

irs_2015_dataset <- irs_2015_dataset %>% 
  drop_na(zip)

irs_2015_dataset['gross_income'][is.na(irs_2015_dataset['gross_income'])] <- 'Total'

irs_2015_dataset$year <- 2015

irs_2015_dataset_gross_income_total <- irs_2015_dataset %>% 
  filter(gross_income == 'Total')

#-total 590 , 4130 entries

irs_all <- rbind(irs_2011_dataset, irs_2012_dataset) %>% 
  rbind(irs_2013_dataset) %>% 
  rbind(irs_2014_dataset) %>% 
  rbind(irs_2015_dataset)

irs_all_total <- rbind(irs_2011_dataset_gross_income_total, irs_2012_dataset_gross_income_total) %>% 
  rbind(irs_2013_dataset_gross_income_total) %>% 
  rbind(irs_2014_dataset_gross_income_total) %>% 
  rbind(irs_2015_dataset_gross_income_total)

# merging zip_codes_df & irs all to get county info

zip_codes_irs_all_df <- merge(
  irs_all,
  zip_codes_df, 
  by = 'zip'
)

#merging zip_codes_df & irsl_gross_income_ttotal to get county info

zip_codes_irs_gross_income_total_df <- merge(
  irs_all_total,
  zip_codes_df,
  by='zip'
) %>% 
  select(-gross_income)

merge_irs_all_by_county <- zip_codes_irs_gross_income_total_df %>% 
  group_by(county, year) %>% 
  summarise (
    
    sum_total_income_returns  =  sum(total_income_returns),
    sum_total_income_amount   =  sum(total_income_amount),
    mean_total_income_amount  =  mean(total_income_amount)
    
  ) %>% 
  ungroup() %>% 
  mutate(

    income_per_tax_return = sum_total_income_amount / sum_total_income_returns

  ) %>%
  select(

    county, year, sum_total_income_amount, sum_total_income_returns, mean_total_income_amount, income_per_tax_return

  )

# Save off df for use later on
saveRDS(merge_irs_all_by_county, './r-objects/irs_2011_2015.rds')
write.csv(merge_irs_all_by_county, './r-objects/irs_2011_2015.csv')