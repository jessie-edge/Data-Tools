# Install required rpackages
install.packages("tidyverse")  # For data manipulation and visualization
install.packages("httr")       # For working with HTTP
install.packages("rvest")      # For web scraping
install.packages("jsonlite")   # For JSON parsing, if API returns JSON
install.packages("dplyr")      # For data wrangling
install.packages("janitor")   # For data cleaning

# Load required libraries
library(tidyverse)
library(httr)
library(rvest)
library(jsonlite)
library(dplyr)
library(janitor)

# Set the URL for data access
url <- "https://sos.ga.gov/election-data-hub"

# Example: Download a CSV file directly if available
data <- read_csv(url("https://sos.ga.gov/path/to/data.csv")) %>%
        clean_names()

# If data needs to be scraped from an HTML page
web_page <- read_html(url)

data <- web_page %>%
        html_nodes("css_selector_of_the_data_table") %>%
        html_table()  %>%
        clean_names()

# Example of data manipulation using dplyr
analysis <- data %>%
            filter(State %in% "Georgia") %>%
            group_by(voter_age_group, voter_registration_status) %>%
            summarise(count = n(), .groups = 'drop')

# Example of data visualization using ggplot2
ggplot(analysis, aes(x = voter_age_group, y = count, fill = voter_registration_status)) +
  geom_col(position = "dodge") +
  theme_minimal() +
  labs(title = "Voter Analysis in Georgia", x = "Age Group", y = "Number of Voters")

# Create Map to Plot Voters Across State 
# Install the packages if not already installed
if (!requireNamespace("sf", quietly = TRUE))
    install.packages("sf")
if (!requireNamespace("ggplot2", quietly = TRUE))
    install.packages("ggplot2")
if (!requireNamespace("tidyverse", quietly = TRUE))
    install.packages("tidyverse")

# Load the packages
library(sf)
library(ggplot2)

# Example data frame structure
data <- data.frame(
  County = c("Fulton", "Cobb", "DeKalb"),
  Latitude = c(33.7900, 33.8990, 33.7950),
  Longitude = c(-84.5000, -84.5640, -84.2270),
  Voters = c(1000, 800, 1200)
)

# If coordinates are not available, you might need to join with a spatial data frame that contains this info
# For this example, let's assume we have latitude and longitude

# Convert data frame to an sf object
data_sf <- st_as_sf(data, coords = c("Longitude", "Latitude"), crs = 4326)

# Install and load USAboundaries if you don't have it
if (!requireNamespace("USAboundaries", quietly = TRUE))
    install.packages("USAboundaries")

library(USAboundaries)
# Get Georgia state boundaries
ga_map <- us_states(resolution = "low", states = "GA")

# Base map
ggplot() +
  geom_sf(data = ga_map, fill = "white", color = "black") +
  geom_sf(data = data_sf, aes(size = voters), color = "blue", alpha = 0.6) +
  labs(title = "Map of Voters Across Georgia", x = "Longitude", y = "Latitude") +
  theme_minimal() +
  scale_size(range = c(1, 10))  # Adjust the size scale based on your data
