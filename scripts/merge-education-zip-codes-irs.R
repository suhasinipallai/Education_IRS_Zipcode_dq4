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

attach(zip_irs_education_df)
lm(income_per_tax_return ~ Pct_Hispanic, data=zip_irs_education_df)

ggplot(data=zip_irs_education_df,aes(y=income_per_tax_return,x=Pct_Hispanic)) +
  geom_point() +
  geom_smooth(method="lm")


lm(income_per_tax_return ~ Pct_Native_American, data=zip_irs_education_df)

ggplot(data=zip_irs_education_df,aes(y=income_per_tax_return,x=Pct_Native_American)) +
  geom_point() +
  geom_smooth(method="lm")

lm(income_per_tax_return ~ Pct_Black, data=zip_irs_education_df)

ggplot(data=zip_irs_education_df,aes(y=income_per_tax_return,x=Pct_Black)) +
  geom_point() +
  geom_smooth(method="lm")


lm(ACT_Composite ~ Pct_Black, data=zip_irs_education_df)

ggplot(data=zip_irs_education_df,aes(y=ACT_Composite,x=Pct_Black)) +
  geom_point() +
  geom_smooth(method="lm")


lm(ACT_Composite ~ Pct_Native_American, data=zip_irs_education_df)

ggplot(data=zip_irs_education_df,aes(y=ACT_Composite,x=Pct_Native_American)) +
  geom_point() +
  geom_smooth(method="lm")


lm(ACT_Composite~ Pct_Hispanic, data=zip_irs_education_df)

ggplot(data=zip_irs_education_df,aes(y=ACT_Composite,x=Pct_Hispanic)) +
  geom_point() +
  geom_smooth(method="lm")


mod = lm(ACT_Composite~ Pct_Hispanic, data=zip_irs_education_df)

coef(mod)
summary(mod)

fitted.values(mod)
residuals(mod)

library(broom)
augment(mod)

predict(mod)


#plot income per tax return vs act scores

plot(zip_irs_education_df$income_per_tax_return,zip_irs_education_df$ACT_Composite)


str(zip_irs_education_df)
#col1 & col 8 are chr

library(caret)

cor(zip_irs_education_df,use='county')

#converting all char colmns into numbers

dmy <- dummyVars("~ ." , data=zip_irs_education_df)
merged_df <- data.frame(predict(dmy,newdata = zip_irs_education_df))

dim(zip_irs_education_df)
# zip irs education - 94 obs 21 variables
dim(merged_df)
str(merged_df)
# after converting char colmn into numbers  - 94 obs , 121 variables

#see the corr btw the variables

cor(merged_df)


#creating a n cor. prob

cor.prob <- function (X, dfr = nrow(X) - 2) {
  R <- cor(X, use="pairwise.complete.obs")
  above <- row(R) < col(R)
  r2 <- R[above]^2
  Fstat <- r2 * dfr/(1 - r2)
  R[above] <- 1 - pf(Fstat, 1, dfr)
  R[row(R) == col(R)] <- NA
  R
}

# create a flatten square matrix - 4 variables only 

flattenSquareMatrix <- function(m) {
  if( (class(m) != "matrix") | (nrow(m) != ncol(m))) stop("Must be a square matrix.") 
  if(!identical(rownames(m), colnames(m))) stop("Row and column names must be equal.")
  ut <- upper.tri(m)
  data.frame(i = rownames(m)[row(m)[ut]],
             j = rownames(m)[col(m)[ut]],
             cor=t(m)[ut],
             p=m[ut])
}

flattenCorrMatrix <- function(cormat, pmat) {
  ut <- upper.tri(cormat)
  data.frame(
    row = rownames(cormat)[row(cormat)[ut]],
    column = rownames(cormat)[col(cormat)[ut]],
    cor  =(cormat)[ut],
    p = pmat[ut]
  )
}


corMaster <- flattenSquareMatrix(cor.prob(merged_df))
   
dim(corMaster)                              
head(corMaster)

corList <- corMaster[order(-abs(corMaster$cor)),]
head(corList)

corList$j


subList <- subset(corList,(abs(cor) > 0.2 & j=='income_per_tax_return'))

subList

bestList <- as.character(subList$i[c(1,2,3,4,5,7,8,9,10,11)])

bestList

library(psych)                         
pairs.panels(merged_df[c(bestList,'income_per_tax_return')])






#---
cor_df1 <-cor_df[-c(11)]

col<- colorRampPalette(c("blue", "white", "red"))(20)
heatmap(x = cor_df1, col = col, symm = FALSE)

View(cor_df1)
colnames(cor_df1)


#install.packages("Hmisc")
#install.packages("corrplot")

library(Hmisc)
res2<-rcorr(as.matrix(cor_df1[,1:3,8:10]))
flattenCorrMatrix(res2$r, res2$P)

library(corrplot)
corrplot(res2, type = "upper", order = "hclust", 
         tl.col = "black", tl.srt = 45)

#----------


dim(merged_df)
dim(zip_irs_education_df)


#extract top 10 counties data


top_10_counties <-head(sort(zip_irs_education_df$income_per_tax_return,decreasing=TRUE), n = 10)
View(top_10_counties)

low_10_counties <- head(sort(zip_irs_education_df$income_per_tax_return,decreasin=FALSE), n =10)
View(low_10_counties)

df_1 <- zip_irs_education_df %>% 
      head(sort(income_per_tax_return,decreasing = TRUE),n=10) 

df_top_10 <- zip_irs_education_df %>% 
    filter(rank(desc(income_per_tax_return))<=10) %>% 
    arrange(desc(income_per_tax_return)) 

df_low_10 <- zip_irs_education_df %>% 
    filter(rank(income_per_tax_return) <=10)  %>% 
    arrange(income_per_tax_return)

      

str(df_10)
View(df_low_10)


str(zip_irs_education_df)


ggplot(zip_irs_education_df,
       aes(x=ACT_Composite,y=income_per_tax_return)) +
       geom_point()

ggplot(zip_irs_education_df,
       aes(x=Pct_Suspended , y=income_per_tax_return)) +
       geom_line()
ggplot(df_low_10,
       aes(x=mean_math , y=income_per_tax_return)) +
       geom_boxplot()
ggplot(df_top_10,
       aes(y=income_per_tax_return,x=mean_math)) +
       geom_boxplot()

ggplot(df_top_10,
       aes(x=Pct_Black,y=income_per_tax_return)) +
       geom_boxplot()

View(zip_irs_education_df)
colnames(zip_irs_education_df)


op<- par(mar= c(5,5,5,5,5,5,5,5,5))
par(cex.axis=1)
boxplot(income_per_tax_return ~ CORE_region, data=zip_irs_education_df,las=2,srt=45, 
       col=(c("gold","darkgreen")),
       ylab="income_per_tax_return",ylim=c(0,150))
par(op)












