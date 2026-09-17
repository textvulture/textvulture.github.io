library(tidyverse)

pubs <- read_csv("publication_categories.csv")

pubs_long <- pubs |>
  mutate(
    status = if_else(str_detect(publication, "_underreview$"), "Under review", "Published"),
    publication = fct_reorder(publication, year)
  ) |>
  pivot_longer(
    cols = c(global_political_economy, comparative_autocratization,
             public_opinion, political_communication),
    names_to = "category",
    values_to = "included"
  ) |>
  filter(included == "Yes") |>
  mutate(category = recode(category,
    global_political_economy   = "Global Political Economy",
    comparative_autocratization = "Comparative Autocratization",
    public_opinion              = "Public Opinion",
    political_communication     = "Political Communication"
  )) |>
  mutate(category = factor(category, levels = c(
    "Global Political Economy",
    "Comparative Autocratization",
    "Public Opinion",
    "Political Communication"
  )))

ggplot(pubs_long, aes(x = publication, y = category, fill = category, alpha = status)) +
  geom_tile(width = 0.95, height = 0.85, color = "white", linewidth = 1) +
  scale_fill_manual(values = c(
    "Global Political Economy"    = "#1b9e77",
    "Comparative Autocratization" = "#d95f02",
    "Public Opinion"              = "#7570b3",
    "Political Communication"     = "#e7298a"
  )) +
  scale_alpha_manual(values = c("Published" = 1, "Under review" = 0.35), guide = "none") +
  labs(
    title = "Research Programs by Publication",
    x = "Publication",
    y = NULL
  ) +
  theme_minimal(base_size = 12) +
  theme(
    legend.position = "none",
    axis.text.x = element_text(angle = 60, hjust = 1),
    panel.grid.major = element_line(color = "gray85", linewidth = 0.3),
    panel.grid.minor = element_blank()
  )

ggsave("publication_brickwall.png", width = 10, height = 5, dpi = 300)
