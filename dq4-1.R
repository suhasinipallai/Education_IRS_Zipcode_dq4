install.packages("readxl")
library("readxl")
library(dplyr)


zip_codes_dataset <-read_excel("./data/zip_code_database.xlsx")

#setwd("\Users\Suhasini\gitdir\data-science\data-question-4-data-question-4-savage-squadron\data")
zip_codes
str(zip_codes)
zip_codes %>% 
  filter(state == "TN") %>% 
  group_by(county) %>% 
  distinct(primary_city) %>% 
  select(county,primary_city) %>% 
  View()


zip_codes_dataset_tn <- filter(zip_codes_dataset, (!is.na(county) & state == "TN"))
View(zip_codes_dataset_tn)
zip_codes_dataset_tn <- zip_codes_dataset_tn[ -c(2, 3, 5, 6, 7, 9, 11, 12) ]

# Adding in a new col, total_population, which symbolizes a group by county, and sum of the 
# irs_estimated_population_2014
zip_codes_group_by_county <- zip_codes_dataset_tn %>%  
  group_by(county) %>% 
  mutate(total_population = sum(irs_estimated_population_2014)) %>% 
  arrange(desc(total_population)) %>% 
  View()


# Print out structure
str(zip_codes_group_by_county)

# Save off objects
saveRDS(zip_codes_group_by_county, './r-objects/zip_codes_group_by_county.rds')
write.csv(zip_codes_group_by_county, './r-objects/zip_codes_group_by_county.csv')
