library("readr")
library("dplyr")
library("tidyr")
library("stringr")

education_df <- read_csv('./data/achievement_profile_data_with_CORE.csv')

# More detailed stats on districts 
# membership_data <- read_csv('./data/data_2015_membership_school.csv')

education_county_only <- dplyr::filter(education_df, grepl('(C|c)ounty', system_name))

education_county_only <- education_county_only %>% 
  rename(county = system_name)

# From --> gibson county special school district
education_county_only[26, 'county'] <- 'gibson county'

# From Jackson-Madison County
education_county_only[56, 'county'] <- 'madison county'

education_county_only$county <- word(tolower(education_county_only$county), 1)

assign_mean_to_zeros_na <- function(df, colName) {
  df[colName][(is.na(df[colName])) | df[colName] == 0] <- mean(df[[colName]][!0], na.rm = TRUE)
  df
}

# Assign mean of AlgI and AlgII col to NA vals, respectively. We did want to include these additional columns in case the data ever changed. 
# The also considers 0's and diregards them before calculating mean, and replaces them with the mean.
cols_to_convert <- c('AlgI', 'AlgII', 'BioI', 'Chemistry', 'ELA', 'EngI', 'EngII', 'EngIII', 'Math', 'Science')
for (i in seq_along(cols_to_convert)) {
  education_county_only <- assign_mean_to_zeros_na(education_county_only,  cols_to_convert[i])
}

# Create an overall education dataset, creating 3 additional cols calculating the mean of 
# the top 3 subjects: Math, Science, and Literature/English
education_df_plus_3 <- education_county_only %>%
  rowwise() %>%
  mutate( 
    
    mean_math = mean(AlgI, AlgII, Math),
    mean_science = mean(BioI, Chemistry, Science),
    mean_literature = mean(ELA, EngI, EngII, EngIII)
    
  )

# Save off df for use later on
saveRDS(education_df_plus_3, './r-objects/education_df_plus_3.rds')
write.csv(education_df_plus_3, './r-objects/education_df_plus_3.csv')

# Create a subset of the education_df_plus_3 to merge in with the irs/zipcode datasets.
education_merge_irs_zip_subset <- education_df_plus_3[, c(2, 22:31)]

# Save off df for use later on
saveRDS(education_merge_irs_zip_subset, './r-objects/education_merge_irs_zip_subset.rds')
write.csv(education_merge_irs_zip_subset, './r-objects/education_merge_irs_zip_subset.csv')
