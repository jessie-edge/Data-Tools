# Load the libraries
library(tidyverse)
library(janitor)
library(httr)
library(arrow)
library(zip)

# Grab GA SOS Data - https://mvp.sos.ga.gov/s/voter-history-files

data_url <- ""

# Download the zip file
temp_zip <- tempfile(fileext = ".zip")
GET(data_url, write_disk(temp_zip))

# Unzip the contents
unzip(temp_zip, exdir = "unzipped_data")

files <- list.files("unzipped_data", recursive = TRUE, full.names = TRUE)
files

# Load the appropriate file into R (adjust the path if necessary)
voter_data <- files[grepl("\\.csv$", files)]

# Load the CSV into a dataframe
df <- voter_data %>%
  read_sv_arrow()%>%
  clean_names()

colnames(df)

