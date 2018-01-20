library("readr")
library("dplyr")
library("tidyr")

education_df <- read_csv('./data/achievement_profile_data_with_CORE.csv')
View(education_df)

education_county_only <- dplyr::filter(education_df, grepl('(C|c)ounty', system_name))
View(education_county_only)

education_county_only <- education_county_only %>% 
  rename(county = system_name)

#carroll county missing data
#jackson-madison county to be removed 
#m county have 11 instead of 12 (missing madison county)
#so instead of removing jackson-madison county , rename it to madison county as jackson county already exists



education_county_only$county <- tolower(education_county_only$county)

View(education_county_only)

str(education_county_only)
