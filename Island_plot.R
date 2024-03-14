# This script makes a map of the Bahamas with participant numbers per island



# Setup -------------------------------------------------------------------

# Load in required libraries 
library(tidyverse)
library(tmap) # for plotting country
library(geodata) # for pulling country shape files
library(sf) # coverting spatvector to sf
library(stringr) # working with text strings
library(terra) # spatial data analysis


# Set wd
setwd("~/OneDrive/Documents/Life/Coding-Projects/BETA-Reporting/RAW")



# Pair Map Shapefile and Participant Data ----------------------------------------------------------------

# Download Bahamas Raster data by 3 character ISO code with geodata's gadm function


Bahamas <- gadm("BHS", level = 1, getwd()) %>%
  as_sf()

  
# Load in df
island_df <- read.csv("BETA Camp 2021 Applicants - General.csv") %>%
  select(Island) %>%
  count(Island, name = "n_students")

# Bring in coordinates of islands to be plotted
coord_df <- data.frame(lat = c(24.9314, 26.6594, 25.0443),
                 lon = c(-76.1900, -78.5207,  -77.3504),
                 Island = c("Eleuthera", "Grand Bahama", "New Providence")) %>%
  left_join(island_df, by =  "Island") %>%
  st_as_sf(coords = c("lon", "lat"), crs = 4326) # convert to shapefile

# Plot mapwith islands highlighted 

tm_shape(Bahamas) +
  tm_fill(col = "#0c3c62") +
  tm_shape(coord_df) +
  tm_dots(col  = "#f36c34", size = 1.3) +
  tm_layout(title = "BETA Student's Islands of Residence", 
            title.position = c("left", "bottom"),
            bg.color = "#F0F8FF")






