# Estimating land growth onto irrigated lands, Part 2.

# Background:  the objective is to take the amount of annual new growth in square miles for each water provider 
# and convert the amount to a count of cells/pixels in the raster.  The cells need to belong to the Land Development 
# category of "Potentially Developable".  Those cells will then be reclassified as "Developed", creating a new raster 
# of land development.  This new raster will then be used to estimate land growth for the following year.  The process 
# will be repeated to the year 2050. 

# In this script, MUNICIPAL land growth is estimated.  A raster stack of the 'munis', 'distance', 'potential', 
# 'irrigated', 'developed', and 'counties' layers is created. The stack serves to align all of the rasters together.

# Using the stack, the steps are to take the cells that are potentially developable, have the minimum distance (but 
# greater than 0) from developed lands, and are irrigated (irrigated prioritized first, then non-irrigated) and 
# reclassify (convert) them from Potentially Developable to Developed.  The number of cells to reclassify for each 
# year can be found in the file 'municipal-cells-to-reclassify.csv'.

# Will reclassify 'developed' from 0 to 1 for the number of cells specified.
# Will reclassify 'potential' from 1 to 0 for the number of cells specified.

# These steps require a lot of memory to process, so the procedure is completed in multiple scripts.  See 
# 'land-development-mapping-part1.R' and 'land-development-mapping-part3.R'

# Check the working directory
# - DO NOT hard code a path
# - R Studio only opens in the correct working directory if double-click on R file, not File ... Open.
# - Therefore, look for this R file in the workding directory and exit if not found.
# - Run the R script from command line or TSTool RunR() to ensure working directory is correct.
# setwd ("E:\\Data\\data-processing\\11-Map-LandDevelopment\\")
wd <- getwd()
cat("Working directory: ", wd, "\n")
r_file = "land-development-mapping-part2.R"
if ( !file.exists(r_file) ) {
  stop(cat("Expected R file (", r_file, ") does not exist.  Working directory is incorrect.\n"))
}

# Load required packages
library(dplyr) # For data manipulation and organization
library(rgdal)  # Used for reading in raster files
library(raster) # Used to create, manipulate, and export raster data
library(sp)

# Clear the workspace 
rm(list=ls())

# Set global option for reading files
options(stringsAsFactors=FALSE)


# 1)  Read in data
# a. Read in virtual raster created in '01-Calculate-Municipal-WaterDistrictAreas'
filename = "../01-Calculate-Municipal-WaterDistrictAreas/Virtual_Raster.tif"
# Create RasterLayers from each band
munis = raster(filename, band=1)
# Check the properties; should be a RasterLayer
munis
# Plotif desired (commented out)
#plot(munis, main = "Front Range Municipalities")

counties = raster(filename, band=3)
# Check the properties
counties
# Plot if desired (commented out)
#plot(counties, main = "Counties")

irrig = raster(filename, band=4)
# Check the properties
irrig
# Plot if desired (commented out)
#plot(irrig, main = "Irrigated Lands")

landdev = raster(filename, band=5)
# Check the properties
landdev
# Plot if desired (commented out)
#plot(landdev, main = "Land Development")

distance = raster("Distance_Municipalities.tif", band=1)
# Check the properties
distance
# Plot
plot(distance, main = "Distance from Municipalities")

# b. Read in csv of cells to reclassify
muni_reclass = read.csv("municipal-cells-to-reclassify.csv", header = TRUE)
# Filter out 2018 data
muni_reclass = muni_reclass %>%
  filter(Year != 2018)


# 2)  Take the LandDevelopment raster ('landdev') and create two new rasters, one of "Developed" land and one of 
# "Potentially Developable" land.
# a.
developed = landdev == 2

# b.
potential = landdev == 1


# 3) Filter the 'munis' raster to only the munis used in the analysis.  Set all other municipalities to NA.
# Get unique values of municipalities in the raster
new = unique(munis)
new = as.data.frame(new)
# Get unique values of municipalities in 'muni-reclass'
new2 = unique(muni_reclass$Raster_ID)
new2 = as.data.frame(new2)
# Filter out new by new2
new3 = new %>% 
  filter(!new %in% new2$new2)
# Convert unused munis to NA
for (muni in unique(new3$new)) {
  munis[munis == muni] = NA
}


# 4)  Create a RasterStack of 'munis', distance', 'potential', 'irrig', 'developed', and 'counties'
landgrowth = stack(munis, distance, potential, irrig, developed, counties)


# 5) Extract the data based on the 'munis' raster to be able to see it in table form and filter cells to what is 
# needed
# Vectorize the 'munis' raster to use for extracting data
muni_vector = rasterToPoints(munis, spatial = TRUE)
landgrowth_vector = raster::extract(landgrowth, muni_vector, sp = TRUE, cellnumbers = TRUE) 
# sp = TRUE means to keep as a spatial points data frame (SPDF); cellnumbers serve as identifiers


# 6)  Edit data to have specific column names
landgrowth_vector@data = landgrowth_vector@data %>%
  rename(Cell_Number = cells, Municipality = Virtual_Raster.1, Distance_from_Developed = Distance_Municipalities, 
         Potentially_Developable = layer.1, Irrigated_Lands = Virtual_Raster.2, Developed = layer.2, 
         County = Virtual_Raster.3) %>%
  dplyr::select(-Virtual_Raster) # Delete duplicate column

# Add a Year column to be used later; fill with 2018 to represent current boundaries.
landgrowth_vector@data$Year = 2018


# 7) Extract number of cells to reclassify for each water provider/county combo and for the density options and years.
# For each year, merge the points selected for development and assign those rows a value of #### in the Year column.

# For loops to iterate over density option, year, provider and county
# 'unique(dataobject$variablename) provides the unique values of that variable that are iterated over 
dat = list()
for (density in unique(muni_reclass$Density_Option)) {
  temp = muni_reclass[which(muni_reclass$Density_Option == density), ]
  dat[[density]][['2018']] = landgrowth_vector@data
  for (year in unique(temp$Year)) {
    temp2 = temp[which(temp$Year == year), ]
    for (provider in unique(temp2$Raster_ID)) {
      temp3 = temp2[which(temp2$Raster_ID == provider), ]
      for (county in unique(temp3$County_ID)) {
        temp4 = temp3[which(temp3$County_ID == county), ]
        n = temp4$Cells_to_Reclassify
        dat[[density]][[toString(year)]][[toString(provider)]][[toString(county)]] = dat[[density]][['2018']] %>%
          filter(Municipality == provider,
                 County == county,
                 Developed == 0,
                 Potentially_Developable == 1,
                 Distance_from_Developed > 0) %>%
          arrange(Municipality, desc(Irrigated_Lands), Distance_from_Developed) %>%
          .[0:n, ] %>% # Selects the top 'n' rows, which will be reclassified
          mutate(Year = year) %>%
          mutate(Potentially_Developable = Potentially_Developable - 1) %>% # Cells are no longer developable
          mutate(Developed = Developed + 1) # Cells are now considered Developed
        # Substitute in the new values (with new year) to dat[['2018']] so that they can't be selected again
        dat[[density]][['2018']] %<>%
          filter(!Cell_Number %in% dat[[density]][[toString(year)]][[toString(provider)]][[toString(county)]]$Cell_Number) %>%
          bind_rows(dat[[density]][[toString(year)]][[toString(provider)]][[toString(county)]])
      }
    }
    print(year)
    # Convert dat[[density]][['2018']] to a matrix
    temp5 = as.matrix(dat[[density]][['2018']])
    # Create an empty RasterBrick that will be filled with the values of the matrix
    # See: https://stat.ethz.ch/pipermail/r-sig-geo/2010-July/008749.html
    brick = brick(nrows=2964, ncols=1545)
    id = data.frame(cell = 1:ncell(brick))
    # Fill with values of the matrix
    idv = merge(id, temp5, by=1, all.x = TRUE)
    brick = setValues(brick, as.matrix(idv))
    # Set the projection, extent, and resolution to match other rasters
    projection(brick) = "+proj=utm +zone=13 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
    xmin(brick) = 472373.1
    xmax(brick) = 679549.2
    ymin(brick) = 4145741
    ymax(brick) = 4543198
    res(brick) = 134.0946
  }
  # Drop the cell number layer.  As a consequence, the RasterBrick becomes a RasterStack and the filesize is much 
  # smaller.
  brick = dropLayer(brick, 1)
  # Write raster of current density option
  writeRaster(brick, filename = paste0(density,"_Density_Municipal_Growth.tif"), format = "GTiff", bandorder = "BIL", overwrite = TRUE)
}


# Old Logic -- keep for now
# dat = list()
# for (provider in unique(muni_reclass$Raster_ID)) {
#   temp = muni_reclass[which(muni_reclass$Raster_ID == provider), ]
#   for (density in unique(temp$Density_Option)) {
#     temp2 = temp[which(temp$Density_Option == density), ]
#     for (county in unique(temp2$County_ID)) {
#       temp3 = temp2[which(temp2$County_ID == county), ]
#       dat[['2018']] = landgrowth_vector@data
#       for (year in unique(temp3$Year)) {
#         n = temp3[which(temp3$Year == year), ]$Cells_to_Reclassify
#         dat[[toString(year)]] = dat[['2018']] %>%
#           filter(Municipality == provider,
#                  County == county,
#                  Developed == 0,
#                  Potentially_Developable == 1,
#                  Distance_from_Developed > 0) %>%
#           arrange(Municipality, desc(Irrigated_Lands), Distance_from_Developed) %>%
#           .[0:n, ] %>% # Selects the top 'n' rows, which will be reclassified
#           mutate(Year = year) %>%
#           mutate(Potentially_Developable = Potentially_Developable - 1) %>% # Cells are no longer developable
#           mutate(Developed = Developed + 1) # Cells are now considered Developed
#         # Substitute in the new values (with new year) to dat[['2018']] so that they can't be selected again
#         dat[['2018']] = dat[['2018']] %>%
#           filter(!Cell_Number %in% dat[[toString(year)]]$Cell_Number) %>%
#           bind_rows(dat[[toString(year)]])
#       }
#     }
#   }
# }

