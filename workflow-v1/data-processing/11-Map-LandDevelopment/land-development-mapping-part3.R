# Estimating land growth onto irrigated lands, Part 3.

# Background:  the objective is to take the amount of annual new growth in square miles for each water provider 
# and convert the amount to a count of cells/pixels in the raster.  The cells need to belong to the Land Development 
# category of "Potentially Developable".  Those cells will then be reclassified as "Developed", creating a new raster 
# of land development.  This new raster will then be used to estimate land growth for the following year.  The process 
# will be repeated to the year 2050. 

# In this script, WATER DISTRICT land growth is estimated.  A raster stack of the 'districts', 'distance', 'potential', 
# 'irrigated', 'developed', and 'counties' layers is created. The stack serves to align all of the rasters together.

# Using the stack, the steps are to take the cells that are potentially developable, have the minimum distance (but 
# greater than 0) from developed lands, and are irrigated (irrigated prioritized first, then non-irrigated) and 
# reclassify (convert) them from Potentially Developable to Developed.  The number of cells to reclassify for each 
# year can be found in the file 'district-cells-to-reclassify.csv'.

# Will reclassify 'developed' from 0 to 1 for the number of cells specified.
# Will reclassify 'potential' from 1 to 0 for the number of cells specified.

# These steps require a lot of memory to process, so the procedure is completed in multiple scripts.  See 
# 'land-development-mapping-part1.R' and 'land-development-mapping-part2.R'

# Check the working directory
# - DO NOT hard code a path
# - R Studio only opens in the correct working directory if double-click on R file, not File ... Open.
# - Therefore, look for this R file in the workding directory and exit if not found.
# - Run the R script from command line or TSTool RunR() to ensure working directory is correct.
# setwd ("E:\\Data\\data-processing\\11-Map-LandDevelopment\\")
wd <- getwd()
cat("Working directory: ", wd, "\n")
r_file = "land-development-mapping-part3.R"
if ( !file.exists(r_file) ) {
  stop(cat("Expected R file (", r_file, ") does not exist.  Working directory is incorrect.\n"))
}

# Load required packages
library(dplyr) # For data manipulation and organization
library(rgdal)  # Used for reading in raster files
library(raster) # Used to create, manipulate, and export raster data

# Clear the workspace 
rm(list=ls())

# Set global option for reading files
options(stringsAsFactors=FALSE)


# 1)  Read in data
# a. Read in virtual raster created in '01-Calculate-Municipal-WaterDistrictAreas'
filename = "../01-Calculate-Municipal-WaterDistrictAreas/Virtual_Raster.tif"
# Create RasterLayers from bands

munis = raster(filename, band=1)
# Check the properties
munis
# Plot if desired (commented out)
#plot(munis, main = "Front Range Municipalities")

districts = raster(filename, band=2)
# Check the properties
districts
# Plot if desired (commented out)
#plot(districts, main = "Front Range Water Providers")

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

distance = raster("Distance_WaterDistricts.tif", band=1)
# Check the properties
distance
# Plot
plot(distance, main = "Distance from Water Districts")


# b. Read in csv of cells to reclassify
district_reclass = read.csv("district-cells-to-reclassify.csv", header = TRUE)
# Filter out 2018 data
district_reclass = district_reclass %>%
  filter(Year != 2018)


# 2)  Take the LandDevelopment raster ('landdev') and create two new rasters, one of "Developed" land and one of 
# "Potentially Developable" land.
# a.
developed = landdev == 2

# b.
potential = landdev == 1


# 3) Filter the 'districts' raster to only the districts used in the analysis.  Set all other districts to NA.
# Get unique values of districts in the raster
new = unique(districts)
new = as.data.frame(new)
# Get unique values of districts in 'district-reclass'
new2 = unique(district_reclass$Raster_ID)
new2 = as.data.frame(new2)
# Filter out new by new2
new3 = new %>% 
  filter(!new %in% new2$new2)
# Convert unused districts to NA
for (district in unique(new3$new)) {
  districts[districts == district] = NA
}


# 4)  Create a RasterStack of 'munis', districts', distance', 'potential', 'irrig', 'developed', and 'counties'
landgrowth = stack(munis, districts, distance, potential, irrig, developed, counties)


# 5) Extract the data based on the 'districts' raster to be able to see it in table form and filter cells to what is 
# needed
# Vectorize the 'districts' raster to use for extracting data
district_vector = rasterToPoints(districts, spatial = TRUE)
landgrowth_vector = raster::extract(landgrowth, district_vector, sp = TRUE, cellnumbers = TRUE) 
# sp = TRUE means to keep as a spatial points data frame (SPDF); cellnumbers serve as identifiers 


# 6)  Edit data to have specific column names
landgrowth_vector@data = landgrowth_vector@data %>%
  rename(Cell_Number = cells, Municipality = Virtual_Raster.1, WaterDistrict = Virtual_Raster.2, 
         Distance_from_Developed = Distance_WaterDistricts, Potentially_Developable = layer.1, 
         Irrigated_Lands = Virtual_Raster.3, Developed = layer.2, County = Virtual_Raster.4) %>%
  dplyr::select(-Virtual_Raster) # Delete duplicate column

# Add a Year column to be used later; fill with 2018 to represent current boundaries.
landgrowth_vector@data$Year = 2018


# 7) Extract number of cells to reclassify for each water provider/county combo and for the density options and years.
# For each year, merge the points selected for development and assign those rows a value of #### in the Year column.

# For loops to iterate over year, water provider, and county
# 'unique(dataobject$variablename) provides the unique values of that variable that are iterated over 
dat = list()
dat[['2018']] = landgrowth_vector@data
for (year in unique(district_reclass$Year)) {
    temp = district_reclass[which(district_reclass$Year == year), ]
    for (provider in unique(temp$Raster_ID)) {
      temp2 = temp[which(temp$Raster_ID == provider), ]
      for (county in unique(temp2$County_ID)) {
        temp3 = temp2[which(temp2$County_ID == county), ]
        n = temp3$Cells_to_Reclassify
        dat[[toString(year)]][[toString(provider)]][[toString(county)]] = dat[['2018']] %>%
          filter(WaterDistrict == provider,
                 County == county,
                 #Municipality == 1,  # Makes sure development doesn't occur on overlapping municipal land
                 Developed == 0,
                 Potentially_Developable == 1,
                 Distance_from_Developed > 0) %>%
          arrange(WaterDistrict, desc(Irrigated_Lands), Distance_from_Developed) %>%
          .[0:n, ] %>% # Selects the top 'n' rows, which will be reclassified
          mutate(Year = year) %>%
          mutate(Potentially_Developable = Potentially_Developable - 1) %>% # Cells are no longer developable
          mutate(Developed = Developed + 1) # Cells are now considered Developed
        # Substitute in the new values (with new year) to dat[['2018']] so that they can't be selected again
        dat[['2018']] %<>%
          filter(!Cell_Number %in% dat[[toString(year)]][[toString(provider)]][[toString(county)]]$Cell_Number) %>%
          bind_rows(dat[[toString(year)]][[toString(provider)]][[toString(county)]])
      }
    }
    print(year)
}

# Convert dat[['2018']] to a matrix
temp4 = as.matrix(dat[['2018']])
# Create an empty RasterBrick that will be filled with the values of the matrix
# See: https://stat.ethz.ch/pipermail/r-sig-geo/2010-July/008749.html
brick = brick(nrows=2964, ncols=1545)
id = data.frame(cell = 1:ncell(brick))
# Fill with values of the matrix
idv = merge(id, temp4, by=1, all.x = TRUE)
brick = setValues(brick, as.matrix(idv))
# Set the projection, extent, and resolution to match other rasters
projection(brick) = "+proj=utm +zone=13 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
xmin(brick) = 472373.1
xmax(brick) = 679549.2
ymin(brick) = 4145741
ymax(brick) = 4543198
res(brick) = 134.0946

# Drop the cell number layer and 'munis' layer.
brick = dropLayer(brick, 1)
brick = dropLayer(brick, 1)

# Write raster
writeRaster(brick, filename = "District_Growth.tif", format = "GTiff", bandorder = "BIL", overwrite = TRUE)



