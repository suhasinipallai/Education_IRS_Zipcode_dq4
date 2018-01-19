library("readxl")
library("dplyr")

zip_codes_dataset <- read_excel('./data/zip_code_database.xlsx')
attach(zip_codes_dataset)

# We only want TN data
zip_codes_dataset_tn <- filter(zip_codes_dataset, (!is.na(county) & state == "TN"))
zip_codes_dataset_tn <- zip_codes_dataset_tn[ -c(2, 3, 5, 6, 7, 9, 11, 12) ]

zip_codes_dataset_tn$county <- tolower(zip_codes_dataset_tn$county)

# Adding in a new row, total_population, which symbolizes a group by county, and sum of the 
# irs_estimated_population_2014
zip_codes_group_by_county <- zip_codes_dataset_tn %>%  
  group_by(county) %>% 
  mutate(total_population = sum(irs_estimated_population_2014)) %>% 
  ungroup() %>% 
  arrange(desc(total_population))

# Save off all rows from zip codes df with total pop column
saveRDS(zip_codes_group_by_county, './r-objects/zip_codes_group_by_county.rds')
write.csv(zip_codes_group_by_county, './r-objects/zip_codes_group_by_county.csv')

# Create a summary per county of the total population
zip_code_total_population <- zip_codes_dataset_tn %>%  
  group_by(county) %>% 
  summarize(total_population = sum(irs_estimated_population_2014)) %>% 
  ungroup() %>% 
  arrange(desc(total_population)) %>% 
  View()

# Save off the summarized total pop per county
saveRDS(zip_code_total_population, './r-objects/zip_code_total_population.rds')
write.csv(zip_code_total_population, './r-objects/zip_code_total_population.csv')
