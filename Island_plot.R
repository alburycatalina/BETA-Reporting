# This script makes a map of the Bahamas with participant locations marked



# Setup -------------------------------------------------------------------

# Load in required libraries 
library(tidyverse)
library(tmap) # for plotting country
library(geodata) # for pulling country simple features
library(sf) # coverting spatvector to sf
library(stringr) # working with text strings
library(terra) # spatial data analysis


# Set wd
setwd("~/OneDrive/Documents/Life/Coding-Projects/BETA-Reporting/RAW")

# Pull df with participant data 
participant_df <- read.csv("BETA Camp 2021 Applicants - General.csv")


# Pair Map Shapefile and Participant Data ----------------------------------------------------------------

# Download Bahamas Raster data by 3 character ISO code with geodata's gadm function
Bahamas <- gadm("BHS", level = 1, getwd()) %>%
  as_sf()

  
# Load in participant island origins
island_df <- participant_df %>%
  select(Island) %>%
  count(Island, name = "n_students")

# Bring in coordinates of islands to be plotted
coord_df <- data.frame(lat = c(24.9314, 26.6594, 25.0443),
                 lon = c(-76.1900, -78.5207,  -77.3504),
                 Island = c("Eleuthera", "Grand Bahama", "New Providence")) %>%
  left_join(island_df, by =  "Island") %>%
  st_as_sf(coords = c("lon", "lat"), crs = 4326) # convert to shapefile

# Plot map with islands highlighted 
tm_shape(Bahamas) + # Plot Bahamas
  tm_fill(col = "#0c3c62") + # Make islands blue
  tm_shape(coord_df) + # Plot islands of interest
  tm_dots(col  = "#f36c34", size = .75) + # plot dots 
  tm_layout(title = "BETA Student's Islands of Residence", # Add title 
            title.position = c("left", "bottom"),
            bg.color = "#F0F8FF")










