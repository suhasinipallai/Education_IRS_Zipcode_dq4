# Read in education data and irs/zip codes data
# './scripts/education.R'
# './scripts/merge-zip-codes-irs-2014.R'
education <- readRDS('./r-objects/education_merge_irs_zip_subset.rds')
zip_codes_irs_df_by_county <- readRDS('./r-objects/zip_codes_irs_df_by_county.rds')

# Merge both irs and zip codes data by zip
zip_irs_education_df <- merge(education, zip_codes_irs_df_by_county, by = 'county')

View(zip_irs_education_df)

# Save off df for use later on
saveRDS(zip_irs_education_df, './r-objects/zip_irs_education_df.rds')
write.csv(zip_irs_education_df, './r-objects/zip_irs_education_df.csv')
