library(WDI)
library(tidyverse)
library(plm)

var = c('crisis' = "GFDD.OI.19",
        'GDPpc' = 'NY.GDP.PCAP.KD',
        'exrate' = 'PA.NUS.FCRF')


wdi <- WDI(indicator=var,
           start=1960,
           country = 'all',
           end=2020,
           extra=TRUE)



wdi <- pdata.frame(wdi,index=c("country","year"))

wdi %>%
  mutate(lexrate = lag(exrate, 1)) -> wdi2