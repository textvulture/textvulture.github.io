library(dplyr)
library(WDI)
library(ggplot2)

var = c('Trade.gdp' = 'NE.TRD.GNFS.ZS',
        'imports' = 'NE.IMP.GNFS.CD',
        'exports' = 'NE.EXP.GNFS.CD',
        'GDPpc' = 'NY.GDP.PCAP.KD',
        'tariff' = 'TM.TAX.MRCH.SM.AR.ZS',
        'totalMexport' = 'TX.VAL.MRCH.CD.WT', # merchandise exports
        'totalSexport' = 'BX.GSR.NFSV.CD') # service exports

wdi <- WDI(indicator=var,
           start=1960,
           country = 'all',
           end=2022,
           extra=TRUE)

wdi %>% 
  drop_na(GDPpc) %>%
  mutate(developed = 
           case_when(GDPpc > 20000 ~ "developed",
                     GDPpc < 20000 ~ "underdeveloped"
           )) -> wdi2

wdi %>%
  group_by(year) %>%
  mutate(worldM = ifelse(country == 
                          'World', 
                         totalMexport, 
                         totalMexport[country == 'World'])) %>%
  mutate(worldS = ifelse(country == 
                           'World', 
                         totalSexport, 
                         totalSexport[country == 'World'])) %>%
  ungroup() %>%
  mutate(shareM = totalMexport/worldM,
         shareS = totalSexport/worldS) %>%
  drop_na(GDPpc) %>%
  filter(year==2019) %>%
  filter(region != "Aggregates") -> wdi3 # to drop regional aggregates

data1 <- wdi3 %>%
  arrange(desc(shareM)) %>% 
  select(country, shareM)

data2 <- wdi3 %>%
  arrange(desc(shareS)) %>% 
  select(country, shareS)

top_n <- 10
top_cat1 <- data1[1:top_n, ]
top_cat2 <- data2[1:top_n, ]

rest_share1 <- 1 - sum(top_cat1$shareM)
rest_share2 <- 1 - sum(top_cat2$shareS)

rest1 <- data.frame(country = "The Rest", shareM = rest_share1)
rest2 <- data.frame(country = "The Rest", shareS = rest_share2)

comM <- rbind(top_cat1, rest1)

comS <- rbind(rest2, top_cat2)

top_cat_colors <- scales::hue_pal()(top_n)

pie1 <- comM %>%
  ggplot(aes(x="", y=shareM, fill=country)) +
  geom_bar(stat = 'identity', width = 1) +
  coord_polar(theta = "y") +
  theme_void() +
  scale_fill_manual(values = c(top_cat_colors, "black"),
                    breaks = c(top_cat1$country, "The Rest"))


pie2 <- comS %>%
  ggplot(aes(x="", y=shareS, fill=country)) +
  geom_bar(stat = 'identity', width = 1) +
  coord_polar(theta = "y") +
  theme_void() +
  scale_fill_manual(values = c(top_cat_colors, "black"),
                    breaks = c(top_cat2$country, "The Rest"))

