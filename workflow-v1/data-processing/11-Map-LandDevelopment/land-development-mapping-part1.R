# Estimating land growth onto irrigated lands, Part 1.

# Background:  the objective is to take the amount of annual new growth in square miles for each water provider 
# and convert the amount to a count of cells/pixels in the raster.  The cells need to belong to the Land Development 
# category of "Potentially Developable".  Those cells will then be reclassified as "Developed", creating a new raster 
# of land development.  This new raster will then be used to estimate land growth for the following year.  The process 
# will be repeated to the year 2050. 

# In this script, the LandDevelopment raster is split into two new rasters, one of "Developed" land and one of 
# "Potentially Developable" land.  New land growth can only occur on the "Potentially Developable" raster. 

# Masks are created for each water provider to limit analysis to within municipal/district boundaries.  This ensures 
# that growth is associated with the correct water provider.

# Using the mask, the distance of cells from the "Developed" raster is calculated, creating a new 
# "distance" raster.  The distance raster is saved as a spatial GeoTIFF file.

# A raster stack of the 'munis', 'distance', 'potential', 'irrigated', 'developed', and 'counties' layers is created.  
# The stack serves to align all of the rasters together.

# Using the stack, the steps are to take the cells that are potentially developable, have the minimum distance (but 
# greater than 0) from developed lands, and are irrigated (irrigated prioritized first, then non-irrigated) and 
# reclassify (convert) them from Potentially Developable to Developed.  The number of cells to reclassify for each 
# year can be found in the files 'municipal-cells-to-reclassify.csv' and 'district-cells-to-reclassify.csv'.

# Will reclassify 'developed' from 0 to 1 for the number of cells specified.
# Will reclassify 'potential' from 1 to 0 for the number of cells specified.

# These steps require a lot of memory to process, so the procedure is completed in multiple scripts.  See 
# 'land-development-mapping-part2.R' and 'land-development-mapping-part3.R'

# Check the working directory
# - DO NOT hard code a path
# - R Studio only opens in the correct working directory if double-click on R file, not File ... Open.
# - Therefore, look for this R file in the workding directory and exit if not found.
# - Run the R script from command line or TSTool RunR() to ensure working directory is correct.
# setwd ("E:\\Data\\data-processing\\11-Map-LandDevelopment\\")
wd <- getwd()
cat("Working directory: ", wd, "\n")
r_file = "land-development-mapping-part1.R"
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
# Read in virtual raster created in '01-Calculate-Municipal-WaterDistrictAreas'
filename = "../01-Calculate-Municipal-WaterDistrictAreas/Virtual_Raster.tif"
# Create RasterLayers from each band
munis = raster(filename, band=1)
# Check the properties; should be a RasterLayer
munis
# Plot data to make sure it looks right
plot(munis, main = "Front Range Municipalities")

districts = raster(filename, band=2)
# Check the properties
districts
# Plot
plot(districts, main = "Front Range Water Providers")

landdev = raster(filename, band=5)
# Check the properties
landdev
# Plot
plot(landdev, main = "Land Development")


# 2)  Take the LandDevelopment raster ('landdev') and create two new rasters, one of "Developed" land and one of 
# "Potentially Developable" land.
# a.
developed = landdev == 2
plot(developed, main = "Developed Land")

# b.
potential = landdev == 1
plot(potential, main = "Potentially Developable Land")


# Steps 3-7 are done for each municipality and steps 8-12 repeat the process, but for water districts.
# MUNICIPALITIES
muni_distance_list = list() # Create an empty list which will contain rasters of distance for each municipality
for (muni in unique(munis)) {
  
# 3) Create mask of developed land for each municipality to limit analysis to within municipal boundaries. 
# Syntax is:  mask(x, mask, filename="", inverse=FALSE, maskvalue=NA, updatevalue=NA, updateNA=FALSE)
# where x = raster object; mask = raster object to use as a mask; filename = optional output filename; inverse = 
# logical, where if TRUE, areas on mask that are not the maskvalue are masked; maskvalue = the value in mask that 
# indicates the cells of x that should become updatevalue; updatevalue = the value that cells of x should become if 
# they are not covered by mask (and not NA); updateNA = logical, where if TRUE, NA values outside the masked area are
# also updated to the updatevalue (only relevant if the updatevalue is not NA).
developed_mask = mask(developed, munis, inverse = TRUE, maskvalue = muni)


# 4) Calculate distance of cells from the Developed/Not Developable layer ('developed') created in step 2a using the 
# mask created in step 3.  Generates a raster layer of distance to features in 'developed'.
distance = gridDistance(developed_mask, origin = 1, omit = NA) # '1' for origin is the value of the cells from which 
                                                               # distance is calculated
# Write the distance raster to the empty list
muni_distance_list[[toString(muni)]] = distance
print(muni) # Prints when each muni is done to get a sense of how long process takes
}


# 5) Create a temporary object that will take each distance raster, convert it to a matrix, and set NAs to zeroes.
dist_temp = list()
for (i in seq_along(muni_distance_list)) {
  dist_temp[[i]] = as.matrix(muni_distance_list[[i]])
  dist_temp[[i]][is.na(dist_temp[[i]])] = 0
}


# 6) Add all of the rasters (which are currently matrices) in 'dist_temp' together to have one complete 
# matrix of distance
distance_munis = Reduce("+", dist_temp)
# Convert the matrix to a raster
distance_raster = raster(distance_munis)
# Set the projection, extent, and resolution to match other rasters
projection(distance_raster) = "+proj=utm +zone=13 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
xmin(distance_raster) = 472373.1
xmax(distance_raster) = 679549.2
ymin(distance_raster) = 4145741
ymax(distance_raster) = 4543198
res(distance_raster) = 134.0946


# 7) Save 'distance_raster' for future use (commented out since the process has been done)
# TODO smalers 2020-11-23 maybe check for existence or otherwise decide when to write, need to write if first time or data change.
writeRaster(distance_raster, filename = "Distance_Municipalities.tif", format = "GTiff", bandorder = "BIL", overwrite = TRUE)

#########################################################
# WATER DISTRICTS
district_distance_list = list() # Create an empty list which will contain rasters of distance for each water district
for (district in unique(districts)) {
  
# 8) Create mask of developed land for each district to limit analysis to within district boundaries.
developed_mask_districts = mask(developed, districts, inverse = TRUE, maskvalue = district)

  
# 9) Calculate distance of cells from the Developed/Not Developable layer ('developed') created in step 2a using the 
# mask created in step 8.  Generates a raster layer of distance to features in 'developed'.
distance_districts = gridDistance(developed_mask_districts, origin = 1, omit = NA)
# Write the distance raster to the empty list
district_distance_list[[toString(district)]] = distance_districts
print(district) # Prints when each district is done to get a sense of how long process takes
}


# 10) Create a temporary object that will take each distance raster, convert it to a matrix, and set NAs to zeroes.
dist_temp_2 = list()
for (i in seq_along(district_distance_list)) {
  dist_temp_2[[i]] = as.matrix(district_distance_list[[i]])
  dist_temp_2[[i]][is.na(dist_temp_2[[i]])] = 0
}


# 11) Add all of the rasters (which are currently matrices) in 'dist_temp_2' together to have one complete 
# matrix of distance
distance_districts = Reduce("+", dist_temp_2)
# Convert the matrix to a raster
distance_districts_raster = raster(distance_districts)
# Set the projection, extent, and resolution to match other rasters
projection(distance_districts_raster) = "+proj=utm +zone=13 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
xmin(distance_districts_raster) = 472373.1
xmax(distance_districts_raster) = 679549.2
ymin(distance_districts_raster) = 4145741
ymax(distance_districts_raster) = 4543198
res(distance_districts_raster) = 134.0946


# 12) Save 'distance_districts_raster' for future use (commented out since the process has been done)
# TODO smalers 2020-11-23 maybe check for existence or otherwise decide when to write, need to write if first time or data change.
writeRaster(distance_districts_raster, filename = "Distance_WaterDistricts.tif", format = "GTiff", bandorder = "BIL", overwrite = TRUE)


