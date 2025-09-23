library(dplyr)
library(ggplot2)


# Under- or Overvaluation of global currencies

library(wbstats)
library(stringr)
library(ggrepel)

# indicators <- wb_search("real effective exchange rate") %>%
#   filter(str_detect(indicator_id, regex("REER|REX", ignore_case = TRUE)))

countries <- c("JPN", "USA", "GBR", "CHN", "MEX")  
reer <- wb_data(
  indicator   = "REER",
  country     = countries,
  start_date  = 1975,
  end_date    = 2020,
  return_wide = FALSE
) %>%
  select(country, iso3c, date, value) %>%
  arrange(country, date)

reer %>%
  ggplot(aes(x = date, y = value, color = iso3c)) +
  geom_line(size = 1) +
  geom_text_repel(
    data = reer %>% filter(date==2020),
    aes(label = iso3c),
    nudge_x = 2,          
    direction = "y",
    hjust = 0,
    show.legend = FALSE
  ) +
  labs(
    x = "Year",
    y = "REER (year 2010=100)",
    caption = "Data Source: World Bank"
  ) +
  scale_x_continuous(breaks = seq(1975, 2020, by = 5)) +
  theme_minimal(base_size = 14) +
  theme(legend.position = "none")

ggsave(filename = "reer.png",
       bg = "white")
