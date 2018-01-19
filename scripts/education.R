library("readr")
library("dplyr")
library("tidyr")

education_df <- read_csv('./data/achievement_profile_data_with_CORE.csv')

education_county_only <- dplyr::filter(education_df, grepl('(C|c)ounty', system_name))

education_county_only <- education_county_only %>% 
  rename(county = system_name)

education_county_only$county <- tolower(education_county_only$county)

View(education_county_only)