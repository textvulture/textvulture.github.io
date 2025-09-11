# Install (first time) --------------------------
# install.packages(c("devtools", "dplyr", "ggplot2", "sf", "rnaturalearth", "rnaturalearthdata"))
# devtools::install_github("vdeminstitute/ERT")

library(ERT)            # ERT + V-Dem access
library(dplyr)          # data wrangling
library(ggplot2)        # plotting
library(sf)             # simple features for mapping
library(rnaturalearth)  # world polygons
library(rnaturalearthdata)

# 1) Get (or compute) Episodes of Regime Transformation -----------------------
# Option A: use the packaged, precomputed country-year episodes
eps <- ERT::episodes
# Option B: regenerate from the latest V-Dem with default thresholds
# eps <- ERT::get_eps()   # takes longer; uses v2x_polyarchy changes under the hood
# (Function arguments documented here: help('get_eps', package='ERT'))  #  [oai_citation:1‡Rdrr.io](https://rdrr.io/github/vdeminstitute/ERT/man/get_eps.html)

# Peek
# dplyr::glimpse(eps)
# Key columns: country_id, year, dem_ep (0/1), aut_ep (0/1)  #  [oai_citation:2‡Rdrr.io](https://rdrr.io/github/vdeminstitute/ERT/man/episodes.html)

# 2) Make a world MAP of countries currently in a democratization episode -----
# Find the latest year available in the episodes table
latest_year <- max(eps$year, na.rm = TRUE)

# Bring in country names from the bundled V-Dem table for a clean join
# (V-Dem in ERT includes standard identifiers and country names.)  #  [oai_citation:3‡Rdrr.io](https://rdrr.io/github/vdeminstitute/ERT/man/vdem.html)
vdem_ids <- ERT::vdem %>%
  select(country_id, country_name) %>%
  distinct()

# Countries in democratization episodes in the latest year
dem_now <- eps %>%
  filter(year > 1999) %>%               # keep years >= 2000
  group_by(country_id) %>%              # collapse to country level
  summarise(
    dem_ep = as.integer(max(dem_ep, na.rm = TRUE)),  
    .groups = "drop"
  ) %>%
  left_join(vdem_ids, by = "country_id")


# Get world polygons (Natural Earth)
world <- rnaturalearth::ne_countries(scale = "medium", returnclass = "sf") %>%
  st_make_valid()

# Join by country name (works well with most cases; adjust if you prefer ISO codes)
world_dem <- world %>%
  left_join(dem_now, by = c("name" = "country_name")) %>%
  mutate(in_dem_ep = ifelse(is.na(dem_ep), 0L, dem_ep))

# Plot: countries in a democratization episode (latest year)
ggplot(world_dem) +
  geom_sf(aes(fill = factor(in_dem_ep))) +
  scale_fill_manual(
    values = c("0" = "grey85", "1" = "blue"),
    labels = c("No", "Yes"),
    name = paste0("Democratization ep. in ", latest_year)
  ) +
  theme_minimal() +
  theme(legend.position = "none")

ggsave('demo_map.png', bg='white')

#
#
#
#
#
# Global count of countries in democratization episodes, 1900–present --------------------
dem_timeseries <- eps %>%
  group_by(year) %>%
  summarise(countries_in_dem_ep = sum(dem_ep, na.rm = TRUE), .groups = "drop")




ggplot(dem_timeseries, aes(year, countries_in_dem_ep)) +
  geom_line(size = 0.9) +
  labs(
    x = NULL, y = "Num. of countries in democratization"
  ) +
  geom_area(fill="69b3a2", alpha=0.6) +
  theme_minimal() +
  theme(text = element_text(size=14))

ggsave('trend_demo.png', bg='white', width=13, height=7)