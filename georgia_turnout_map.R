# georgia_turnout_map.R
# Visualizes Georgia county-level voter turnout for 2020

library(tidyverse)
library(sf)
library(tigris)

# Load county shapefile for Georgia
ga_counties <- counties(state = "GA", cb = TRUE, class = "sf")

# Simulated turnout data — replace with real pull from existing scripts
turnout_data <- tibble(
  NAME = ga_counties$NAME,
  turnout_pct = runif(nrow(ga_counties), 50, 85)  # placeholder
)

# Join spatial + turnout data
ga_map_data <- ga_counties %>%
  left_join(turnout_data, by = "NAME")

# Plot
ggplot(ga_map_data) +
  geom_sf(aes(fill = turnout_pct), color = "white", size = 0.2) +
  scale_fill_viridis_c(name = "Turnout %", option = "plasma") +
  labs(
    title = "Georgia County-Level Voter Turnout (2020)",
    caption = "Source: Georgia Secretary of State"
  ) +
  theme_minimal()
