# Global Terrorism Data.
# For GLOA 101, primarily.

library(dplyr)
library(ggplot2)
library(readxl)
library(tidyr)

gtdBase <- read_excel('/Users/bson3/Library/CloudStorage/OneDrive-GeorgeMasonUniversity-O365Production/data_repo/GTD/globalterrorismdb_0522dist.xlsx') 

saveRDS(gtdBase, file = "/Users/bson3/Library/CloudStorage/OneDrive-GeorgeMasonUniversity-O365Production/data_repo/GTD/gtdBase.rds")


## The types of terrorist attacks
gtdBase %>% 
  select(iyear, region_txt, crit1, crit2, crit3, targtype1_txt) %>%
  mutate(across(where(is.numeric), ~na_if(., -99))) %>%
  pivot_longer(cols = c(crit1, crit2, crit3), names_to = "criterion", values_to = "met") %>%
  filter(!is.na(met)) %>%
  mutate(criterion = recode(criterion,
                            crit1 = "Political, economic,\nor religious",
                            crit2 = "Coercion or\nintimidation",
                            crit3 = "Violates Geneva\nconvention"),
         met = factor(met, labels = c("No", "Yes"))) %>%
  ggplot(aes(y = criterion, fill = met)) +
  geom_bar(position = "stack",
           alpha=0.7) +
  scale_fill_manual(values = c("No" = "red", "Yes" = "blue")) +
  labs(title = "",
       x = "", y = "") +
  theme_minimal(base_size = 14) +
  theme(legend.title = element_blank())

## trend
gtdBase %>% 
  select(iyear, region_txt, crit1, crit2, crit3, targtype1_txt) %>%
  mutate(across(where(is.numeric), ~na_if(., -99))) %>%
  count(iyear) %>%
  ggplot(aes(x = iyear, y = n)) +
  geom_line() +
  labs(title = "Trend of Incident Counts Over Time",
       x = "Year", y = "Count")


## country-level trend
library(ggrepel)

gtdBase %>% 
  select(iyear, country_txt, region_txt, 
         crit1, crit2, crit3, targtype1_txt) %>%
  mutate(across(where(is.numeric), ~na_if(., -99)),
         region_recoded = case_when(
           country_txt %in% c("Afghanistan", "Pakistan") ~ "Middle East & Central Asia",
           region_txt %in% c("Central America & Caribbean", "South America") ~ "Latin America",
           region_txt == "North America" ~ "North America",
           region_txt %in% c("Western Europe", "Eastern Europe") ~ "Europe",
           region_txt %in% c("Middle East & North Africa", "Central Asia") ~ "Middle East & Central Asia",
           region_txt == "Sub-Saharan Africa" ~ "Africa",
           region_txt %in% c("South Asia", "Southeast Asia", "East Asia", "Australasia & Oceania") ~ "Asia & Pacific"
         )) %>%
  count(iyear, region_recoded) %>%
  group_by(region_recoded) %>%
  mutate(label = if_else(iyear == max(iyear), region_recoded, NA_character_)) %>%
  ggplot(aes(x = iyear, y = n, color = region_recoded)) +
  geom_line() +
  geom_label_repel(aes(label = label), 
                   nudge_x = 1, na.rm = TRUE,
                   alpha=0.75) +
  labs(title = "", x = "", y = "") +
  theme_minimal(base_size = 13) +
  theme(legend.position= "none")
