library("dplyr")
library("tidyr")
library("readxl")


#----- irs-2011 

columns_to_keep <- c(1,2,64,65)
irs_2011_dataset <- read_excel('./data/irs/2011-irs.xls',skip=5)[columns_to_keep]

col_names <- c('zip','gross_income','total_income_returns_2011','total_income_amount_2011')
names(irs_2011_dataset) <- col_names

irs_2011_dataset <- irs_2011_dataset %>% 
  drop_na(zip)

irs_2011_dataset['gross_income'][is.na(irs_2011_dataset['gross_income'])] <- 'Total'

irs_2011_dataset_gross_income_total <- irs_2011_dataset %>% 
  filter(gross_income == 'Total')

View(irs_2011_dataset)
View(irs_2011_dataset_gross_income_total)

#-total 590 , 4130 entries


#----irs-2012

columns_to_keep <- c(1,2,67,68)
irs_2012_dataset <- read_excel('./data/irs/2012-irs.xls',skip=5)[columns_to_keep]

col_names <- c('zip','gross_income','total_income_returns_2012','total_income_amount_2012')
names(irs_2012_dataset) <- col_names

irs_2012_dataset <- irs_2012_dataset %>% 
  drop_na(zip)

irs_2012_dataset['gross_income'][is.na(irs_2012_dataset['gross_income'])] <- 'Total'

irs_2012_dataset_gross_income_total <- irs_2012_dataset %>%
  filter(gross_income == 'Total')

View(irs_2012_dataset)
View(irs_2012_dataset_gross_income_total)

#-total 590 , 4130 entries


#----irs-2013

columns_to_keep <- c(1,2,101,102)
irs_2013_dataset <- read_excel('./data/irs/2013-irs.xls',skip=5)[columns_to_keep]

col_names <- c('zip','gross_income','total_income_returns_2013','total_income_amount_2013')
names(irs_2013_dataset) <- col_names

irs_2013_dataset <- irs_2013_dataset %>% 
  drop_na(zip)

irs_2013_dataset['gross_income'][is.na(irs_2013_dataset['gross_income'])] <- 'Total'

irs_2013_dataset_gross_income_total <- irs_2013_dataset %>%
  filter(gross_income == 'Total')

View(irs_2013_dataset)
View(irs_2013_dataset_gross_income_total)

#-total 590 , 4130 entries



#-------irs_2014

columns_to_keep <- c(1,2,114,115)
irs_2014_dataset <- read_excel('./data/irs/2014-irs.xls',skip=5)[columns_to_keep]

col_names <- c('zip','gross_income','total_income_returns_2014','total_income_amount_2014')
names(irs_2014_dataset) <- col_names

irs_2014_dataset <- irs_2014_dataset %>% 
  drop_na(zip)

irs_2014_dataset['gross_income'][is.na(irs_2014_dataset['gross_income'])] <- 'Total'

irs_2014_dataset_gross_income_total <- irs_2014_dataset %>%
  filter(gross_income == 'Total')

View(irs_2014_dataset)
View(irs_2014_dataset_gross_income_total)

#-total 590 , 4130 entries

#---- irs -2015 ,n_max = 4712
columns_to_keep <- c(1:2,118:119)

irs_2015_dataset <- read_excel('./data/irs/2015-irs.xls',skip=5)[columns_to_keep]
col_names <- c('zip','gross_income','total_income_returns_2015','total_income_amount_2015')

names(irs_2015_dataset) <- col_names

irs_2015_dataset <- irs_2015_dataset %>% 
  drop_na(zip)


irs_2015_dataset['gross_income'][is.na(irs_2015_dataset['gross_income'])] <- 'Total'

View(irs_2015_dataset)

irs_2015_dataset_gross_income_total <- irs_2015_dataset %>% 
  filter(gross_income == 'Total')

View(irs_2015_dataset_gross_income_total)
View(irs_2015_dataset)


#-total 590 , 4130 entries


?reduce

irs_11_12 <- merge(irs_2011_dataset,irs_2012_dataset,by=c('zip','gross_income'))
irs_13_12_12  <- merge(irs_11_12,irs_2013_dataset,by=c('zip','gross_income'))
irs_14_13_12_11 <- merge(irs_13_12_12,irs_2014_dataset,by=c('zip','gross_income'))
irs_all <-  merge(irs_14_13_12_11,irs_2015_dataset,by=c('zip','gross_income'))

View(irs_all)


irs_11_12_gross_income_total <- merge(irs_2011_dataset_gross_income_total,irs_2012_dataset_gross_income_total,by=c('zip','gross_income'))
irs_13_12_12_gross_income_total  <- merge(irs_11_12_gross_income_total,irs_2013_dataset_gross_income_total,by=c('zip','gross_income'))
irs_14_13_12_11_gross_income_total <- merge(irs_13_12_12_gross_income_total,irs_2014_dataset_gross_income_total,by=c('zip','gross_income'))
irs_all_gross_income_total <-  merge(irs_14_13_12_11_gross_income_total,irs_2015_dataset_gross_income_total,by=c('zip','gross_income'))

View(irs_all_gross_income_total)

# merging zip_codes_df & irs all to get county info

zip_codes_irs_all_df <- merge(irs_all,zip_codes_df, by = 'zip')

zip_codes_irs_all_df <- zip_codes_irs_all_df %>% 
    select(-c(13,15:19))

View(zip_codes_irs_all_df)

#merging zip_codes_df & irsl_gross_income_ttotal to get county info

zip_codes_irs_gross_income_total_df <- merge(irs_all_gross_income_total,zip_codes_df,by='zip')

zip_codes_irs_gross_income_total_df <-zip_codes_irs_gross_income_total_df %>% 
   select(-c(13,15:19))

colnames(zip_codes_irs_gross_income_total_df)
View(zip_codes_irs_gross_income_total_df)


merge_irs_all_by_county <- zip_codes_irs_gross_income_total_df %>% 
  group_by(county) %>% 
  summarise (
   
     sum_total_income_returns_2011  =  sum(total_income_returns_2011),
     sum_total_income_amount_2011   =  sum(total_income_amount_2011),
     mean_total_income_amount_2011  =  mean(total_income_amount_2011),
     sum_total_income_returns_2012  =  sum(total_income_returns_2012),
     sum_total_income_amount_2012   =  sum(total_income_amount_2012),
     mean_total_income_amount_2012  =  mean(total_income_amount_2012),
     sum_total_income_returns_2013  =  sum(total_income_returns_2013),
     sum_total_income_amount_2013   =  sum(total_income_amount_2013),
     mean_total_income_amount_2013  =  mean(total_income_amount_2013),
     sum_total_income_returns_2014  =  sum(total_income_returns_2014),
     sum_total_income_amount_2014   =  sum(total_income_amount_2014),
     mean_total_income_amount_2014  =  mean(total_income_amount_2014),
     sum_total_income_returns_2015  =  sum(total_income_returns_2015),
     sum_total_income_amount_2015   =  sum(total_income_amount_2015),
     mean_total_income_amount_2015  =  mean(total_income_amount_2015)
     
    ) %>% 
  ungroup() %>% 
  mutate(
    
      income_per_tax_return_2011 = sum_total_income_amount_2011 / sum_total_income_returns_2011,
      income_per_tax_return_2012 = sum_total_income_amount_2012 / sum_total_income_returns_2012, 
      income_per_tax_return_2013 = sum_total_income_amount_2013 / sum_total_income_returns_2013, 
      income_per_tax_return_2014 = sum_total_income_amount_2014 / sum_total_income_returns_2014, 
      income_per_tax_return_2015 = sum_total_income_amount_2015 / sum_total_income_returns_2015 
      
  ) %>% 
  select(
     
       county,sum_total_income_amount_2011,sum_total_income_returns_2011,income_per_tax_return_2011,mean_total_income_amount_2011,
       sum_total_income_amount_2012,sum_total_income_returns_2012,income_per_tax_return_2012,mean_total_income_amount_2012,
       sum_total_income_amount_2013,sum_total_income_returns_2013,income_per_tax_return_2013,mean_total_income_amount_2013,
       sum_total_income_amount_2014,sum_total_income_returns_2014,income_per_tax_return_2014,mean_total_income_amount_2014,
       sum_total_income_amount_2015,sum_total_income_returns_2015,income_per_tax_return_2015,mean_total_income_amount_2015
     
       ) %>% 
  arrange( desc( county ) )

View(merge_irs_all_by_county_sor2011)

# sorting data on 2011 income_per_tax_return

merge_irs_all_by_county_sor2011 <- merge_irs_all_by_county %>% arrange(desc(income_per_tax_return_2011))

ggplot(merge_irs_all_by_county, 
       aes(x=county ,y=income_per_tax_return_2011)) +
       geom_boxplot()

boxplot(income_per_tax_return_2011 ~ county,data=merge_irs_all_by_county)

colnames(merge_irs_all_by_county)
View(merge_irs_all_by_county_sor2011)


df_sort <- merge_irs_all_by_county_sor2011 %>% 
  filter(rank(desc(income_per_tax_return_2011))<=10) %>% 
  select(county,income_per_tax_return_2011,income_per_tax_return_2012,income_per_tax_return_2013,income_per_tax_return_2014,income_per_tax_return_2015)

View(df_sort)
library(reshape2)
df_sort_melt <- melt(df_sort,id="county")

View(df_sort_melt)
df_sort_melt_s<-df_sort_melt %>%  arrange(county)


ggplot(df_sort_melt_s,aes(x=variable,y=value,group=county,color=county)) +geom_line(size=2) +labs(y="Income_per_tax_return * 1000",x="Years") 
df_top_10_2011 <- merge_irs_all_by_county[,c(1:5)] %>% 
  filter(rank(desc(income_per_tax_return_2011))<=10) %>% 
  arrange(desc(income_per_tax_return_2011)) 

df_top_10_2012 <- merge_irs_all_by_county[,c(1,8)] %>% 
  filter(rank(desc(income_per_tax_return_2012))<=10) %>% 
  arrange(desc(income_per_tax_return_2012)) 

df_top_10_2013 <- merge_irs_all_by_county[,c(1,12)] %>% 
  filter(rank(desc(income_per_tax_return_2013))<=10) %>% 
  arrange(desc(income_per_tax_return_2013)) 

df_top_10_2014 <- merge_irs_all_by_county[,c(1,16)] %>% 
  filter(rank(desc(income_per_tax_return_2014))<=10) %>% 
  arrange(desc(income_per_tax_return_2014)) 

df_top_10_2015 <- merge_irs_all_by_county[,c(1,20)] %>% 
  filter(rank(desc(income_per_tax_return_2015))<=10) %>% 
  arrange(desc(income_per_tax_return_2015)) 

attach(df_top_10_2011)
boxplot(income_per_tax_return_2011 ~ county , data=df_top_10_2011)

View(df_top_10_2015)

ggplot(df_top_10_2011,aes(y=income_per_tax_return_2011,x=county)) +
  geom_boxplot()


ggplot(merge_irs_all_by_county,aes(y=income_per_tax_return_2011,x=county)) +
  geom_point()

str(merge_irs_all_by_county)

df<-select(merge_irs_all_by_county,c(1,4,8,12,16,20))

colnames(merge_irs_all_by_county)
colnames(df)



ggplot(df,aes(x=county,y=income_per_tax_return_2011)) + geom_point()

attach(merge_irs_all_by_county)
plot(income_per_tax_return_2011, income_per_tax_return_2012) 
abline(lm(income_per_tax_return_2012~income_per_tax_return_2011))
title("income per tax return")

slices <- merge_irs_all_by_county[,c(4, 8,12,16,20)]
lbls <- c("2011", "2012", "2013", "2014", "2015")
pie(slices, labels = lbls, main="Pie Chart of Variuous Years")


