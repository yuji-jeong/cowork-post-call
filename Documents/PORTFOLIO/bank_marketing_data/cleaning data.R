getwd() 
setwd("/Users/yujijeong/Documents/portfolio/bank_marketing_data")

dat = read.csv("bank.csv", header = TRUE)
dim(dat) # we have 11162 observations
summary(dat) # age, balance, day, duration, campaign, pdays are numerical values; others are all categorical values

library(dplyr)
is.na(dat) %>% any() # There is no NA values


install.packages("tidyverse")
library(tidyverse)
str(dat) # the categorical variables are factorized and the rest are integers

### EXPLORATORY DATA ANALYSIS ###
# Could we superimpose different variables and compare to poutcome values?
library(ggplot2)






data %>% 
  select(center_type,num_orders) %>% 
  filter(center_type=="TYPE_A") %>%
  summarise(avg_A=mean(num_orders))
