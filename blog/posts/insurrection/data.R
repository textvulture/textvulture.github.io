
library(dplyr)
library(vdemdata) 
library(ggplot2)
library(ggrepel)

df <- vdemdata::vdem %>%
  select(contains("v2x_polyarchy"), country_name, year) %>%
  filter(country_name == "South Korea")


df %>% 
  filter(year>1960) %>%
  mutate(graphid = 
           case_when(year>1987 & year<1993 ~ "red",
                     year>1992 & year<1998 ~ "red",
                     year>1997 & year<2003 ~ "blue",
                     year>2002 & year<2008 ~ "blue",
                     year>2007 & year<2013 ~ "red",
                     year>2012 & year<2017 ~ "red",
                     year>2016 & year<2022 ~ "blue",
                     year>2021 ~ "red")
  )  ->   df2

###########################


df2 %>%
  ggplot(aes(x=year,
             y=v2x_polyarchy,
             alpha=0.7)) +
  geom_bar(aes(fill=graphid),
           stat = 'identity') +
  theme_minimal() +
  scale_fill_manual(values = c("blue", "red")) +
  theme(legend.position = 'none') +
  labs(y="Polyarchy",
       title="Electoral Democracy. The higher, the more democratic")

ggsave(file="posts/insurrection/demo_bar.png", bg='white')

#############################

poly <- vdemdata::vdem %>%
  select(country_name, year, v2x_polyarchy)


df4 <- vdemdata::vparty %>%
  select(v2xpa_antiplural, v2paenname, country_name, year) %>%
  mutate(dems = case_when(country_name == "South Korea" &
                            v2paenname %in% c(
                              "Democratic Justice Party",
                              "Democratic Liberal Party / New Korea Party",
                              "Liberty Korea Party",
                              "New World Party -- The Grand National Party"
                            ) ~ "red",
                          country_name == "South Korea" & v2paenname %in% c(
                            "Democratic Party",
                            "Democratic Party / Minjoo Party of Korea",
                            "Millenium Democratic Party",
                            "National Congress for New Politics / Democratic Party",
                            "Our Party",
                            "Party for Peace and Democracy",
                            "[United] Democratic Party"
                          ) ~ "blue", 
                          TRUE ~ "others"
  )) %>%
  mutate(korea = case_when(
    dems == "blue" ~ 1,
    dems == "red" ~ 1,
    dems == "others" ~ 0
  ))  

df5 <- df4 %>% inner_join(poly, by = c("country_name", "year"))


df5 %>% filter(year>1980) %>%
  ggplot(aes(x=year, 
             y=v2xpa_antiplural, 
             color=dems)) +
  geom_point(data = df4 %>% filter(year>1980) %>%
               filter(korea==1), 
             aes(size=4, alpha=0.75)) +
  geom_point(data = df4 %>% filter(year>1980) %>% 
               filter(korea==0),
             aes(size=1, alpha=0.5, color="grey")) +
  geom_smooth(data=df5 %>% filter(year>1980 &
                                    korea==0),
              color='purple', se=FALSE, alpha=0.7) +
  annotate(geom="text", x=2000, y= 0.42, color="purple", 
           label="Global Mean") +
  geom_smooth(data=df5 %>% filter(year>1980 &
                                    korea==0 & v2x_polyarchy > 0.738),
              color='#365d0f', se=FALSE, alpha=0.7) +
  annotate(geom="text", x=1985, y= 0.2, color="#365d0f", 
           label="Top 25% Democratic \nCountries") +
  annotate(geom = "text", x=1987.5, y=0.7,
           label = "S.Korea Democratization",
           angle=90) +
  geom_label_repel(aes(label = v2paenname,
                       alpha = 0.7),
                   box.padding=4,
                   size=4,
                   data = df4 %>% filter(year==2016 & korea==1)) +
  theme_minimal() +
  scale_color_manual(values = c("blue", "grey", "red")) +
  theme(legend.position = 'none') +
  labs(y="anti-pluralism",
       title = "Anti-Pluralism Party Index. The higher, the less democratic") +
  geom_vline(xintercept = 1987,
             linetype=2)

ggsave(file="posts/insurrection/party.png", bg='white')

####################


df4 %>% 
  filter(year>1980 & country_name=="United Kingdom") %>%
  filter(v2paenname == "Conservatives" | v2paenname == "Labour") -> df6

df6 %>%
  ggplot(aes(x=year,
             y=v2xpa_antiplural,
             color=v2paenname,
             label=v2paenname,
             alpha=0.8)) +
  geom_point(size=7) +
  geom_label_repel(data=df6 %>% filter(year==2017),
                   box.padding = 3, size=4) +
  theme_minimal() +
  theme(legend.position = 'none') +
  labs(y="anti-pluralism",
       title = "Anti-Pluralism Party Index. The higher, the less democratic") +
  ylim(0, 1)

ggsave(file="posts/insurrection/UK.png", bg='white')