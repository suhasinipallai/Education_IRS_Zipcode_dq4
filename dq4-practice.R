#install.packages("readxl")
library("readxl")
library(dplyr)


zip_codes_dataset <-read_excel("./data/zip_code_database.xlsx")

#setwd("\Users\Suhasini\gitdir\data-science\data-question-4-data-question-4-savage-squadron\data")
zip_codes
str(zip_codes)
zip_codes %>% 
  filter(state == "TN") %>% 
  group_by(county)  


length_unique_county <- length(unique(zip_codes_dataset_tn$county))
View(length_unique_county)
length(unique(achivement_profile$system_name))  





  
  distinct(primary_city) %>% 
  select(county,primary_city) %>% 
  View()


zip_codes_dataset_tn <- filter(zip_codes_dataset, (!is.na(county) & state == "TN"))
View(zip_codes_dataset_tn)
zip_codes_dataset_tn <- zip_codes_dataset_tn[ -c(2, 3, 5, 6, 7, 9, 11, 12) ]

#to check if there any na values
any(is.na(zip_codes_dataset_tn))
sum(is.na(zip_codes_dataset_tn))
colSums(is.na(zip_codes_dataset_tn))


# Adding in a new col, total_population, which symbolizes a group by county, and sum of the 
# irs_estimated_population_2014
zip_codes_group_by_county <- zip_codes_dataset_tn %>%  
  group_by(county) %>% 
  mutate(total_population = sum(irs_estimated_population_2014)) %>% 
  arrange(desc(total_population)) 

View(zip_codes_group_by_county)
colSums(is.na((zip_codes_group_by_county)))

# Print out structure
str(zip_codes_group_by_county)


#  starting with 2 dataset - irs 

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

any(is.na(irs_2014_dataset))
colSums((is.na(irs_2014_dataset)))

irs_2014_dataset <- irs_2014_dataset %>% 
  drop_na(zip)

colSums((is.na(irs_2014_dataset)))

# Unique zip codes
unique_zip <- unique(irs_2014_dataset$zip)


# For the gross income column, the first row brought back is the "Total" of all gross income categories.
# Since only the first row has "Total", and the remaining rows only have "NA", we want to 
# ultimately replace the NA's with "Total" as well.
na_gross_incomes <- irs_2014_dataset %>% 
  filter(is.na(gross_income))
colSums((is.na(irs_2014_dataset)))

# Since the very first zip references "Total" as the zip, we want to make sure that value is missing
# For every other row
if (nrow(na_gross_incomes) == length(unique_zip) - 1) {
  irs_2014_dataset['gross_income'][is.na(irs_2014_dataset['gross_income'])] <- 'Total'
}
View(irs_2014_dataset)
str(irs_2014_dataset)
colSums((is.na(irs_2014_dataset)))

head(irs_2014_dataset)
tail(irs_2014_dataset)


nrow(na_gross_incomes)
length(unique_zip)
sum(is.na(irs_2014_dataset['gross_income']))


ncol(zip_codes_group_by_county)
names(zip_codes_group_by_county)

#creating a new dataset with selected colms from the zip-codes table

zip_codes_select_col <- zip_codes_group_by_county %>% 
                        select(zip,county,latitude,longitude,irs_estimated_population_2014,total_population)    

zip_codes_select_col

# merging 2 dataset to get the county names of various zipcodes

merged_irs_2014_zip_codes <- merge(irs_2014_dataset,zip_codes_select_col,by="zip")
View(merged_irs_2014_zip_codes)


# reading the  3 dataset

achivement_profile <- read.csv('./data/achievement_profile_data_with_CORE.csv')
str(achivement_profile)

View(achivement_profile)
head(achivement_profile)
tail(achivement_profile)

any(is.na(achivement_profile))
sum(is.na(achivement_profile))
colSums((is.na(achivement_profile)))


#pairs with 2 colns 
pairs(merged_irs_2014_zip_codes[ , 5:6])

pairs(merged_irs_2014_zip_codes[ , 3:4])


# cannot plot bcos of NA's
#plot(merged_irs_2014_zip_codes)

#plot(achivement_profile)


achievement <- dplyr::filter(achivement_profile, grepl('County',system_name))
str(achievement)

unique_county <- unique(zip_codes_dataset_tn$county)

zip <- dplyr::filter(unique_county,grepl('County',county))
str(zip)
