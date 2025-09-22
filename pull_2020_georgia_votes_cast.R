# Load the libraries
library(tidyverse)
library(janitor)
library(httr)
library(arrow)
library(zip)

# Grab GA SOS Data - https://mvp.sos.ga.gov/s/voter-history-files

data_url <- "https://prod-ga-sos-vr-data-processing-bucket.s3.amazonaws.com/GAVR/VOTER_ZIP/2020/11-3-2020%20-%20NOVEMBER%203%2C%202020%20GENERAL%3ASPECIAL%20ELECTION/11-3-2020%20-%20NOVEMBER%203%2C%202020%20GENERAL%3ASPECIAL%20ELECTION.zip?AWSAccessKeyId=ASIATU5WJXWIVZIOWQS4&Signature=NbNp9tZXKGq%2BB%2BZKRgYGWuk4KsQ%3D&x-amz-security-token=IQoJb3JpZ2luX2VjEMr%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMSJIMEYCIQCVVVKS3PWKBO33J1bXXXOYg2ZZcnfrK9TE0v%2Fxq63pwwIhAMbyWR1oOws2c6vEU42GMgaLrzvPutp5LV4ksLbbyfIeKoQDCDMQABoMMjUxMTAxMDM1OTIxIgyZ24ZBqd6eCVENddQq4QKyETFD785jwaM23fVQ6PP3KNhOhB7f%2BFtrPccW9%2BW8qLw33ETyKj47fGNvz7fvQjpq%2BWl7Tx7N3xTzO3qlUYcLIz%2BJEuS5Qv90%2FnUkNhQF3tEdBFDCeoShhqt1J89bxgZHbH0oKW3V7VT0s4asyh036xVvH0lFRmO9TtQlAs11wD0v1J1PJvQuanh6KVqhoPEbUx9Z6XBM1N5XqQ%2FqPdHjGyBdqzDBd9LLUv6vlBPaUfDwaO99ifqC13if9owyvcaXtAibaM5%2BfSOw3Ytd6DOR61VWbHjVKSDwNySb%2F13qplyJyz06j0ngBZW6ssh%2FFZqli0ARX6C5jiN7Dmm10ejdMjraZy5XoUJ0dwyZWxIgFgmPw8N%2Fxc%2B0xj1OQgC%2BXKY3DxrVrA9eenBmqc%2BLj1niH02zbsZ7uZ6wFuGTtL2406dF08Dq8afrLuIktDdnnshnxdCcoWZeR%2BoKHzbtHbIDZzDzk8W4BjqdAZNMlGbTmq3Dkk02ps7op1N2FwfPYvwd0aFTryKtSeD0cUtx0zC6g%2FUKyc6PHkQ5k4EaTvFC3yzZ0Np5REq9PoKs3SjZkMmOitVLw9jh32LC3aTvKc4lLR5JiA%2FI%2FfDxO3aMokoY37Cz0dASMfCEQKv4PTXbbtejAsoDSgPmgJD6hBQYRXjHqZqjAbg2VUl6Qj4izepqWzPFwhO13c8%3D&Expires=1729193307"

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

