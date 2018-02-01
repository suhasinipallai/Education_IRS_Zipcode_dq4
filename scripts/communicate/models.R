# IMPORTS
library("dplyr")
library("ggplot2")

irs_2011_2015 <- readRDS('./r-objects/irs_2011_2015.rds')

View(irs_2011_2015)


irs_stat <- subset(irs_2011_2015,select = c("sum_total_income_amount", "sum_total_income_returns"))
summary(irs_stat)
# correlation between expense and csat
cor(irs_stat) 
plot(irs_stat)

irs_mod <- lm(sum_total_income_amount ~ sum_total_income_returns,data=irs_stat) 
summary(irs_mod)





irs_stat1 <- subset(irs_2011_2015,select = c("year","income_per_tax_return"))
summary(irs_stat1)
cor(irs_stat1)
plot(irs_stat1)

irs_mod1 <- lm(year ~ income_per_tax_return, data=irs_stat1)
summary(irs_mod1)


irs_stat3 <-subset(irs_2011_2015,select=c("year","sum_total_income_amount"))
summary(irs_stat3)
cor(irs_stat3)
plot(irs_stat3)

irs_mod3 <- lm(year ~ sum_total_income_amount , data=irs_stat3)
summary(irs_mod3)

irs_stat4 <- subset(irs_2011_2015,select=c("year","sum_total_income_returns"))
summary(irs_stat4)
cor(irs_stat4)
plot(irs_stat4)

irs_mod4 <- lm(year ~ sum_total_income_returns,data=irs_stat4)
summary(irs_mod4)





