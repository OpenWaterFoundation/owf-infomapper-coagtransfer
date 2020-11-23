# Convert new land growth in square miles to number of raster cells to reclassify from "Potentially Developable" to
# "Developed"

# Check the working directory
# - DO NOT hard code a path
# - R Studio only opens in the correct working directory if double-click on R file, not File ... Open.
# - Therefore, look for this R file in the workding directory and exit if not found.
# - Run the R script from command line or TSTool RunR() to ensure working directory is correct.
# setwd("E:\\Data\\data-processing\\11-Map-LandDevelopment\\")
wd <- getwd()
cat("Working directory: ", wd, "\n")
r_file = "convert-area-to-raster-cells.R"
if ( !file.exists(r_file) ) {
  stop(cat("Expected R file (", r_file, ") does not exist.  Working directory is incorrect.\n"))
}

# Load required packages
library(dplyr)  # For data manipulation and clean-up
library(tidyr)  # For data manipulation and clean-up
library(ggplot2) # For data visualizations

# Clear the workspace 
rm(list=ls())

# Set global option for reading files
options(stringsAsFactors=FALSE)


# 1) Read in data
# a. Read land area growth calculated in '03-Calculate-LandAreaGrowth\\land-area-growth.R' for municipalities and in 
# '08-Calculate-WaterDistrict-LandGrowth\\district-land-area-growth.R' for water districts
muni_growth = read.csv("..\\04-Calculate-FutureMunicipalDensity\\municipal-land-area-growth.csv", header=TRUE)
head(muni_growth)

district_growth = read.csv("district-land-area-growth.csv", header=TRUE)
head(district_growth)
# The columns of interest are 'New_Growth_sqmiles'

# b. Read in CSVs associated with the Municipality, WaterProviders, and County rasters to match raster 'IDs'
muni_names = read.csv("..\\..\\data-orig\\Rasters\\Municipality.csv", header = TRUE)
head(muni_names)
district_names = read.csv("..\\..\\data-orig\\Rasters\\WaterProviders.csv", header = TRUE)
head(district_names)
county_names = read.csv("..\\..\\data-orig\\Rasters\\County.csv", header = TRUE)
head(county_names)


# 2) Convert square miles to cells for both datasets.  Each cell is 0.0069 square miles.
muni_growth = muni_growth %>%
  mutate(Cells_to_Reclassify = New_Growth_sqmiles / 0.0069) %>%
  rename(WaterProvider = MunicipalityName) # Rename to match district_growth dataset

# Round to nearest whole number
muni_growth$Cells_to_Reclassify = round(muni_growth$Cells_to_Reclassify, digits = 0)

district_growth = district_growth %>%
  mutate(Cells_to_Reclassify = New_Growth_sqmiles / 0.0069)
# Round to nearest whole number
district_growth$Cells_to_Reclassify = round(district_growth$Cells_to_Reclassify, digits = 0)


# 3) Join muni, water district, and county IDs to datasets
muni_growth = left_join(muni_growth, muni_names, by = c("WaterProvider" = "cityname"))
muni_growth = left_join(muni_growth, county_names, by = c("County" = "NAME"))
muni_growth = muni_growth %>%
  rename(Raster_ID = Value.x) %>%
  rename(County_ID = Value.y)

district_growth = left_join(district_growth, district_names, by = c("WaterProvider" = "Name"))
district_growth = left_join(district_growth, county_names, by = c("County" = "NAME"))
district_growth = district_growth %>%
  rename(Raster_ID = Value.x) %>%
  rename(County_ID = Value.y)


# 4) Export data
write.csv(muni_growth, "municipal-cells-to-reclassify.csv", row.names = FALSE)
write.csv(district_growth, "district-cells-to-reclassify.csv", row.names = FALSE)

