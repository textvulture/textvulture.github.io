library(vdemdata)
library(dplyr)
library(ggplot2)
library(tidyr)

vdemdata::vdem %>%
  select(country_name, year, contains('coup')) %>%
  filter(year>1949) %>%
  filter(year<2021) %>%
  drop_na() %>%
  group_by(year) %>%
  summarise(
    across(contains("coup") & where(is.numeric), ~ sum(.x, na.rm = TRUE)),
    .groups = "drop"
  ) %>%
  dplyr::rename(coup = e_pt_coup,
                coup_attempt = e_pt_coup_attempts) %>%
  dplyr::select(year, coup, coup_attempt) -> data


# coup_long <- coup_year %>%
#   pivot_longer(cols = c(coup, coup_attempt),
#                names_to = "type",
#                values_to = "count")

library(ggplot2)

data %>%
ggplot(aes(x = year)) +
  geom_line(aes(y = coup, color = "Coup"), size = 1, alpha=0.75) +
#  geom_point(aes(y = coup, color = "Coup"), size = 2) +
  geom_line(aes(y = coup_attempt, color = "Coup Attempt"), 
            alpha=0.75, size = 1) +
#  geom_point(aes(y = coup_attempt, color = "Coup Attempt"), size = 2) +
  labs(
#    title = "Global Coup and Coup Attempts Over Time",
    x = "Year",
    y = "Number of Cases",
    color = "Event Type"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom",
        text = element_text(size=14)) +
  scale_color_manual(
    values = c("Coup" = "blue", "Coup Attempt" = "red")
  ) 

