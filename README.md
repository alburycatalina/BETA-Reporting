# BETA-Reporting
Code for generating insights about participation in [BETA (Bahamas Engineering and Technology Advancement) Camp](https://wearebeta.co/) from 2021-2024. 

## Island Map 

`Island_map.R` uses spatial data analysis packages  [geodata](https://cran.r-project.org/web/packages/geodata/index.html), [sf](https://r-spatial.github.io/sf/),  [terra](https://cran.r-project.org/web/packages/terra/index.html), and [tmap](https://cran.r-project.org/web/packages/tmap/vignettes/tmap-getstarted.html)to pull a simple features map of the Bahamas and plot locations of island of interest after adding in a database of students' locations. 

It's useful for BETA to quantify student participation from across the islands of the Bahamas. Historically, distribution of educational (and other) resources to the outer Bahamian islands known as the Family Islands has faced inequities compared to the more populated city of Nassau, New Providence, [as is the case in many rural communities](https://academic.oup.com/joeg/article/21/5/683/5998980).

I begin by downloading the Bahamas administrative boundary data using geodata's `gadm()` function. This function requires the country's 3 character ISO code (in this case "BHS"). A list of available ISO codes can be found with `country_codes()`. Then, I convert the raster data to a Simple Feature (sf) object using terra's `as_sf()`. Simple Features are a two-dimensional geometries used for geographic features, and are common in geospatial analysis. 

```{r}
# Download Bahamas Raster data
Bahamas <- gadm("BHS", level = 1, getwd()) %>%
  as_sf()
```

After loading in and cleaning the participant data, I can see that students orginate primarily from New Providence, with a few students from the islands of Grand Bahama and Eleuthera. Next, I create a dataframe containing the latitudes and longitudes of these three islands, an join them to my student location data. Finally, I also convert this to a sf object  using sf's `st_as_sf()` function, which creates a sf object from a dataframe. 


```{r}
# Bring in coordinates of islands to be plotted
coord_df <- data.frame(lat = c(24.9314, 26.6594, 25.0443),
                 lon = c(-76.1900, -78.5207,  -77.3504),
                 Island = c("Eleuthera", "Grand Bahama", "New Providence")) %>%
  left_join(island_df, by =  "Island") %>%
  st_as_sf(coords = c("lon", "lat"), crs = 4326) # convert to shapefile
```


Now it's tmap's time to shine! tmap is a great package for working with sf objects to create informative maps. It can also [generate interactive maps.](https://cran.r-project.org/web/packages/tmap/vignettes/tmap-getstarted.html#interactive-maps)

Here I use `tm_shape(Bahamas)` and `tm_fill()` to plot the islands of the Bahamas in blue. Then, I add an additional `tm_shape()` layer with `coord_df` and `tm_dots()` to add the island coordinates. 


```{r}
# Plot map  with islands highlighted 
tm_shape(Bahamas) + # Plot Bahamas
  tm_fill(col = "#0c3c62") + # Make islands blue
tm_shape(coord_df) + # Plot islands of interest
  tm_dots(col  = "#f36c34", size = .75) + # plot dots 
  tm_layout(title = "BETA Student's Islands of Residence", # Add title 
            title.position = c("left", "bottom"),
            bg.color = "#F0F8FF")
```

Here's the final product. 

![Island Plot](https://github.com/alburycatalina/BETA-Reporting/blob/main/Plots/Island_plot.png)




